import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';

class AppHelper {
  static Future<File?> cropImage(File? imageFile) async {
    var _croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarColor: const Color(0xFF2564AF),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
        ]);

    return File(_croppedFile?.path ?? '');
  }

  static Future<File> compress({
    required File image,
    int quality = 85,
    // int targetH = 870,
    // int targetW = 450,
    int percentage = 70,
  }) async {
    var path = await FlutterNativeImage.compressImage(
      image.absolute.path,
      quality: quality,
      percentage: percentage,
      // targetHeight: targetW,
      // targetWidth: targetH,
    );
    return path;
  }
}
