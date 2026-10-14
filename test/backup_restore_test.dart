import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/repositories/inventory_repository.dart';
import 'package:bawa/data/repositories/trips_repository.dart';
import 'package:bawa/data/services/asset_storage_service.dart';
import 'package:bawa/data/services/backup_service.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  late Directory tempBaseDir;
  late AppDatabase db;
  late AssetStorageService assetService;
  late BackupService backupService;
  late InventoryRepository inventoryRepo;
  late TripsRepository tripsRepo;

  setUp(() async {
    tempBaseDir = await Directory.systemTemp.createTemp('bawa_backup_test_');

    // Create live sqlite file in temp base dir
    final liveDbFile = File(p.join(tempBaseDir.path, 'bawa.sqlite'));
    db = AppDatabase(NativeDatabase(liveDbFile));

    assetService = AssetStorageService(db, baseDirOverride: tempBaseDir);
    backupService = BackupService(
      db,
      assetService,
      baseDirectoryOverride: tempBaseDir,
    );
    inventoryRepo = InventoryRepository(db);
    tripsRepo = TripsRepository(db);
  });

  tearDown(() async {
    await db.close();
    if (await tempBaseDir.exists()) {
      await tempBaseDir.delete(recursive: true);
    }
  });

  group('TECH-01 & BAK: Cadangan Konsisten dan Pemulihan (Backup & Restore)', () {
    test('QA-39: Ekspor backup konsisten menghasilkan arsip ZIP lengkap dengan checksum dan manifest', () async {
      // 1. Tambah data master inventaris & perjalanan
      await inventoryRepo.createItem(
        name: 'Kamera Mirrorless',
        quantity: 2,
        unit: 'unit',
      );
      await tripsRepo.createTrip(
        name: 'Perjalanan Jepang',
        startDate: '2026-12-01',
        stops: ['Tokyo', 'Kyoto'],
      );

      // 2. Tambah aset dummy
      final assetsDir = await assetService.getAssetsDirectory();
      final dummyAssetFile = File(p.join(assetsDir.path, 'test_photo.jpg'));
      final dummyBytes = utf8.encode('dummy-photo-content');
      await dummyAssetFile.writeAsBytes(dummyBytes, flush: true);

      final assetSha = sha256.convert(dummyBytes).toString();
      await db.into(db.assets).insert(
            AssetsCompanion.insert(
              id: 'asset-test-1',
              relativePath: 'assets/test_photo.jpg',
              mimeType: 'image/jpeg',
              sizeBytes: dummyBytes.length,
              sha256: assetSha,
              originalName: 'kamera.jpg',
              kind: 'item_photo',
              createdAt: DateTime.now().toIso8601String(),
            ),
          );

      // 3. Eksekusi pembuatan arsip backup
      final zipFile = await backupService.createBackupArchive();
      expect(await zipFile.exists(), isTrue);
      expect(await zipFile.length(), greaterThan(0));

      // 4. Periksa isi ZIP
      final zipBytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(zipBytes);

      final fileNames = archive.map((f) => f.name).toList();
      expect(fileNames.contains('manifest.json'), isTrue);
      expect(fileNames.contains('database.sqlite'), isTrue);
      expect(fileNames.contains('assets/test_photo.jpg'), isTrue);

      // 5. Validasi manifest
      final manifestEntry = archive.firstWhere((f) => f.name == 'manifest.json');
      final manifestMap = jsonDecode(utf8.decode(manifestEntry.content as List<int>)) as Map<String, dynamic>;
      final manifest = BackupManifest.fromJson(manifestMap);

      expect(manifest.format, 'siapkan_tas_backup');
      expect(manifest.schemaVersion, db.schemaVersion);
      expect(manifest.entityCounts['items'], greaterThanOrEqualTo(1));
      expect(manifest.entityCounts['trips'], greaterThanOrEqualTo(1));
      expect(manifest.assets.any((a) => a.originalName == 'kamera.jpg'), isTrue);
    });

    test('QA-41: Pembatalan file picker tidak mencatat backup sebagai sukses', () async {
      final initialDate = await backupService.getLastBackupDate();
      expect(initialDate, isNull);

      // Simulasi user klik cancel pada file picker
      final result = await backupService.exportBackupWithFilePicker(
        customFileSaver: (suggestedFileName, bytes) async {
          return null; // Pengguna membatalkan
        },
      );

      expect(result, isNull);
      final afterCancelDate = await backupService.getLastBackupDate();
      expect(afterCancelDate, isNull);
    });

    test('QA-41: Keberhasilan ekspor mencatat riwayat ekspor cadangan ke AppSettings', () async {
      final savedPath = await backupService.exportBackupWithFilePicker(
        customFileSaver: (suggestedFileName, bytes) async {
          final dest = File(p.join(tempBaseDir.path, suggestedFileName));
          await dest.writeAsBytes(bytes);
          return dest.path;
        },
      );

      expect(savedPath, isNotNull);
      final lastDate = await backupService.getLastBackupDate();
      expect(lastDate, isNotNull);
      expect(DateTime.parse(lastDate!).isBefore(DateTime.now().add(const Duration(seconds: 1))), isTrue);
    });

    test('QA-42: Tolak arsip yang mengandung Path Traversal berbahaya', () async {
      // Buat arsip jahat dengan entry "../evil.txt"
      final evilArchive = Archive();
      final evilContent = utf8.encode('evil data');
      evilArchive.addFile(ArchiveFile('../evil.txt', evilContent.length, evilContent));

      final evilZipData = ZipEncoder().encode(evilArchive);
      final evilZipFile = File(p.join(tempBaseDir.path, 'evil.zip'));
      await evilZipFile.writeAsBytes(evilZipData);

      await expectLater(
        backupService.inspectArchive(evilZipFile),
        throwsA(isA<PathTraversalException>()),
      );
    });

    test('QA-42: Tolak arsip yang tidak memiliki manifest.json', () async {
      final invalidArchive = Archive();
      final dummy = utf8.encode('just a file');
      invalidArchive.addFile(ArchiveFile('random.txt', dummy.length, dummy));

      final zipData = ZipEncoder().encode(invalidArchive);
      final invalidZip = File(p.join(tempBaseDir.path, 'no_manifest.zip'));
      await invalidZip.writeAsBytes(zipData);

      await expectLater(
        backupService.inspectArchive(invalidZip),
        throwsA(isA<MissingManifestException>()),
      );
    });

    test('QA-42: Tolak arsip jika versi skema lebih baru dari versi aplikasi saat ini', () async {
      // Buat backup normal terlebih dahulu
      final zipFile = await backupService.createBackupArchive();
      final zipBytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(zipBytes);

      // Modifikasi manifest.json dengan schemaVersion = 99
      final newArchive = Archive();
      for (final f in archive) {
        if (f.name == 'manifest.json') {
          final originalJson = jsonDecode(utf8.decode(f.content as List<int>)) as Map<String, dynamic>;
          originalJson['schemaVersion'] = 99;
          final modifiedBytes = utf8.encode(jsonEncode(originalJson));
          newArchive.addFile(ArchiveFile('manifest.json', modifiedBytes.length, modifiedBytes));
        } else {
          newArchive.addFile(f);
        }
      }

      final futureZip = File(p.join(tempBaseDir.path, 'future_version.zip'));
      await futureZip.writeAsBytes(ZipEncoder().encode(newArchive));

      await expectLater(
        backupService.inspectArchive(futureZip),
        throwsA(isA<IncompatibleVersionException>()),
      );
    });

    test('QA-42: Tolak arsip jika checksum database tidak cocok (arsip termodifikasi/rusak)', () async {
      final zipFile = await backupService.createBackupArchive();
      final zipBytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(zipBytes);

      // Rusak isi database.sqlite
      final tamperedArchive = Archive();
      for (final f in archive) {
        if (f.name == 'database.sqlite') {
          final corruptBytes = utf8.encode('corrupted sqlite bytes');
          tamperedArchive.addFile(ArchiveFile('database.sqlite', corruptBytes.length, corruptBytes));
        } else {
          tamperedArchive.addFile(f);
        }
      }

      final corruptZip = File(p.join(tempBaseDir.path, 'corrupt.zip'));
      await corruptZip.writeAsBytes(ZipEncoder().encode(tamperedArchive));

      await expectLater(
        backupService.inspectArchive(corruptZip),
        throwsA(isA<CorruptedArchiveException>()),
      );
    });

    test('QA-38 & BAK-05: Restore Replace-All memulihkan data dan aset secara utuh', () async {
      // 1. Masukkan data ke Database A
      await inventoryRepo.createItem(
        name: 'Paspor RI',
        quantity: 1,
        unit: 'buah',
      );
      await tripsRepo.createTrip(
        name: 'Trip Singapura',
        startDate: '2026-11-15',
        stops: ['Singapura'],
      );

      // Simpan aset
      final assetsDir = await assetService.getAssetsDirectory();
      final assetFile = File(p.join(assetsDir.path, 'passport.jpg'));
      final assetContent = utf8.encode('passport-photo-bytes');
      await assetFile.writeAsBytes(assetContent, flush: true);

      await db.into(db.assets).insert(
            AssetsCompanion.insert(
              id: 'asset-passport',
              relativePath: 'assets/passport.jpg',
              mimeType: 'image/jpeg',
              sizeBytes: assetContent.length,
              sha256: sha256.convert(assetContent).toString(),
              originalName: 'passport.jpg',
              kind: 'item_photo',
              createdAt: DateTime.now().toIso8601String(),
            ),
          );

      // 2. Buat backup arsip dari keadaan A
      final backupArchive = await backupService.createBackupArchive();

      // 3. Sekarang ubah/rusak data di keadaan B (hapus semua item, tambah item lain)
      await (db.delete(db.items)).go();
      await (db.delete(db.trips)).go();
      await (db.delete(db.assets)).go();
      if (await assetFile.exists()) {
        await assetFile.delete();
      }

      await inventoryRepo.createItem(
        name: 'Barang Keadaan B',
        quantity: 99,
        unit: 'buah',
      );

      // Verifikasi bahwa database sekarang berada di keadaan B
      final itemsStateB = await db.select(db.items).get();
      expect(itemsStateB.length, 1);
      expect(itemsStateB.first.name, 'Barang Keadaan B');

      // 4. Lakukan inspeksi dan pemulihan (Restore) dari backup arsip keadaan A
      final preview = await backupService.inspectArchive(backupArchive);
      expect(preview.itemCount, greaterThanOrEqualTo(1));
      expect(preview.tripCount, 1);

      await backupService.restoreFromBackup(
        preview,
        onBeforeReplace: () async {
          await db.close();
        },
        onAfterReplace: () async {
          final liveDbFile = File(p.join(tempBaseDir.path, 'bawa.sqlite'));
          db = AppDatabase(NativeDatabase(liveDbFile));
          inventoryRepo = InventoryRepository(db);
          tripsRepo = TripsRepository(db);
        },
      );

      // 5. Verifikasi bahwa data keadaan A pulih sepenuhnya!
      final restoredItems = await db.select(db.items).get();
      expect(restoredItems.any((i) => i.name == 'Paspor RI'), isTrue);
      expect(restoredItems.any((i) => i.name == 'Barang Keadaan B'), isFalse);

      final restoredTrips = await db.select(db.trips).get();
      expect(restoredTrips.any((t) => t.name == 'Trip Singapura'), isTrue);

      final restoredAsset = File(p.join(assetsDir.path, 'passport.jpg'));
      expect(await restoredAsset.exists(), isTrue);
      expect(await restoredAsset.readAsString(), 'passport-photo-bytes');
    });

    test('QA-43: Pemulihan startup jika proses restore sebelumnya crash/terputus', () async {
      // 1. Siapkan data live
      await inventoryRepo.createItem(
        name: 'Laptop Kerja',
        quantity: 1,
        unit: 'unit',
      );

      // 2. Simulasikan crash di tengah restore:
      // Buat folder backup_rollback berisi salinan asli, dan buat file restore_journal.json
      final rollbackDir = Directory(p.join(tempBaseDir.path, 'backup_rollback'));
      await rollbackDir.create(recursive: true);

      final liveDb = File(p.join(tempBaseDir.path, 'bawa.sqlite'));
      await liveDb.copy(p.join(rollbackDir.path, 'bawa.sqlite'));

      final journal = File(p.join(tempBaseDir.path, 'restore_journal.json'));
      await journal.writeAsString(jsonEncode({'stage': 'applying_restore'}));

      // Rusak live database
      await db.close();
      await liveDb.writeAsString('corrupted database file from crash');

      // 3. Jalankan startup recovery check
      final recovered = await backupService.checkAndRecoverInterruptedRestore(
        onAfterRecover: () async {
          db = AppDatabase(NativeDatabase(liveDb));
        },
      );

      expect(recovered, isTrue);
      expect(await journal.exists(), isFalse);
      expect(await rollbackDir.exists(), isFalse);

      // 4. Verifikasi bahwa data live berhasil pulih ke kondisi sebelum crash
      final items = await db.select(db.items).get();
      expect(items.any((i) => i.name == 'Laptop Kerja'), isTrue);
    });
  });
}
