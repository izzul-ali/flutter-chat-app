import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/core/helper/generate_chatroom_id.dart';
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

  Future<void> sendFile({
    required String senderId,
    required String receiverId,
    required String type,
    required File file,
    String? chatRoomId,
  }) async {
    try {
      chatRoomId ??= await createChatroom(
        senderId: senderId,
        receiverId: receiverId,
      );

      Reference ref = FirebaseStorage.instance.ref();

      Message message = Message(
        type: type,
        senderId: senderId,
        receiverId: receiverId,
        message: '',
        timestamp: DateTime.now(),
      );

      if (type == 'image') {
        final imageRef = ref.child('/images/${file.uri.pathSegments.last}');

        await imageRef.putFile(file);

        final downloadUrl = await imageRef.getDownloadURL();

        message = message.copyWith(
          type: type,
          message: downloadUrl,
          timestamp: DateTime.now(),
        );
      }

      if (type == 'video') {
        final imageRef = ref.child('/videos/${file.uri.pathSegments.last}');

        await imageRef.putFile(file);

        final downloadUrl = await imageRef.getDownloadURL();

        message = message.copyWith(
          type: type,
          message: downloadUrl,
          timestamp: DateTime.now(),
        );
      }

      if (type == 'file') {
        final imageRef = ref.child('/files/${file.uri.pathSegments.last}');

        await imageRef.putFile(file);

        final downloadUrl = await imageRef.getDownloadURL();

        message = message.copyWith(
          type: type,
          message: downloadUrl,
          timestamp: DateTime.now(),
        );
      }

      final chatroomRef = _firestore.collection(_chatRoom).doc(chatRoomId);

      await chatroomRef.collection('chats').add(message.toMap());

      await chatroomRef.update({
        "lastMessage": message.message,
        "viewed": false,
        "type": message.type,
        "timestamp": message.timestamp,
      });
    } catch (e) {
      rethrow;
    }
  }
}
