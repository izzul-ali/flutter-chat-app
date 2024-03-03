import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/core/utils/generate_chatroom_id.dart';
import 'package:flutter_chat_app/features/chat/domain/chat_room.dart';
import 'package:flutter_chat_app/features/chat/domain/message.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final String _chatRoom = 'chatrooms';

  ChatRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

// create chatroom
  Future<String> createChatroom({
    required String senderId,
    required String receiverId,
  }) async {
    final (chatroomId, members) =
        generateChatroomId(senderId: senderId, receiverId: receiverId);

    final chatRoom = await _firestore
        .collection(_chatRoom)
        .where('members', isEqualTo: members)
        .get();

    if (chatRoom.docs.isEmpty) {
      final ChatRoom initialChatRoom = ChatRoom(
        chatRoomId: chatroomId,
        members: members,
        lastMessage: '',
        viewed: false,
        type: 'text',
        timestamp: DateTime.now(),
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(_chatRoom)
          .doc(chatroomId)
          .set(initialChatRoom.toMap());

      return chatroomId;
    }
    final exitingChatRoom = chatRoom.docs[0].data();

    return exitingChatRoom['chatRoomId'];
  }

  // send message and update chatroom
  Future<void> sendMessage({
    required String msg,
    required String senderId,
    required String receiverId,
    String? chatRoomId,
  }) async {
    try {
      chatRoomId ??= await createChatroom(
        senderId: senderId,
        receiverId: receiverId,
      );

      msg = msg.trim();

      final chatRoom = _firestore.collection(_chatRoom).doc(chatRoomId);

      final Message msgData = Message(
        type: 'text',
        senderId: senderId,
        receiverId: receiverId,
        message: msg,
        timestamp: DateTime.now(),
      );

      await chatRoom.collection('chats').add(msgData.toMap());

      // update chatroom
      await chatRoom.update({
        "lastMessage": msgData.message,
        "viewed": false,
        "type": msgData.type,
        "timestamp": msgData.timestamp,
      });
    } catch (e) {
      rethrow;
    }
  }
}
