import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
      surfaceTintColor:
          Colors.white, // disable change bg color when scrolling down
      backgroundColor: Colors.white,
      leadingWidth: 84,
      leading: SizedBox(
        child: Row(
          children: [
            const BackButton(),
            CircleAvatar(
              backgroundImage: profilePic != ''
                  ? CachedNetworkImage(
                      imageUrl: profilePic,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Center(child: Icon(Icons.error_outline)),
                    ) as ImageProvider
                  : const AssetImage('assets/images/no-profile.png'),
              backgroundColor: Colors.grey,
              radius: 18,
            ),
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
          icon: const Icon(Icons.call),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.videocam_outlined,
            size: 27,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
