import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/auth/domain/auth.dart';
import 'package:flutter_chat_app/features/user/data/user_provider.dart';
import 'package:flutter_chat_app/features/user/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/features/auth/data/auth_repository.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(firebaseAuth: FirebaseAuth.instance);
}

@riverpod
class AuthService extends _$AuthService {
  @override
  void build() {}

  Future<void> login(AuthModel credential) async {
    try {
      final UserCredential? user =
          await ref.read(authRepositoryProvider).signInUser(credential);

      if (user?.user != null) {
        await ref
            .read(userServiceProvider.notifier)
            .getCurrentUser(user!.user!.uid);

        return;
      }

      await ref.read(authRepositoryProvider).logout();
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

      final UserModel user = UserModel(
        uid: userCredential!.uid,
        username: credential.username,
        email: userCredential.email!,
        profilPic: '',
      );

      await ref.read(userServiceProvider.notifier).addUser(user);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (e) {
      rethrow;
    }
  }
}
