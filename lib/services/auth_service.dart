import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Performs anonymous sign-in. This is intended to be called on first launch.
  static Future<UserCredential?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      if (kDebugMode) {
        print("Signed in with temporary account: ${userCredential.user?.uid}");
      }
      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print("Error signing in anonymously: $e");
      }
      return null;
    }
  }

  /// Returns the current user if one exists.
  static User? get currentUser => _auth.currentUser;
}
