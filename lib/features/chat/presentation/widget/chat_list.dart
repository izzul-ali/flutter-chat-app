import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/auth/data/auth_provider.dart';
import 'package:flutter_chat_app/features/chat/data/chat_provider.dart';
import 'package:flutter_chat_app/features/user/data/user_provider.dart';
import 'package:flutter_chat_app/features/user/domain/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../domain/chat_room.dart';

class ChatList extends ConsumerWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String currentUserId =
        ref.watch(authRepositoryProvider).currentUser!.uid;
    final AsyncValue<List<ChatRoom>> chatRooms = ref.watch(chatRoomsProvider);

    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: switch (chatRooms) {
          AsyncError(:final error) => Center(child: Text(error.toString())),
          AsyncData(:final value) => ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: value.length,
              itemBuilder: (context, index) {
                final ChatRoom chatroom = value[index];
                final userId = chatroom.members
                    .firstWhere((element) => element != currentUserId);

                return ChatListItem(
                  userId: userId,
                  chatroom: chatroom,
                );
              }),
          _ => const Center(child: CircularProgressIndicator())
        },
      ),
    );
  }
}

class ChatListItem extends ConsumerWidget {
  const ChatListItem({
    super.key,
    required this.chatroom,
    required this.userId,
  });

  final String userId;
  final ChatRoom chatroom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserModel? receiver = ref.watch(getUserProvider(userId));

    if (receiver == null) {
      return const SizedBox.shrink();
    }

    return ListTile(
      onTap: () {
        context.go(
          '/chats/detail',
          extra: {
            'chatRoomId': chatroom.chatRoomId,
            'receiver': receiver,
          },
        );
      },
      leading: CircleAvatar(
        backgroundColor: Colors.black,
        radius: 25,
        backgroundImage: receiver.profilPic != ''
            ? CachedNetworkImage(
                imageUrl: receiver.profilPic,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error_outline)),
              ) as ImageProvider
            : const AssetImage('assets/images/no-profile.png'),
      ),
      title: Text(receiver.username),
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      subtitle: chatroom.type == 'text'
          ? Text(
              chatroom.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : Row(
              children: chatroom.type == 'image'
                  ? [
                      const Icon(Icons.image, size: 15, color: Colors.grey),
                      const SizedBox(width: 3),
                      const Text(
                        'Photo',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ]
                  : [
                      const Icon(Icons.video_camera_back_rounded,
                          size: 15, color: Colors.grey),
                      const SizedBox(width: 3),
                      const Text(
                        'Video',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ],
            ),
      trailing: Text(
        timeago.format(chatroom.timestamp),
      ),
    );
  }
}
