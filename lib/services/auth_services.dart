import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Current logged-in user
  static User? get currentUser => _auth.currentUser;

  // Register new user
  static Future<User?> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final UserCredential result =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = result.user;

      if (user == null) {
        return null;
      }

      // Save user's profile in Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return user;
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    } catch (e) {
      throw 'Registration failed. Please try again.';
    }
  }

  // Login existing user
  static Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    } catch (e) {
      throw 'Login failed. Please try again.';
    }
  }

  // Send password reset email
  static Future<void> resetPassword(
    String email,
  ) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    } catch (e) {
      throw 'Unable to send reset email.';
    }
  }

  // Get current user's profile from Firestore
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    try {
      final DocumentSnapshot<Map<String, dynamic>> document =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .get();

      if (!document.exists) {
        return null;
      }

      return document.data();
    } catch (e) {
      throw 'Unable to load profile.';
    }
  }

  // Update user profile
  static Future<void> updateUserProfile({
    required String name,
    required String phone,
  }) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw 'Please login first.';
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': name.trim(),
        'email': user.email ?? '',
        'phone': phone.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw 'Unable to update profile.';
    }
  }

  // Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // Convert Firebase errors into simple messages
  static String _getAuthErrorMessage(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'weak-password':
        return 'Password is too weak.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      default:
        return e.message ??
            'Authentication failed. Please try again.';
    }
  }
}