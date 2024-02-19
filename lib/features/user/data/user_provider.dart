import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/features/user/data/user_repository.dart';
import 'package:flutter_chat_app/features/user/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository(firebaseFirestore: FirebaseFirestore.instance);
}

@Riverpod(keepAlive: true)
class UserService extends _$UserService {
  @override
  Future<List<UserModel>> build() async {
    final List<UserModel> users =
        await ref.watch(userRepositoryProvider).getAllUsers();

    return users;
  }
}
