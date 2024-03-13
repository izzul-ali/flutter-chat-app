import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class UploadMedia {
  static Future<File?> handlePickImageOrVideo({
    required String type,
    ImageSource source = ImageSource.gallery,
  }) async {
    final ImagePicker picker = ImagePicker();
    try {
      if (type == 'image') {
        final media = await picker.pickImage(
          source: source,
          preferredCameraDevice: CameraDevice.rear,
        );

        if (media != null) {
          return File(media.path);
        }

        return null;
      }

      if (type == 'video') {
        final media = await picker.pickVideo(
          source: source,
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

  static Future<File?> handlePickFile() async {
    try {
      final FilePickerResult? pickerResult =
          await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowCompression: true,
      );

      if (pickerResult != null && pickerResult.files.isNotEmpty) {
        final File file = File(pickerResult.files[0].path!);

        return file;
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }
}
