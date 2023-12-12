import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

class PostsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Post>> getPosts() {
    Stream<List<Post>> fetchedQuestions = _firestore
        .collection('posts')
        .orderBy('dateCreated', descending: true) // Add this line
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Post.fromMap(doc.data(), doc.id))
          .toList();
    });

    return fetchedQuestions;
  }

  Future<void> addQuestion(Post question) async {
    await _firestore.collection('posts').add(question.toMap());
  }
}
