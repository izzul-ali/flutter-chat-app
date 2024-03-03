import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/chat/data/chat_provider.dart';
import 'package:flutter_chat_app/features/chat/domain/message.dart';
import 'package:flutter_chat_app/features/chat/presentation/widget/chat_header.dart';
import 'package:flutter_chat_app/features/user/domain/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widget/send_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.senderId,
    required this.receiver,
    required this.chatRoomId,
  });

  final UserModel receiver;
  final String senderId;
  final String? chatRoomId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatHeader(
        profilePic: receiver.profilPic,
        username: receiver.username,
      ),
      body: Expanded(
        child: Container(
          padding: const EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: 70,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
          child: MessageList(
            chatRoomId: chatRoomId,
            senderId: senderId,
            receiverId: receiver.uid,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SendMessage(
        chatRoomId: chatRoomId,
        receiverId: receiver.uid,
      ),
    );
  }
}

class MessageList extends ConsumerStatefulWidget {
  const MessageList({
    super.key,
    required this.senderId,
    required this.receiverId,
    this.chatRoomId,
  });

  final String senderId;
  final String? chatRoomId;
  final String receiverId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MessageListState();
}

class MessageListState extends ConsumerState<MessageList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messageList = ref.watch(messagesListProvider(
      widget.chatRoomId,
      widget.senderId,
      widget.receiverId,
    ));

    // always to the bottom of chat
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });

    return switch (messageList) {
      AsyncData(:final value) => ListView.builder(
          controller: _scrollController,
          itemCount: value.length,
          itemBuilder: (context, index) {
            final Message message = value[index];
            final bool isReceiver = message.receiverId == widget.receiverId;

            return Column(
              children: [
                Align(
                  alignment:
                      isReceiver ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isReceiver
                              ? const Color(0xff3D4A7A)
                              : const Color(0xffF2F7FB),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(10),
                            bottomLeft: Radius.circular(isReceiver ? 10 : 0),
                            topRight: const Radius.circular(10),
                            bottomRight: Radius.circular(isReceiver ? 0 : 10),
                          ),
                        ),
                        child: Text(
                          message.message,
                          style: TextStyle(
                            color: isReceiver
                                ? Colors.white
                                : const Color(0xff000E08),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${message.timestamp.hour}:${message.timestamp.minute}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff797C7B),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5),
              ],
            );
          },
        ),
      AsyncError(:final error) => Center(
          child: Text(error.toString()),
        ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
