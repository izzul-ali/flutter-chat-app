import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/helper/upload_media.dart';
import 'package:flutter_chat_app/features/auth/data/auth_provider.dart';
import 'package:flutter_chat_app/features/user/data/user_provider.dart';
import 'package:flutter_chat_app/features/user/domain/user.dart';
import 'package:flutter_chat_app/widget/button_widget.dart';
import 'package:flutter_chat_app/widget/user_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? imgPath;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<UserModel?> currentUser = ref.watch(currentUserProvider);

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: const Text('Profile'),
        ),
        body: switch (currentUser) {
          AsyncData(:final value) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        UserAvatar(
                          isUpdate: imgPath != null,
                          size: 'big',
                          profilePic: imgPath != null
                              ? imgPath!
                              : value?.profilPic ?? '',
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              final imgFile =
                                  await UploadMedia.handlePickImageOrVideo(
                                      type: 'image');

                              if (imgFile != null) {
                                setState(() {
                                  imgPath = imgFile.path;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(value?.email ?? ''),
                  const SizedBox(height: 5),
                  Text(
                    value?.username ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  imgPath != null
                      ? SizedBox(
                          width: double.infinity,
                          child: DefaultCustomButton(
                            onPressed: () async {
                              if (value != null) {
                                try {
                                  // await ref
                                  //     .read(userServiceProvider.notifier)
                                  //     .updateUser(
                                  //       value.copyWith(profilPic: imgPath),
                                  //     );

                                  await ref
                                      .read(userServiceProvider.notifier)
                                      .updateProfilePic(
                                        pic: imgPath!,
                                        uid: value.uid,
                                        username: value.username,
                                      );

                                  imgPath = null;
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }
                                }
                              }
                            },
                            label: 'Update',
                          ),
                        )
                      : const SizedBox.shrink(),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: DefaultCustomButton(
                      onPressed: () async {
                        await ref.read(authServiceProvider.notifier).logout();
                      },
                      label: 'Logout',
                    ),
                  )
                ],
              ),
            ),
          AsyncError(:final error) => Center(
              child: Text(error.toString()),
            ),
          _ => Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 100,
              child: const CircularProgressIndicator(),
            ),
        });
  }
}
