import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constant/color.dart';
import 'package:flutter_chat_app/features/auth/data/auth_provider.dart';
import 'package:flutter_chat_app/features/chat/data/chat_provider.dart';
import 'package:flutter_chat_app/features/chat/presentation/controller/send_media_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class SendMessage extends ConsumerStatefulWidget {
  const SendMessage({
    super.key,
    required this.receiverId,
    required this.chatRoomId,
  });

  final String receiverId;
  final String? chatRoomId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SendMessageState();
}

class _SendMessageState extends ConsumerState<SendMessage> {
  late final TextEditingController _editingController;

  @override
  void initState() {
    _editingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 10,
        left: 5,
        right: 5,
        top: 5,
      ),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.mic_none_rounded,
                      size: 27,
                      color: kIconColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _editingController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        hintText: 'Message',
                        filled: true,
                        fillColor: Color(0xffF3F6F6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  _buildMediaFromCamera(),
                  _buildAttachment(),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          IconButton.filled(
            onPressed: () async {
              if (_editingController.text != '') {
                final senderId =
                    ref.watch(authRepositoryProvider).currentUser?.uid;

                if (senderId != null) {
                  try {
                    await ref.read(chatRepositoryProvider).sendMessage(
                          senderId: senderId,
                          receiverId: widget.receiverId,
                          msg: _editingController.text,
                          chatRoomId: widget.chatRoomId,
                        );

                    _editingController.clear();
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e.toString()),
                      ));
                    }
                  }
                }
              }
            },
            iconSize: 20,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  PopupMenuButton<dynamic> _buildMediaFromCamera() {
    return PopupMenuButton(
      offset: const Offset(0, -120),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Icon(
          Icons.camera_alt_outlined,
          size: 27,
          color: kIconColor,
        ),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _chooseItem(
                  onTap: () async {
                    await ref
                        .read(sendMediaControllerProvider.notifier)
                        .sendMedia(
                          context,
                          type: 'image',
                          source: ImageSource.camera,
                          receiverId: widget.receiverId,
                          chatRoomId: widget.chatRoomId ?? '',
                        );
                  },
                  label: 'Image',
                  icon: const Icon(Icons.image),
                ),
                _chooseItem(
                  onTap: () async {
                    await ref
                        .read(sendMediaControllerProvider.notifier)
                        .sendMedia(
                          context,
                          type: 'video',
                          source: ImageSource.camera,
                          receiverId: widget.receiverId,
                          chatRoomId: widget.chatRoomId ?? '',
                        );
                  },
                  label: 'Video',
                  icon: const Icon(Icons.videocam_rounded),
                ),
              ],
            ),
          )
        ];
      },
    );
  }

  PopupMenuButton<dynamic> _buildAttachment() {
    return PopupMenuButton(
      offset: const Offset(0, -120),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Icon(Icons.attach_file),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _chooseItem(
                onTap: () async {
                  await ref
                      .read(sendMediaControllerProvider.notifier)
                      .sendMedia(
                        context,
                        type: 'file',
                        receiverId: widget.receiverId,
                        chatRoomId: widget.chatRoomId ?? '',
                      );
                },
                label: 'Docs',
                icon: const Icon(Icons.edit_document),
              ),
              const SizedBox(width: 7),
              _chooseItem(
                onTap: () async {
                  await ref
                      .read(sendMediaControllerProvider.notifier)
                      .sendMedia(
                        context,
                        type: 'image',
                        receiverId: widget.receiverId,
                        chatRoomId: widget.chatRoomId ?? '',
                      );
                },
                label: 'Image',
                icon: const Icon(Icons.image),
              ),
              const SizedBox(width: 7),
              _chooseItem(
                onTap: () async {
                  await ref
                      .read(sendMediaControllerProvider.notifier)
                      .sendMedia(
                        context,
                        type: 'video',
                        receiverId: widget.receiverId,
                        chatRoomId: widget.chatRoomId ?? '',
                      );
                },
                label: 'Video',
                icon: const Icon(Icons.videocam_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chooseItem({
    required Function() onTap,
    required String label,
    required Icon icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton.filled(
          onPressed: onTap,
          icon: icon,
        ),
        Text(label)
      ],
    );
  }
}
