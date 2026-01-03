import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get Current User (to check if logged in)
  User? get currentUser => _auth.currentUser;

  // Stream of User Changes (Detects login/logout instantly)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 1. Sign Up
  Future<User?> signUp({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred during sign up";
    }
  }

  // 2. Login
  Future<User?> signIn({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred during login";
    }
  }

  // 3. Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}