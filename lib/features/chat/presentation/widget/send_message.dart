import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/auth/data/auth_provider.dart';
import 'package:flutter_chat_app/features/chat/data/chat_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      decoration: BoxDecoration(color: Colors.grey[300]),
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
                    icon: const Icon(Icons.attach_file),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      controller: _editingController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Message',
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.photo_camera_outlined),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.mic_none_rounded,
                      size: 27,
                    ),
                  ),
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
}
