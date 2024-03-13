import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constant/color.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.isUpdate = false,
    this.size = 'small',
    required this.profilePic,
  });

  final bool isUpdate;
  final dynamic size;
  final String profilePic;

  @override
  Widget build(BuildContext context) {
    if (profilePic != '') {
      if (profilePic.startsWith('https://')) {
        return CachedNetworkImage(
          imageUrl: profilePic,
          fit: BoxFit.cover,
          imageBuilder: (context, imageProvider) => _buildAvatar(imageProvider),
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Center(
            child: Icon(
              Icons.error_outline,
              color: kIconColor,
            ),
          ),
        );
      }

      return _buildAvatar(FileImage(File(profilePic)));
    }

    return _buildAvatar(const AssetImage('assets/images/no-profile.png'));
  }

  CircleAvatar _buildAvatar(ImageProvider<Object>? backgroundImage) {
    return CircleAvatar(
      radius: size is String
          ? size == 'small'
              ? 18
              : size == 'medium'
                  ? 23
                  : size == 'large'
                      ? 30
                      : 60
          : size as double,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: backgroundImage,
    );
  }
}
