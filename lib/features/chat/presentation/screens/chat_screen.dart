import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/chat/presentation/widget/chat_header.dart';
import 'package:flutter_chat_app/features/user/domain/user.dart';

import '../widget/message_list.dart';
import '../widget/send_message.dart';

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
            color: Colors.grey[200],
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
