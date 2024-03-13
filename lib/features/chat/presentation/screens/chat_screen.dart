import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/chat/presentation/widget/chat_header.dart';
import 'package:flutter_chat_app/features/user/domain/user.dart';

import '../widget/message/message_list.dart';
import '../widget/message/send_message.dart';

// TODO: add send attachment

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
      backgroundColor: Colors.white,
      appBar: ChatHeader(
        profilePic: receiver.profilPic,
        username: receiver.username,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: 70,
              ),
              child: MessageList(
                chatRoomId: chatRoomId,
                senderId: senderId,
                receiverId: receiver.uid,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SendMessage(
        chatRoomId: chatRoomId,
        receiverId: receiver.uid,
      ),
    );
  }
}
