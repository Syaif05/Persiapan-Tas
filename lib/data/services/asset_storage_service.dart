import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

class AssetStorageService {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();
  final Directory? baseDirOverride;

  AssetStorageService(this._db, {this.baseDirOverride});

  Future<Directory> getBaseDirectory() async {
    final override = baseDirOverride;
    if (override != null) {
      return override;
    }
    return await getApplicationDocumentsDirectory();
  }

  Future<Directory> getAssetsDirectory() async {
    final base = await getBaseDirectory();
    final assetsDir = Directory(p.join(base.path, 'assets'));
    if (!await assetsDir.exists()) {
      await assetsDir.create(recursive: true);
    }
    return assetsDir;
  }

  Future<File> resolveRelativeFile(String relativePath) async {
    final base = await getBaseDirectory();
    return File(p.join(base.path, relativePath));
  }

  Future<bool> doesAssetExist(String relativePath) async {
    final file = await resolveRelativeFile(relativePath);
    return await file.exists();
  }

  /// Menyalin file gambar terpilih ke app-private sandbox secara permanen
  /// Menghitung SHA-256 dan mencatat entri ke tabel Assets
  Future<AssetEntry> savePickedImage(
    XFile pickedFile, {
    required String kind, // 'item_photo' | 'location_photo' | 'ticket_attachment'
    String? originalName,
  }) async {
    final assetsDir = await getAssetsDirectory();
    final bytes = await pickedFile.readAsBytes();

    // Validasi batas ukuran 20 MB sesuai ADR-05 / FILE-01
    const maxBytes = 20 * 1024 * 1024;
    if (bytes.length > maxBytes) {
      final sizeMb = (bytes.length / (1024 * 1024)).toStringAsFixed(1);
      throw Exception('Ukuran file ($sizeMb MB) melebihi batas maksimal 20 MB');
    }

    // Hitung SHA-256 checksum untuk integritas
    final digest = sha256.convert(bytes);
    final sha256Hex = digest.toString();

    // Tentukan ekstensi
    final ext = p.extension(pickedFile.path).isNotEmpty
        ? p.extension(pickedFile.path)
        : '.jpg';

    final assetId = _uuid.v4();
    final fileName = '$assetId$ext';
    final targetFile = File(p.join(assetsDir.path, fileName));

    // Tulis ke app-private storage
    await targetFile.writeAsBytes(bytes, flush: true);

    final relativePath = p.join('assets', fileName).replaceAll('\\', '/');
    final now = DateTime.now().toIso8601String();

    // Simpan ke database
    final assetEntry = AssetEntry(
      id: assetId,
      relativePath: relativePath,
      mimeType: pickedFile.mimeType ?? 'image/jpeg',
      sizeBytes: bytes.length,
      sha256: sha256Hex,
      originalName: originalName ?? p.basename(pickedFile.path),
      kind: kind,
      createdAt: now,
    );

    await _db.into(_db.assets).insert(
          AssetsCompanion.insert(
            id: assetEntry.id,
            relativePath: assetEntry.relativePath,
            mimeType: assetEntry.mimeType,
            sizeBytes: assetEntry.sizeBytes,
            sha256: assetEntry.sha256,
            originalName: assetEntry.originalName,
            kind: assetEntry.kind,
            createdAt: assetEntry.createdAt,
          ),
        );

    return assetEntry;
  }

  /// Menyalin file dari File (misal PDF atau dokumen terpilih via FilePicker) ke app-private sandbox
  Future<AssetEntry> saveFile(
    File sourceFile, {
    required String kind, // 'item_photo' | 'location_photo' | 'ticket_attachment'
    String? mimeType,
    String? originalName,
  }) async {
    final assetsDir = await getAssetsDirectory();
    final bytes = await sourceFile.readAsBytes();

    // Validasi batas ukuran 20 MB sesuai ADR-05 / FILE-01
    const maxBytes = 20 * 1024 * 1024;
    if (bytes.length > maxBytes) {
      final sizeMb = (bytes.length / (1024 * 1024)).toStringAsFixed(1);
      throw Exception('Ukuran file ($sizeMb MB) melebihi batas maksimal 20 MB');
    }

    // Hitung SHA-256 checksum untuk integritas
    final digest = sha256.convert(bytes);
    final sha256Hex = digest.toString();

    // Tentukan ekstensi
    final ext = p.extension(sourceFile.path).isNotEmpty
        ? p.extension(sourceFile.path)
        : '.dat';

    final assetId = _uuid.v4();
    final fileName = '$assetId$ext';
    final targetFile = File(p.join(assetsDir.path, fileName));

    // Tulis ke app-private storage
    await targetFile.writeAsBytes(bytes, flush: true);

    final relativePath = p.join('assets', fileName).replaceAll('\\', '/');
    final now = DateTime.now().toIso8601String();

    String detectedMime = mimeType ?? 'application/octet-stream';
    final lowerExt = ext.toLowerCase();
    if (lowerExt == '.pdf') {
      detectedMime = 'application/pdf';
    } else if (lowerExt == '.png') {
      detectedMime = 'image/png';
    } else if (lowerExt == '.jpg' || lowerExt == '.jpeg') {
      detectedMime = 'image/jpeg';
    }

    final assetEntry = AssetEntry(
      id: assetId,
      relativePath: relativePath,
      mimeType: detectedMime,
      sizeBytes: bytes.length,
      sha256: sha256Hex,
      originalName: originalName ?? p.basename(sourceFile.path),
      kind: kind,
      createdAt: now,
    );

    await _db.into(_db.assets).insert(
          AssetsCompanion.insert(
            id: assetEntry.id,
            relativePath: assetEntry.relativePath,
            mimeType: assetEntry.mimeType,
            sizeBytes: assetEntry.sizeBytes,
            sha256: assetEntry.sha256,
            originalName: assetEntry.originalName,
            kind: assetEntry.kind,
            createdAt: assetEntry.createdAt,
          ),
        );

    return assetEntry;
  }

  /// Menghapus asset dari database dan filesystem jika aman (FILE-01)
  /// Memeriksa relasi aktif terlebih dahulu agar tidak menghapus foto/lampiran yang masih dirujuk
  Future<void> deleteAsset(String assetId) async {
    final itemPhotoRef = await (_db.select(_db.itemPhotos)..where((p) => p.assetId.equals(assetId))).get();
    final locPhotoRef = await (_db.select(_db.storageLocations)..where((l) => l.photoAssetId.equals(assetId))).get();
    final ticketAttRef = await (_db.select(_db.ticketAttachments)..where((a) => a.assetId.equals(assetId))).get();

    if (itemPhotoRef.isNotEmpty || locPhotoRef.isNotEmpty || ticketAttRef.isNotEmpty) {
      // Masih dirujuk oleh entri lain, jangan hapus
      return;
    }

    final asset = await (_db.select(_db.assets)..where((a) => a.id.equals(assetId))).getSingleOrNull();
    if (asset != null) {
      final file = await resolveRelativeFile(asset.relativePath);
      if (await file.exists()) {
        await file.delete();
      }
      await (_db.delete(_db.assets)..where((a) => a.id.equals(assetId))).go();
    }
  }
}
