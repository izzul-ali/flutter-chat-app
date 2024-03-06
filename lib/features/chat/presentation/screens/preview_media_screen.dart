import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/chat/data/chat_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../auth/data/auth_provider.dart';

class PreviewMediaScreen extends ConsumerStatefulWidget {
  const PreviewMediaScreen({
    super.key,
    required this.type,
    required this.file,
    required this.receiverId,
    required this.chatRoomId,
  });

  final String type;
  final File file;
  final String receiverId;
  final String chatRoomId;

  @override
  ConsumerState<PreviewMediaScreen> createState() => _PreviewMediaScreenState();
}

class _PreviewMediaScreenState extends ConsumerState<PreviewMediaScreen> {
  late VideoPlayerController _playerController;

  @override
  void initState() {
    super.initState();

    _playerController = VideoPlayerController.file(
      widget.file,
    );
    // _playerController.play();

    // setState(() {});
  }

  @override
  void dispose() {
    _playerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: widget.type == 'image'
                  ? Image.file(
                      widget.file,
                      fit: BoxFit.contain,
                    )
                  : AspectRatio(
                      aspectRatio: _playerController.value.aspectRatio,
                      child: VideoPlayer(_playerController),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filled(
                onPressed: () async {
                  final senderId =
                      ref.watch(authRepositoryProvider).currentUser?.uid;

                  if (senderId != null) {
                    await ref.read(chatRepositoryProvider).sendFile(
                          senderId: senderId,
                          receiverId: widget.receiverId,
                          type: widget.type,
                          file: widget.file,
                        );

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                iconSize: 30,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
