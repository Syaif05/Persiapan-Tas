import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/app_database.dart';
import '../repositories/reminders_repository.dart';
import 'asset_storage_service.dart';

/// Exception umum untuk error operasi backup & restore
class BackupException implements Exception {
  final String message;
  const BackupException(this.message);

  @override
  String toString() => message;
}

class PathTraversalException extends BackupException {
  const PathTraversalException(super.message);
}

class ZipBombException extends BackupException {
  const ZipBombException(super.message);
}

class IncompatibleVersionException extends BackupException {
  const IncompatibleVersionException(super.message);
}

class CorruptedArchiveException extends BackupException {
  const CorruptedArchiveException(super.message);
}

class MissingManifestException extends BackupException {
  const MissingManifestException(super.message);
}

/// Metadata file aset di dalam cadangan
class BackupAssetInfo {
  final String id;
  final String relativePath;
  final String sha256;
  final int sizeBytes;
  final String originalName;
  final String kind;
  final bool missing;

  const BackupAssetInfo({
    required this.id,
    required this.relativePath,
    required this.sha256,
    required this.sizeBytes,
    required this.originalName,
    required this.kind,
    this.missing = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'relativePath': relativePath,
        'sha256': sha256,
        'sizeBytes': sizeBytes,
        'originalName': originalName,
        'kind': kind,
        'missing': missing,
      };

  factory BackupAssetInfo.fromJson(Map<String, dynamic> json) => BackupAssetInfo(
        id: json['id'] as String? ?? '',
        relativePath: json['relativePath'] as String? ?? '',
        sha256: json['sha256'] as String? ?? '',
        sizeBytes: json['sizeBytes'] as int? ?? 0,
        originalName: json['originalName'] as String? ?? '',
        kind: json['kind'] as String? ?? '',
        missing: json['missing'] as bool? ?? false,
      );
}

/// Manifest informasi arsip backup (BAK-01, BAK-04)
class BackupManifest {
  static const String currentFormat = 'siapkan_tas_backup';
  static const int currentFormatVersion = 1;

  final String format;
  final int formatVersion;
  final String appVersion;
  final int schemaVersion;
  final String createdAt;
  final String databaseChecksum;
  final Map<String, int> entityCounts;
  final List<BackupAssetInfo> assets;

  const BackupManifest({
    required this.format,
    required this.formatVersion,
    required this.appVersion,
    required this.schemaVersion,
    required this.createdAt,
    required this.databaseChecksum,
    required this.entityCounts,
    required this.assets,
  });

  Map<String, dynamic> toJson() => {
        'format': format,
        'formatVersion': formatVersion,
        'appVersion': appVersion,
        'schemaVersion': schemaVersion,
        'createdAt': createdAt,
        'databaseChecksum': databaseChecksum,
        'entityCounts': entityCounts,
        'assets': assets.map((a) => a.toJson()).toList(),
      };

  factory BackupManifest.fromJson(Map<String, dynamic> json) {
    final format = json['format'] as String? ?? '';
    if (format != currentFormat) {
      throw CorruptedArchiveException('Format cadangan tidak dikenal: "$format"');
    }

    final assetsJson = json['assets'] as List<dynamic>? ?? [];
    final assets = assetsJson
        .map((a) => BackupAssetInfo.fromJson(a as Map<String, dynamic>))
        .toList();

    final countsJson = json['entityCounts'] as Map<String, dynamic>? ?? {};
    final entityCounts = countsJson.map((k, v) => MapEntry(k, v as int? ?? 0));

    return BackupManifest(
      format: format,
      formatVersion: json['formatVersion'] as int? ?? 1,
      appVersion: json['appVersion'] as String? ?? '1.0.0',
      schemaVersion: json['schemaVersion'] as int? ?? 1,
      createdAt: json['createdAt'] as String? ?? '',
      databaseChecksum: json['databaseChecksum'] as String? ?? '',
      entityCounts: entityCounts,
      assets: assets,
    );
  }
}

/// Pratinjau hasil inspeksi file arsip sebelum restore diterapkan (BAK-03)
class BackupPreviewInfo {
  final BackupManifest manifest;
  final Directory stagingDirectory;
  final File databaseFile;
  final List<String> warnings;
  final int totalArchiveBytes;

