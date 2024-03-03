import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
      final DocumentReference<Map<String, dynamic>> _ =
          await _firestore.collection('users').add(user.toMap());
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
UserModel? getUser(GetUserRef ref, String userId) {
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
