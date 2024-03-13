import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/core/helper/generate_chatroom_id.dart';
import 'package:flutter_chat_app/features/auth/data/auth_provider.dart';
import 'package:flutter_chat_app/features/chat/data/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/chat_room.dart';
import '../domain/message.dart';

part 'chat_provider.g.dart';

@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository(firestore: FirebaseFirestore.instance);
}

@riverpod
Stream<List<ChatRoom>> chatRooms(ChatRoomsRef ref) {
  final currentUser = ref.watch(authRepositoryProvider).currentUser;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final StreamController<List<ChatRoom>> streamController =
      StreamController<List<ChatRoom>>();

  print('user ${currentUser?.uid}');

  final chtroomQuery = firestore
      .collection('chatrooms')
      .where('members', arrayContains: currentUser!.uid)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .listen((event) {
    final List<ChatRoom> chatRooms = [];

    for (var item in event.docs) {
      chatRooms.add(ChatRoom.fromMap(item.data()));
    }

    streamController.sink.add(chatRooms);
  });

  ref.onDispose(() {
    chtroomQuery.cancel();
    streamController.close();
  });

  return streamController.stream;
}

@riverpod
Stream<List<Message>> messagesList(
  MessagesListRef ref,
  String? chatroomId,
  String senderId,
  String receiverId,
) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final StreamController<List<Message>> messageController =
      StreamController<List<Message>>();

  final (chatroomIdFromGenerate, _) =
      generateChatroomId(senderId: senderId, receiverId: receiverId);

  chatroomId ??= chatroomIdFromGenerate;

  final queryMessage = firestore
      .collection('chatrooms')
      .doc(chatroomId)
      .collection('chats')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .listen((event) {
    final List<Message> messages = [];

    for (var item in event.docs) {
      messages.add(Message.fromMap(item.data()));
    }

    messageController.sink.add(messages);
  });

  // cancel request when close the chat
  ref.onDispose(() {
    queryMessage.cancel();
    messageController.close();
  });

  return messageController.stream;
}
