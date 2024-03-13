import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/chat/presentation/widget/chat_list.dart';
import 'package:flutter_chat_app/features/chat/presentation/widget/contact_list.dart';
import 'package:flutter_chat_app/features/user/data/user_provider.dart';
import 'package:flutter_chat_app/widget/user_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const ChatsHeader(),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff000417),
              Color(0xff283671),
            ],
          ),
        ),
        child: const Column(
          children: [
            SizedBox(height: 120),
            ContactList(),
            SizedBox(height: 30),
            ChatList(),
          ],
        ),
      ),
    );
  }
}

class ChatsHeader extends ConsumerWidget implements PreferredSizeWidget {
  const ChatsHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return AppBar(
      backgroundColor: Colors.transparent,
      title: switch (currentUser) {
        AsyncData(:final value) => Text(
            value != null ? value.username : 'FChat',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        AsyncError(:final error) => Text(error.toString()),
        _ => const CircularProgressIndicator(),
      },
      actions: [
        InkWell(
          onTap: () {
            context.goNamed('Profile');
          },
          child: switch (currentUser) {
            AsyncData(:final value) => UserAvatar(
                size: 'medium',
                profilePic: value?.profilPic ?? '',
              ),
            AsyncError(:final error) => Text(error.toString()),
            _ => const CircularProgressIndicator(),
          },
        ),
        const SizedBox(width: 20)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