  const BackupPreviewInfo({
    required this.manifest,
    required this.stagingDirectory,
    required this.databaseFile,
    required this.warnings,
    required this.totalArchiveBytes,
  });

  int get itemCount => manifest.entityCounts['items'] ?? 0;
  int get tripCount => manifest.entityCounts['trips'] ?? 0;
  int get assetCount => manifest.assets.length;
  int get ticketCount => manifest.entityCounts['tickets'] ?? 0;
  int get scheduleCount => manifest.entityCounts['scheduleEvents'] ?? 0;

  String get formattedDate {
    if (manifest.createdAt.isEmpty) return '-';
    try {
      final dt = DateTime.parse(manifest.createdAt).toLocal();
      return DateFormat('dd MMMM yyyy, HH:mm', 'id').format(dt);
    } catch (_) {
      return manifest.createdAt;
    }
  }
}

/// Service manajemen backup dan restore offline yang konsisten dan tahan crash (TECH-01)
class BackupService {
  final AppDatabase _db;
  final AssetStorageService _assetStorageService;
  final RemindersRepository? remindersRepository;
  final Directory? baseDirectoryOverride;

  static const int maxTotalExtractionBytes = 500 * 1024 * 1024; // 500 MB
  static const int maxSingleFileBytes = 50 * 1024 * 1024; // 50 MB

  BackupService(
    this._db,
    this._assetStorageService, {
    this.remindersRepository,
    this.baseDirectoryOverride,
  });

  Future<Directory> getBaseDirectory() async {
    final override = baseDirectoryOverride;
    if (override != null) return override;
    return await getApplicationDocumentsDirectory();
  }

  Future<File> getLiveDatabaseFile() async {
    final base = await getBaseDirectory();
    return File(p.join(base.path, 'bawa.sqlite'));
  }

  /// Membaca waktu ekspor terakhir dari AppSettings (BAK-07)
  Future<String?> getLastBackupDate() async {
    final setting = await (_db.select(_db.appSettings)
          ..where((s) => s.key.equals('last_backup_at')))
        .getSingleOrNull();
    return setting?.value;
  }

  /// Mencatat status ekspor cadangan ke AppSettings (BAK-07)
  Future<void> recordBackupSuccess(DateTime timestamp) async {
    final iso = timestamp.toIso8601String();
    await _db.into(_db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: 'last_backup_at',
            value: iso,
          ),
        );
  }

  /// Membuat snapshot konsisten SQLite menggunakan VACUUM INTO (TECH-01, QA-39)
  Future<void> _createConsistentDatabaseSnapshot(File targetFile) async {
    if (await targetFile.exists()) {
      await targetFile.delete();
    }

    final parentDir = targetFile.parent;
    if (!await parentDir.exists()) {
      await parentDir.create(recursive: true);
    }

    try {
      final escaped = targetFile.path.replaceAll("'", "''");
      await _db.customStatement("VACUUM INTO '$escaped';");
    } catch (e) {
      // Fallback untuk driver SQLite yang belum mendukung VACUUM INTO pada file memory
      await _db.customStatement('PRAGMA wal_checkpoint(TRUNCATE);');
      final liveFile = await getLiveDatabaseFile();
      if (await liveFile.exists()) {
        await liveFile.copy(targetFile.path);
      } else {
        rethrow;
      }
    }
  }

  /// Menghitung SHA-256 dari sebuah file
  Future<String> _computeSha256(File file) async {
    final bytes = await file.readAsBytes();
    return sha256.convert(bytes).toString();
  }

