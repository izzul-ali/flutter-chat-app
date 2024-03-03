import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/auth/data/auth_provider.dart';
import 'package:flutter_chat_app/features/chat/presentation/widget/chat_list.dart';
import 'package:flutter_chat_app/features/chat/presentation/widget/contact_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            SizedBox(height: 130),
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
    final currentUser = ref.watch(authRepositoryProvider).currentUser;

    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        currentUser != null ? currentUser.displayName ?? "Chats" : 'Chats',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            if (currentUser != null) {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                useSafeArea: true,
                constraints: BoxConstraints(
                  minWidth: MediaQuery.sizeOf(context).width,
                  // minHeight: MediaQuery.sizeOf(context).height * 0.1,
                  maxHeight: MediaQuery.sizeOf(context).height * 0.1,
                ),
                enableDrag: true,
                builder: (context) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.topLeft,
                  child: Consumer(
                    builder: (context, ref, child) => InkWell(
                      onTap: () =>
                          ref.read(authServiceProvider.notifier).logout(),
                      child: const Text('Logout'),
                    ),
                  ),
                ),
              );
            }
          },
          child: const CircleAvatar(
            backgroundColor: Color(0xff363a4c),
            radius: 23,
            backgroundImage: AssetImage('assets/images/no-profile.png'),
          ),
        ),
        const SizedBox(width: 20)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
