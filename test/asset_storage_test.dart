import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/services/asset_storage_service.dart';

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late AssetStorageService storageService;

  setUp(() async {
    db = AppDatabase.inMemory();
    tempDir = await Directory.systemTemp.createTemp('bawa_asset_test_');
    storageService = AssetStorageService(db, baseDirOverride: tempDir);
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Fase 2: AssetStorageService & Media Sandbox Isolation Tests', () {
    test('Saves picked image into sandboxed app_data/assets with sha256 checksum', () async {
      // Create a dummy source file
      final sourceFile = File('${tempDir.path}/source_photo.jpg');
      await sourceFile.writeAsString('fake-image-bytes-content-12345');

      final xFile = XFile(sourceFile.path, mimeType: 'image/jpeg');

      // Save into asset sandbox
      final asset = await storageService.savePickedImage(
        xFile,
        kind: 'item_photo',
        originalName: 'source_photo.jpg',
      );

      expect(asset.id, isNotEmpty);
      expect(asset.kind, 'item_photo');
      expect(asset.originalName, 'source_photo.jpg');
      expect(asset.relativePath, startsWith('assets/'));
      expect(asset.sha256, isNotEmpty);

      // Verify physical file was written in sandbox
      final resolvedFile = await storageService.resolveRelativeFile(asset.relativePath);
      expect(await resolvedFile.exists(), isTrue);

      // Delete source photo outside sandbox
      await sourceFile.delete();
      expect(await sourceFile.exists(), isFalse);

      // Verify asset inside sandbox remains intact (AT-08: source deletion does not affect app copy)
      expect(await resolvedFile.exists(), isTrue);

      // Delete asset through storage service
      await storageService.deleteAsset(asset.id);
      expect(await resolvedFile.exists(), isFalse);
    });
  });
}
