import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/user/data/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContactList extends ConsumerWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(userServiceProvider);

    return SizedBox(
      height: 90,
      child: switch (contacts) {
        AsyncError(:final error) => Center(
            child: Text(error.toString()),
          ),
        AsyncData(:final value) => ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(width: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: value.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                context.go(
                  '/chats/detail',
                  extra: {
                    'chatRoomId': null,
                    'receiver': value[index],
                  },
                );
              },
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 30,
                    backgroundImage: value[index].profilPic != ''
                        ? CachedNetworkImage(
                            imageUrl: value[index].profilPic,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Center(child: Icon(Icons.error_outline)),
                          ) as ImageProvider
                        : const AssetImage('assets/images/no-profile.png'),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    value[index].username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        _ => const Center(
            child: CircularProgressIndicator(),
          )
      },
    );
  }
}