  /// Mengumpulkan jumlah entitas database aktif untuk manifest (BAK-01)
  Future<Map<String, int>> _gatherEntityCounts() async {
    final counts = <String, int>{};
    counts['items'] = (await _db.select(_db.items).get()).length;
    counts['storageLocations'] = (await _db.select(_db.storageLocations).get()).length;
    counts['categories'] = (await _db.select(_db.categories).get()).length;
    counts['trips'] = (await _db.select(_db.trips).get()).length;
    counts['tripItems'] = (await _db.select(_db.tripItems).get()).length;
    counts['tripBags'] = (await _db.select(_db.tripBags).get()).length;
    counts['scheduleEvents'] = (await _db.select(_db.scheduleEvents).get()).length;
    counts['tickets'] = (await _db.select(_db.tickets).get()).length;
    counts['ticketAttachments'] = (await _db.select(_db.ticketAttachments).get()).length;
    counts['reminders'] = (await _db.select(_db.reminders).get()).length;
    counts['returnCheckpoints'] = (await _db.select(_db.returnCheckpoints).get()).length;
    counts['returnEntries'] = (await _db.select(_db.returnEntries).get()).length;
    counts['packingTemplates'] = (await _db.select(_db.packingTemplates).get()).length;
    counts['templateItems'] = (await _db.select(_db.templateItems).get()).length;
    counts['assets'] = (await _db.select(_db.assets).get()).length;
    counts['departureManifests'] = (await _db.select(_db.departureManifests).get()).length;
    counts['departureManifestItems'] = (await _db.select(_db.departureManifestItems).get()).length;
    return counts;
  }

  /// Membuat arsip backup lengkap (.zip) di dalam staging directory (BAK-01, TECH-01)
  Future<File> createBackupArchive({String? customFileName}) async {
    final base = await getBaseDirectory();
    final timestamp = DateTime.now().toUtc();
    final timeStr = DateFormat('yyyyMMdd_HHmmss').format(timestamp);
    final fileName = customFileName ?? 'siapkan_tas_backup_$timeStr.zip';

    final stagingDir = Directory(p.join(base.path, 'staging', 'backup_export_$timeStr'));
    if (await stagingDir.exists()) {
      await stagingDir.delete(recursive: true);
    }
    await stagingDir.create(recursive: true);

    try {
      // 1. Snapshot database konsisten (TECH-01)
      final snapshotDbFile = File(p.join(stagingDir.path, 'database.sqlite'));
      await _createConsistentDatabaseSnapshot(snapshotDbFile);
      final dbChecksum = await _computeSha256(snapshotDbFile);

      // 2. Kumpulkan aset yang dirujuk database aktif (QA-40)
      final activeAssets = await _db.select(_db.assets).get();
      final List<BackupAssetInfo> manifestAssets = [];
      final stagingAssetsDir = Directory(p.join(stagingDir.path, 'assets'));
      if (!await stagingAssetsDir.exists()) {
        await stagingAssetsDir.create(recursive: true);
      }

      for (final asset in activeAssets) {
        final localFile = await _assetStorageService.resolveRelativeFile(asset.relativePath);
        if (await localFile.exists()) {
          final bytes = await localFile.readAsBytes();
          final fileSha256 = sha256.convert(bytes).toString();

          // Simpan ke staging/assets/
          final assetFileName = p.basename(asset.relativePath);
          final destFile = File(p.join(stagingAssetsDir.path, assetFileName));
          await destFile.writeAsBytes(bytes, flush: true);

          manifestAssets.add(
            BackupAssetInfo(
              id: asset.id,
              relativePath: 'assets/$assetFileName',
              sha256: fileSha256,
              sizeBytes: bytes.length,
              originalName: asset.originalName,
              kind: asset.kind,
              missing: false,
            ),
          );
        } else {
          // File fisik hilang dari storage lokal (QA-45)
          manifestAssets.add(
            BackupAssetInfo(
              id: asset.id,
              relativePath: asset.relativePath,
              sha256: asset.sha256,
              sizeBytes: asset.sizeBytes,
              originalName: asset.originalName,
              kind: asset.kind,
              missing: true,
            ),
          );
        }
      }

      // 3. Buat manifest.json (BAK-01, BAK-04)
      final counts = await _gatherEntityCounts();
      final manifest = BackupManifest(
        format: BackupManifest.currentFormat,
        formatVersion: BackupManifest.currentFormatVersion,
        appVersion: '1.0.0+1',
        schemaVersion: _db.schemaVersion,
        createdAt: timestamp.toIso8601String(),
        databaseChecksum: dbChecksum,
        entityCounts: counts,
        assets: manifestAssets,
      );

      final manifestFile = File(p.join(stagingDir.path, 'manifest.json'));
      const encoder = JsonEncoder.withIndent('  ');
      await manifestFile.writeAsString(encoder.convert(manifest.toJson()), flush: true);

      // 4. Kompresi seluruh file ke ZIP
      final archive = Archive();

      // Tambahkan manifest.json
      final manifestBytes = await manifestFile.readAsBytes();
      archive.addFile(ArchiveFile('manifest.json', manifestBytes.length, manifestBytes));

      // Tambahkan database.sqlite
      final dbBytes = await snapshotDbFile.readAsBytes();
      archive.addFile(ArchiveFile('database.sqlite', dbBytes.length, dbBytes));

      // Tambahkan file aset
      if (await stagingAssetsDir.exists()) {
        final assetFiles = stagingAssetsDir.listSync(recursive: true);
        for (final entity in assetFiles) {
          if (entity is File) {
            final fileBytes = await entity.readAsBytes();
            final relName = p.relative(entity.path, from: stagingDir.path).replaceAll('\\', '/');
            archive.addFile(ArchiveFile(relName, fileBytes.length, fileBytes));
          }
        }
      }

      final zipEncoder = ZipEncoder();
      final zipData = zipEncoder.encode(archive);

      final outputZipFile = File(p.join(base.path, 'staging', fileName));
      await outputZipFile.writeAsBytes(zipData, flush: true);

      return outputZipFile;
    } finally {
      // Hapus direktori staging ekstraksi
      if (await stagingDir.exists()) {
        await stagingDir.delete(recursive: true);
      }
    }
  }

