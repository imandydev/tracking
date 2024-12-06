import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_apps/configurations/color_configuration.dart';

class ImageService {
  ImageService();

  saveImage(File image) async {
    try {
      final bytes = await image.readAsBytes();

      await PhotoManager.editor.saveImage(
        bytes,
        title: '${DateTime.now().millisecondsSinceEpoch}',
        filename: '${DateTime.now().millisecondsSinceEpoch}.png',
      );
    } catch (_) {}
  }

  Future<File> addTextToImage(
      String imagePath, String text, Offset position) async {
    final picture = File(imagePath);
    final ui.Image originalImage =
        await decodeImageFromList(await picture.readAsBytes());

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    canvas.drawImage(originalImage, Offset.zero, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style:
            const TextStyle(color: ColorConfiguration.colorWhite, fontSize: 15),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, position);

    final pictureImage = recorder.endRecording();
    final ui.Image finalImage =
        await pictureImage.toImage(originalImage.width, originalImage.height);

    final byteData =
        await finalImage.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    final outputFile = File(imagePath);
    return outputFile.writeAsBytes(buffer);
  }
}
