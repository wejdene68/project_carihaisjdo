import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // REGISTER

  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result.user;
    } on FirebaseAuthException {
      debugPrint("something wrong iwth firebase");
    }
    return null;
  }
  //  LOGIN

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result.user;
    } catch (e) {
      debugPrint("Login error: $e");
      return null;
    }
  }

  // LOGOUT

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }
}