  /// Ekspor backup dengan dialog penyimpanan file SAF / sistem (BAK-02, QA-41)
  Future<String?> exportBackupWithFilePicker({
    Future<String?> Function(String suggestedFileName, Uint8List bytes)? customFileSaver,
  }) async {
    final timeStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final suggestedName = 'siapkan_tas_backup_$timeStr.zip';

    // Buat file arsip di staging terlebih dahulu
    final tempZipFile = await createBackupArchive(customFileName: suggestedName);

    try {
      final bytes = Uint8List.fromList(await tempZipFile.readAsBytes());
      final String? savedLocation;

      if (customFileSaver != null) {
        savedLocation = await customFileSaver(suggestedName, bytes);
      } else {
        final uri = await FilePicker.saveFile(
          dialogTitle: 'Simpan Cadangan Siapkan Tas',
          fileName: suggestedName,
          bytes: bytes,
          type: FileType.custom,
          allowedExtensions: ['zip'],
        );
        savedLocation = uri?.toString();
      }

      // QA-41: Jika dibatalkan pengguna, jangan tandai sukses
      if (savedLocation == null || savedLocation.isEmpty) {
        return null;
      }

      // Catat waktu sukses ke AppSettings
      await recordBackupSuccess(DateTime.now());

      return savedLocation;
    } finally {
      if (await tempZipFile.exists()) {
        await tempZipFile.delete();
      }
    }
  }

