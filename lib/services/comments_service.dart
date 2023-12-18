import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:guc_swiss_knife/models/post.dart';
import 'package:guc_swiss_knife/services/notifications_service.dart';
import 'package:guc_swiss_knife/services/posts_service.dart';
import '../models/comment.dart';
import '../models/user.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CommentModel>> getComments(String collection, String postId) {
    Stream<List<CommentModel>> fetchedComments = _firestore
        .collection(collection)
        .where("postId", isEqualTo: postId)
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      // Create a list to keep all the posts
      List<CommentModel> comments = [];

      for (var doc in snapshot.docs) {
        // Create a Post object from the document
        CommentModel comment = CommentModel.fromMap(doc.data(), doc.id);

        // Fetch the user data for this post using the userId
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(comment.userId).get();
        User user;
        if (userSnapshot.exists) {
          // Create a User object from the user document
          user = User.fromMap(
              userSnapshot.data() as Map<String, dynamic>, userSnapshot.id);
        } else {
          user = User.defaultUser;
        }

        // Add the user data to the Post object
        comment = CommentModel.fromMap(doc.data(), doc.id, user: user);

        // Add the post with user data to the list of posts
        comments.add(comment);
      }

      // Return the list of posts with user data
      return comments;
    });

    return fetchedComments;
  }

  Future<void> addComment(
      CommentModel comment, String collectionName, String postId) async {
    await _firestore.runTransaction((transaction) async {
      await _firestore.collection(collectionName).add(comment.toMap());
      DocumentSnapshot snapshot = await PostsService()
          .getPostById(postId, collectionName.replaceAll("comments_", ""));
      NotificationService.sendCommentNotification(
          comment.userId,
          comment.postId,
          collectionName.replaceAll("comments_", ""),
          snapshot['userId']);
    });
  }
}
