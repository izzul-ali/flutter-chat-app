import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UploadController {
  static Future<File?> handlePickImageOrVideo(String type) async {
    final ImagePicker picker = ImagePicker();
    try {
      if (type == 'image') {
        final media = await picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.rear,
        );

        if (media != null) {
          return File(media.path);
        }

        return null;
      }

      if (type == 'video') {
        final media = await picker.pickVideo(
          source: ImageSource.camera,
        );

        if (media != null) {
          return File(media.path);
        }

        return null;
      }

      // image type doesnt exists
      return null;
    } catch (e) {
      print('error pick media ${e.toString()}');
      return null;
    }
  }
}