  /// Memeriksa dan memvalidasi file arsip sebelum restore diterapkan (BAK-04, QA-42)
  Future<BackupPreviewInfo> inspectArchive(File zipFile) async {
    if (!await zipFile.exists()) {
      throw const BackupException('File arsip tidak ditemukan');
    }

    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final base = await getBaseDirectory();
    final timeStr = DateTime.now().microsecondsSinceEpoch.toString();
    final stagingDir = Directory(p.join(base.path, 'staging', 'inspect_$timeStr'));
    if (await stagingDir.exists()) {
      await stagingDir.delete(recursive: true);
    }
    await stagingDir.create(recursive: true);

    int totalExtractedBytes = 0;
    final List<String> warnings = [];

    try {
      // 1. Ekstraksi dengan proteksi Path Traversal & Zip Bomb (QA-42)
      for (final file in archive) {
        final filename = file.name;

        // Path Traversal check: tolak jika berisi '..', diawali '/', '\\', atau drive letter
        if (filename.contains('..') ||
            filename.startsWith('/') ||
            filename.startsWith('\\') ||
            RegExp(r'^[a-zA-Z]:').hasMatch(filename)) {
          throw PathTraversalException(
            'Arsip ditolak karena mengandung path berbahaya: "$filename"',
          );
        }

        if (file.isFile) {
          final fileSize = file.size;
          if (fileSize > maxSingleFileBytes) {
            throw ZipBombException(
              'Ukuran file "$filename" ($fileSize bytes) melebihi batas keamanan 50 MB.',
            );
          }

          totalExtractedBytes += fileSize;
          if (totalExtractedBytes > maxTotalExtractionBytes) {
            throw ZipBombException(
              'Total ukuran ekstraksi arsip melebihi batas keamanan 500 MB.',
            );
          }

          final targetFile = File(p.join(stagingDir.path, filename));
          final parentDir = targetFile.parent;
          if (!await parentDir.exists()) {
            await parentDir.create(recursive: true);
          }

          final content = file.content as List<int>;
          await targetFile.writeAsBytes(content, flush: true);
        }
      }

      // 2. Validasi manifest.json (BAK-04)
      final manifestFile = File(p.join(stagingDir.path, 'manifest.json'));
      if (!await manifestFile.exists()) {
        throw const MissingManifestException(
          'Arsip tidak valid: file manifest.json tidak ditemukan.',
        );
      }

      final manifestContent = await manifestFile.readAsString();
      final Map<String, dynamic> manifestMap;
      try {
        manifestMap = jsonDecode(manifestContent) as Map<String, dynamic>;
      } catch (e) {
        throw const CorruptedArchiveException('Format manifest.json rusak atau bukan JSON valid.');
      }

      final manifest = BackupManifest.fromJson(manifestMap);

      // Cek kompatibilitas versi skema (QA-38)
      if (manifest.schemaVersion > _db.schemaVersion) {
        throw IncompatibleVersionException(
          'Versi skema cadangan (v${manifest.schemaVersion}) lebih baru daripada versi aplikasi ini (v${_db.schemaVersion}). Silakan perbarui aplikasi Siapkan Tas.',
        );
      }

      // 3. Validasi database.sqlite dan checksum (BAK-04)
      final databaseFile = File(p.join(stagingDir.path, 'database.sqlite'));
      if (!await databaseFile.exists()) {
        throw const CorruptedArchiveException(
          'Arsip rusak: file database.sqlite tidak ditemukan.',
        );
      }

      final computedDbChecksum = await _computeSha256(databaseFile);
      if (computedDbChecksum != manifest.databaseChecksum) {
        throw const CorruptedArchiveException(
          'Integritas arsip gagal: Checksum database tidak cocok.',
        );
      }

      // Validasi integritas SQLite dengan quick_check
      final testDb = AppDatabase(NativeDatabase(databaseFile));
      try {
        final result = await testDb.customSelect('PRAGMA quick_check;').get();
        final checkStr = result.isNotEmpty ? result.first.data['quick_check'] : null;
        if (checkStr != 'ok') {
          throw CorruptedArchiveException('Integritas SQLite gagal: $checkStr');
        }
      } finally {
        await testDb.close();
      }

      // 4. Validasi file aset
      for (final asset in manifest.assets) {
        if (asset.missing) {
          warnings.add('Aset "${asset.originalName}" tidak disertakan dalam cadangan.');
          continue;
        }

        final assetFile = File(p.join(stagingDir.path, asset.relativePath));
        if (!await assetFile.exists()) {
          warnings.add('File aset "${asset.relativePath}" tidak ditemukan di dalam arsip.');
        } else {
          final assetChecksum = await _computeSha256(assetFile);
          if (assetChecksum != asset.sha256) {
            warnings.add('Checksum aset "${asset.relativePath}" tidak cocok, file mungkin rusak.');
          }
        }
      }

      return BackupPreviewInfo(
        manifest: manifest,
        stagingDirectory: stagingDir,
        databaseFile: databaseFile,
        warnings: warnings,
        totalArchiveBytes: bytes.length,
      );
    } catch (e) {
      if (await stagingDir.exists()) {
        await stagingDir.delete(recursive: true);
      }
      rethrow;
    }
  }

