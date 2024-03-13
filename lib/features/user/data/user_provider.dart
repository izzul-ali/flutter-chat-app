import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/features/auth/data/auth_provider.dart';
import 'package:flutter_chat_app/features/user/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

// set keepAlive: false, cause getAllUsers called twice after register
@riverpod
class UserService extends _$UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<UserModel>> build() {
    return _getAllUsers();
  }

  Stream<List<UserModel>> _getAllUsers() {
    final currentUser = ref.watch(authRepositoryProvider).currentUser;

    final StreamController<List<UserModel>> streamUsers =
        StreamController<List<UserModel>>();

    final queryUsers =
        _firestore.collection('users').snapshots().listen((event) {
      final List<UserModel> users = [];

      for (var data in event.docs) {
        if (!(data.data()['uid'] == currentUser?.uid)) {
          users.add(UserModel.fromMap(data.data()));
        }
      }

      streamUsers.sink.add(users);
    });

    ref.onDispose(() {
      queryUsers.cancel();
      streamUsers.close();
    });

    return streamUsers.stream;
  }

  Future<UserModel?> getCurrentUser(String uid) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> user = await _firestore
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      return UserModel.fromMap(user.docs[0].data());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(UserModel credential) async {
    try {
      await _firestore
          .collection('users')
          .doc(credential.uid)
          .update(credential.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfilePic({
    required String pic,
    required String uid,
    required String username,
  }) async {
    try {
      final profileRef = FirebaseStorage.instance.ref('images/profile');

      final filePic = File(pic);

      final imgRef =
          profileRef.child("${uid}___${filePic.uri.pathSegments.last}");

      await imgRef.putFile(filePic);

      final imgUrl = await imgRef.getDownloadURL();

      await _firestore
          .collection('users')
          .doc(uid)
          .update({'profilPic': imgUrl});

      ref.invalidate(currentUserProvider);
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
UserModel? getUserById(GetUserByIdRef ref, String userId) {
  final List<UserModel>? currentUsers =
      ref.watch(userServiceProvider.select((value) => value)).value;
  try {
    final UserModel? user = currentUsers?.firstWhere(
      (user) => user.uid == userId,
    );
    return user;
  } catch (e) {
    return null;
  }
}

@Riverpod(keepAlive: true)
FutureOr<UserModel?> currentUser(CurrentUserRef ref) async {
  ref.onDispose(() {
    print('current user dispose');
  });

  final User? currUser = ref.watch(authRepositoryProvider).currentUser;

  if (currUser != null) {
    final QuerySnapshot<Map<String, dynamic>> user = await FirebaseFirestore
        .instance
        .collection('users')
        .where('uid', isEqualTo: currUser.uid)
        .get();

    return UserModel.fromMap(user.docs[0].data());
  }

  return null;
}
