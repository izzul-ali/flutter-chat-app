import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constant/color.dart';
import 'package:flutter_chat_app/widget/user_avatar.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  const ChatHeader({
    super.key,
    required this.profilePic,
    required this.username,
  });

  final String profilePic;
  final String username;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leadingWidth: 84,
      leading: SizedBox(
        child: Row(
          children: [
            const BackButton(),
            UserAvatar(profilePic: profilePic, size: 'small'),
          ],
        ),
      ),
      title: Text(
        username,
        style: const TextStyle(
          color: Color(0xff000E08),
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.call,
            color: kIconColor,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.videocam_outlined,
            size: 27,
            color: kIconColor,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
