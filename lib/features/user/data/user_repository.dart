import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/features/user/domain/user.dart';

class UserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Future<void> addUser(UserModel user) async {
    try {
      final DocumentReference<Map<String, dynamic>> _ =
          await _firebaseFirestore.collection('users').add(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final List<UserModel> users =
          await _firebaseFirestore.collection('users').limit(20).get().then(
                (value) => {
                  for (var doc in value.docs) UserModel.fromMap(doc.data()),
                }.toList(),
              );

      return users;
    } catch (error) {
      rethrow;
    }
  }
}