  /// Mengeksekusi restore data secara Replace-All dengan proteksi Rollback (BAK-05, TECH-01, QA-43)
  Future<void> restoreFromBackup(
    BackupPreviewInfo preview, {
    required Future<void> Function() onBeforeReplace,
    required Future<void> Function() onAfterReplace,
  }) async {
    final base = await getBaseDirectory();
    final rollbackDir = Directory(p.join(base.path, 'backup_rollback'));
    final journalFile = File(p.join(base.path, 'restore_journal.json'));

    // Pastikan rollback dir bersih
    if (await rollbackDir.exists()) {
      await rollbackDir.delete(recursive: true);
    }
    await rollbackDir.create(recursive: true);

    final liveDbFile = await getLiveDatabaseFile();
    final liveAssetsDir = await _assetStorageService.getAssetsDirectory();

    try {
      // Step A: Tulis status journal "backing_up_live" (QA-43)
      await journalFile.writeAsString(
        jsonEncode({
          'stage': 'backing_up_live',
          'timestamp': DateTime.now().toIso8601String(),
        }),
        flush: true,
      );

      // Step B: Cadangkan data aktif ke rollbackDir
      if (await liveDbFile.exists()) {
        await liveDbFile.copy(p.join(rollbackDir.path, 'bawa.sqlite'));
      }
      if (await liveAssetsDir.exists()) {
        final rollbackAssetsDir = Directory(p.join(rollbackDir.path, 'assets'));
        await rollbackAssetsDir.create(recursive: true);
        final list = liveAssetsDir.listSync(recursive: true);
        for (final item in list) {
          if (item is File) {
            final rel = p.relative(item.path, from: liveAssetsDir.path);
            final dest = File(p.join(rollbackAssetsDir.path, rel));
            await dest.parent.create(recursive: true);
            await item.copy(dest.path);
          }
        }
      }

      // Step C: Update status journal "applying_restore"
      await journalFile.writeAsString(
        jsonEncode({
          'stage': 'applying_restore',
          'timestamp': DateTime.now().toIso8601String(),
        }),
        flush: true,
      );

      // Step D: Tutup koneksi aktif sebelum file diganti
      await onBeforeReplace();

      // Step E: Ganti database aktif
      if (await liveDbFile.exists()) {
        await liveDbFile.delete();
      }
      // Hapus sisa file WAL/SHM jika ada
      final walFile = File('${liveDbFile.path}-wal');
      final shmFile = File('${liveDbFile.path}-shm');
      if (await walFile.exists()) await walFile.delete();
      if (await shmFile.exists()) await shmFile.delete();

      await preview.databaseFile.copy(liveDbFile.path);

      // Step F: Ganti direktori aset
      if (await liveAssetsDir.exists()) {
        await liveAssetsDir.delete(recursive: true);
      }
      await liveAssetsDir.create(recursive: true);

      final stagingAssetsDir = Directory(p.join(preview.stagingDirectory.path, 'assets'));
      if (await stagingAssetsDir.exists()) {
        final stagingList = stagingAssetsDir.listSync(recursive: true);
        for (final item in stagingList) {
          if (item is File) {
            final rel = p.relative(item.path, from: stagingAssetsDir.path);
            final dest = File(p.join(liveAssetsDir.path, rel));
            await dest.parent.create(recursive: true);
            await item.copy(dest.path);
          }
        }
      }

      // Step G: Buka kembali database dan jalankan migrasi jika skema cadangan lebih lama (QA-38)
      await onAfterReplace();

      // Step H: Jadwalkan ulang reminder yang masih akan datang (BAK-06, QA-47)
      try {
        await remindersRepository?.reconcileAllReminders();
      } catch (_) {
        // Kegagalan alarm dilaporkan, jangan batalkan hasil restore yang valid
      }

      // Step I: Selesai! Bersihkan rollback dan journal
      if (await rollbackDir.exists()) {
        await rollbackDir.delete(recursive: true);
      }
      if (await journalFile.exists()) {
        await journalFile.delete();
      }
    } catch (e) {
      // ROLLBACK DARURAT: Jika restore terganggu/gagal, pulihkan data lama (QA-43)
      try {
        final backupDb = File(p.join(rollbackDir.path, 'bawa.sqlite'));
        if (await backupDb.exists()) {
          await backupDb.copy(liveDbFile.path);
        }
        final rollbackAssetsDir = Directory(p.join(rollbackDir.path, 'assets'));
        if (await rollbackAssetsDir.exists()) {
          if (await liveAssetsDir.exists()) {
            await liveAssetsDir.delete(recursive: true);
          }
          await liveAssetsDir.create(recursive: true);
          final list = rollbackAssetsDir.listSync(recursive: true);
          for (final item in list) {
            if (item is File) {
              final rel = p.relative(item.path, from: rollbackAssetsDir.path);
              final dest = File(p.join(liveAssetsDir.path, rel));
              await dest.parent.create(recursive: true);
              await item.copy(dest.path);
            }
          }
        }
        await onAfterReplace();
      } catch (_) {
        // Abaikan error secondary rollback
      }
      rethrow;
    } finally {
      // Bersihkan staging inspection
      if (await preview.stagingDirectory.exists()) {
        await preview.stagingDirectory.delete(recursive: true);
      }
    }
  }

