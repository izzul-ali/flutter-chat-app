import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/helper/upload_media.dart';
import '../screens/preview_media_screen.dart';

part 'send_media_controller.g.dart';

@riverpod
class SendMediaController extends _$SendMediaController {
  @override
  void build() {}

  Future<void> sendMedia(
    BuildContext context, {
    ImageSource source = ImageSource.gallery,
    required String type,
    required String receiverId,
    required String chatRoomId,
  }) async {
    try {
      Navigator.pop(context);

      final File? file;

      if (type == 'file') {
        file = await UploadMedia.handlePickFile();
      } else {
        file = await UploadMedia.handlePickImageOrVideo(
          type: type,
          source: source,
        );
      }

      if (context.mounted && file != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PreviewMediaScreen(
              type: type,
              file: file!,
              receiverId: receiverId,
              chatRoomId: chatRoomId,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }
}
