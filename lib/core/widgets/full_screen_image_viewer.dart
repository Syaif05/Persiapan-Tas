import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class FullScreenImageViewer extends StatelessWidget {
  final File file;
  final String? title;
  final String? heroTag;

  const FullScreenImageViewer({
    super.key,
    required this.file,
    this.title,
    this.heroTag,
  });

  /// Helper untuk membuka viewer dalam modal full screen
  static void show(
    BuildContext context, {
    required File file,
    String? title,
    String? heroTag,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.9),
        barrierDismissible: true,
        pageBuilder: (context, anim1, anim2) => FadeTransition(
          opacity: anim1,
          child: FullScreenImageViewer(
            file: file,
            title: title,
            heroTag: heroTag,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.file(
      file,
      fit: BoxFit.contain,
    );

    if (heroTag != null) {
      imageWidget = Hero(tag: heroTag!, child: imageWidget);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          tooltip: 'Tutup',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: title != null
            ? Text(
                title!,
                style: AppTypography.itemTitle.copyWith(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              )
            : null,
      ),
      body: SafeArea(
        child: Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.8,
            maxScale: 5.0,
            child: imageWidget,
          ),
        ),
      ),
    );
  }
}