  /// Memulihkan status jika aplikasi crash saat proses restore sebelumnya (QA-43)
  Future<bool> checkAndRecoverInterruptedRestore({
    required Future<void> Function() onAfterRecover,
  }) async {
    final base = await getBaseDirectory();
    final journalFile = File(p.join(base.path, 'restore_journal.json'));
    final rollbackDir = Directory(p.join(base.path, 'backup_rollback'));

    if (!await journalFile.exists()) return false;

    // Ada proses restore yang terputus di tengah jalan!
    if (await rollbackDir.exists()) {
      final liveDbFile = await getLiveDatabaseFile();
      final liveAssetsDir = await _assetStorageService.getAssetsDirectory();

      final backupDb = File(p.join(rollbackDir.path, 'bawa.sqlite'));
      if (await backupDb.exists()) {
        await backupDb.copy(liveDbFile.path);
      }

      final rollbackAssets = Directory(p.join(rollbackDir.path, 'assets'));
      if (await rollbackAssets.exists()) {
        if (await liveAssetsDir.exists()) {
          await liveAssetsDir.delete(recursive: true);
        }
        await liveAssetsDir.create(recursive: true);
        final list = rollbackAssets.listSync(recursive: true);
        for (final item in list) {
          if (item is File) {
            final rel = p.relative(item.path, from: rollbackAssets.path);
            final dest = File(p.join(liveAssetsDir.path, rel));
            await dest.parent.create(recursive: true);
            await item.copy(dest.path);
          }
        }
      }

      await rollbackDir.delete(recursive: true);
    }

    await journalFile.delete();
    await onAfterRecover();
    return true;
  }
}
