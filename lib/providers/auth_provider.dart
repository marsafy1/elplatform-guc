import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:guc_swiss_knife/models/user.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;
  User? _user = User(
      id: "1",
      firstName: "Ahmed",
      lastName: "Nasser",
      email: "ahmed.elkakhaia@student.guc.edu.eg",
      userType: UserType.student,
      header: "Software Engineer | Ex-Amazon",
      bio:
          "I am a software engineer who is passionate about mobile development and open source.",
      faculty: "MET-CS",
      isPublisher: true,
      gucId: '49-17266',
      photoUrl:
          "https://media.licdn.com/dms/image/D4E03AQF8DvuOB4-NBQ/profile-displayphoto-shrink_800_800/0/1692136136142?e=1706745600&v=beta&t=35kUFJnQ5CG1XF5ljn1nm-7li0n7fMTqYHs2KMlxyrg");

  AuthProvider() {
    FirebaseAuth.FirebaseAuth.instance
        .authStateChanges()
        .listen((FirebaseAuth.User? user) async {
      // if (user == null) {
      //   _user = null;
      // }
      // _user = await _userFromFirebaseUser(user!);
      notifyListeners();
    });
  }

  bool get isAuthenticated {
    return _auth.currentUser != null;
  }

  // Future<User?> _userFromFirebaseUser(FirebaseAuth.User user) async {
  //   final uid = user.uid;
  //   var userData =
  //       await FirebaseFirestore.instance.collection('users').doc(uid).get();
  //   return User(
  //       id: uid,
  //       firstName: userData.data()!["firstName"],
  //       lastName: userData.data()!["lastName"],
  //       email: userData.data()!["email"],
  //       userType: userData.data()!["userType"],
  //       isPublisher: userData.data()!["isPublisher"]);
  //   // return
  // }

  User? get user {
    return _user;
  }

  Future<FirebaseAuth.User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final FirebaseAuth.UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential.user;
    } on FirebaseAuth.FirebaseAuthException catch (e) {
      throw AuthException(message: _handleAuthException(e));
    }
  }

  Future<FirebaseAuth.User?> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final FirebaseAuth.UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        throw AuthException(message: 'User creation failed');
      }

      final String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'isPublisher': false
        // TODO: add userType
      });

      return userCredential.user;
    } on FirebaseAuth.FirebaseAuthException catch (e) {
      throw AuthException(message: _handleAuthException(e));
    }
  }

  String _handleAuthException(FirebaseAuth.FirebaseAuthException e) {
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
    FirebaseAuth.FirebaseAuth.instance.signOut();
  }

  void updateUser() {
    // Todo: implement
  }
}

class AuthException implements Exception {
  final String message;

  AuthException({required this.message});
}
