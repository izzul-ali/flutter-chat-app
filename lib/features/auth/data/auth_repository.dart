import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/features/auth/domain/auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authState => _firebaseAuth.authStateChanges();

  Future<UserCredential?> signInUser(AuthModel credential) async {
    try {
      final UserCredential auth =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: credential.email,
        password: credential.password,
      );

      return auth;
    } catch (error) {
      rethrow;
    }
  }

  Future<UserCredential> registerUser(AuthModel credential) async {
    try {
      final UserCredential auth =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: credential.email,
        password: credential.password,
      );

      auth.user?.updateDisplayName(credential.username);

      return auth;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
