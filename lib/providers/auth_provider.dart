import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:guc_swiss_knife/models/user.dart';
import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/services/user_service.dart';

class AuthProvider with ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    firebase_auth.FirebaseAuth.instance
        .authStateChanges()
        .listen((firebase_auth.User? user) {
      notifyListeners();
    });

    firebase_auth.FirebaseAuth.instance
        .authStateChanges()
        .listen((firebase_auth.User? user) {
      if (user == null) {
        _user = null;
      } else {
        UserService.getUserById(user.uid).then((value) => _user = value);
        notifyListeners();
      }
    });
  }

  bool get isAuthenticated {
    return _auth.currentUser != null;
  }

  User? get user {
    return _user;
  }

  Future<firebase_auth.User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final firebase_auth.UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential.user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: _handleAuthException(e));
    }
  }

  Future<firebase_auth.User?> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required UserType userType,
  }) async {
    try {
      final firebase_auth.UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        throw AuthException(message: 'User creation failed');
      }

      final String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'is_publisher': false,
        'user_type': userType.toShortString(),
      });
      return userCredential.user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: _handleAuthException(e));
    }
  }

  String _handleAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'invalid-credential':
        return 'Incorrect email address or password.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return 'An unexpected error occurred. Please try again later.';
    }
  }

  void logout() {
    firebase_auth.FirebaseAuth.instance.signOut();
  }

  Future<void> updateUser({
    String? firstName,
    String? lastName,
    String? header,
    String? bio,
    String? faculty,
    String? gucId,
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(_user!.id).update({
      'first_name': firstName ?? _user!.firstName,
      'last_name': lastName ?? _user!.lastName,
      'header': header ?? _user!.header,
      'bio': bio ?? _user!.bio,
      'faculty': faculty ?? _user!.faculty,
      'guc_id': gucId ?? _user!.gucId,
    });

    _user = User(
      id: _user!.id,
      firstName: firstName ?? _user!.firstName,
      lastName: lastName ?? _user!.lastName,
      email: _user!.email,
      userType: _user!.userType,
      isPublisher: _user!.isPublisher,
      header: header ?? _user!.header,
      bio: bio ?? _user!.bio,
      faculty: faculty ?? _user!.faculty,
      gucId: gucId ?? _user!.gucId,
    );

    notifyListeners();
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final firebase_auth.User? user = _auth.currentUser;

    if (user == null) {
      throw AuthException(message: 'User not found');
    }

    final firebase_auth.AuthCredential credential =
        firebase_auth.EmailAuthProvider.credential(
      email: user.email!,
      password: oldPassword,
    );

    try {
      await user.reauthenticateWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: _handleAuthException(e));
    }

    try {
      await user.updatePassword(newPassword);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: _handleAuthException(e));
    }
  }
}

class AuthException implements Exception {
  final String message;

  AuthException({required this.message});
}
