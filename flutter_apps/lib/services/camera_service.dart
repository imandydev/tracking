
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import 'image_service.dart';

class CameraService {
  CameraController cameraController;
  ImageService imageService = ImageService();

  CameraService({required this.cameraController});

  startCamera() {
    return cameraController.initialize();
  }

  Future<File?> takePicture(String text, Offset position) async {
    File? imageText;

    if (!cameraController.value.isTakingPicture &&
        cameraController.value.isInitialized) {
      XFile image = await cameraController.takePicture();

      imageText = await imageService.addTextToImage(image.path, text, position);

      await imageService.saveImage(imageText);
    }

    return imageText;
  }


  dispose() {
    cameraController.dispose();
  }

  getController() {
    return cameraController;
  }

}
