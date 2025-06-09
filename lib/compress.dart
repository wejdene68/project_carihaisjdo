import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

Future<void> main() async {
  final inputDir = Directory('./assets/image');
  final outputDir = Directory('./assets/img');

  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  for (final file in inputDir.listSync()) {
    if (file is File &&
        (file.path.endsWith('.png') ||
            file.path.endsWith('.jpg') ||
            file.path.endsWith('.jpeg'))) {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        '${outputDir.path}/${file.path.split('/').last}',
        quality: 80,
        format: CompressFormat.webp, // Convert to WebP format
      );

      debugPrint('Compressed: ${file.path} → ${result?.path}');
    }
  }
}
