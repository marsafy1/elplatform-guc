import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/services/notifications_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/post.dart';
import '../models/user.dart';

class PostsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Post>> getPosts(String collection) {
    Stream<List<Post>> fetchedPosts = _firestore
        .collection(collection)
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      // Create a list to keep all the posts
      List<Post> posts = [];

      for (var doc in snapshot.docs) {
        // Create a Post object from the document
        Post post = Post.fromMap(doc.data(), doc.id);

        // Fetch the user data for this post using the userId
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(post.userId).get();
        User user;
        if (userSnapshot.exists) {
          // Create a User object from the user document
          user = User.fromMap(
              userSnapshot.data() as Map<String, dynamic>, userSnapshot.id);
        } else {
          user = User.defaultUser;
        }

        // Add the user data to the Post object
        post = Post.fromMap(doc.data(), doc.id, user: user);

        // Add the post with user data to the list of posts
        posts.add(post);
      }

      // Return the list of posts with user data
      return posts;
    });

    return fetchedPosts;
  }

  Future<void> addPost(String collection, Post post) async {
    await _firestore.collection(collection).add(post.toMap());
  }

  Future<void> deletePost(String collection, String postId) async {
    DocumentReference postRef = _firestore.collection(collection).doc(postId);

    await postRef.delete().catchError((error) {
      throw Exception("Error deleting post: $error");
    });
  }

  Future<void> likePost(String collection, String postId, String userId) async {
    DocumentReference postRef = _firestore.collection(collection).doc(postId);
    print("Collection $collection");
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(postRef);

      if (!snapshot.exists) {
        throw Exception("Post does not exist!");
      }

      List<String> likedByUsers =
          List<String>.from(snapshot['likedByUsers'] ?? []);
      if (!likedByUsers.contains(userId)) {
        likedByUsers.add(userId);
      }
      transaction.update(postRef, {'likedByUsers': likedByUsers});
      NotificationService.sendLikeNotification(
          userId, snapshot['userId'], postId);
    });
  }

  Future<void> unlikePost(
      String collection, String postId, String userId) async {
    DocumentReference postRef = _firestore.collection(collection).doc(postId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(postRef);

      if (!snapshot.exists) {
        throw Exception("Post does not exist!");
      }

      List<String> likedByUsers =
          List<String>.from(snapshot['likedByUsers'] ?? []);
      likedByUsers.remove(userId);

      transaction.update(postRef, {'likedByUsers': likedByUsers});
    });
  }

  Future<void> changeResolveStatusPost(
      String collection, String postId, bool value) async {
    DocumentReference postRef = _firestore.collection(collection).doc(postId);
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(postRef);
      if (!snapshot.exists) {
        throw Exception("Post does not exist!");
      }
      transaction.update(postRef, {'resolved': value});
    });
  }

  Future<String?> uploadImage(File imageFile) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    // Create a unique file name with timestamp
    String fileName = '${timestamp}_${basename(imageFile.path)}';
    Reference storageRef =
        FirebaseStorage.instance.ref().child('post_images/$fileName');
    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    if (snapshot.state == TaskState.success) {
      return await snapshot.ref.getDownloadURL();
    }
    return null;
  }
}
