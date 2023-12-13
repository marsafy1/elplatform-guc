import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

class PostsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Post>> getPosts(String collection) {
    Stream<List<Post>> fetchedPosts = _firestore
        .collection(collection)
        .orderBy('dateCreated', descending: true) // Add this line
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Post.fromMap(doc.data(), doc.id))
          .toList();
    });

    return fetchedPosts;
  }

  Future<void> addPost(String collection, Post post) async {
    await _firestore.collection(collection).add(post.toMap());
  }
}
