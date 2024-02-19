import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/route/route.dart';
import 'package:flutter_chat_app/features/auth/domain/auth.dart';
import 'package:flutter_chat_app/features/user/data/user_provider.dart';
import 'package:flutter_chat_app/features/user/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/features/auth/data/auth_repository.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  // refresh router to get current auth state
  ref.listenSelf(
    (prev, next) => {
      debugPrint('auth state changes ${next.currentUser}'),
      ref.read(goRouterProvider).refresh()
    },
  );

  return AuthRepository(firebaseAuth: FirebaseAuth.instance);
}

@Riverpod(keepAlive: false)
class AuthService extends _$AuthService {
  @override
  void build() {}

  Future<void> login(AuthModel credential) async {
    try {
      final AuthCredential? _ =
          await ref.read(authRepositoryProvider).signInUser(credential);

      // save token to secure storage
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(AuthModel credential) async {
    try {
      final UserCredential userAuthCredential =
          await ref.read(authRepositoryProvider).registerUser(credential);

      final User? userCredential = userAuthCredential.user;
      if (userCredential?.uid == null || userCredential?.email == null) {
        throw ErrorDescription('Failed to register');
      }

      ref.read(userRepositoryProvider).addUser(
            UserModel(
              uid: userCredential!.uid,
              username: credential.username,
              email: userCredential.email!,
              profilPic: '',
            ),
          );
    } catch (e) {
      rethrow;
    }
  }
}
