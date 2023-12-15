import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment(CommentModel comment, String collectionName) async {
    print("REACHED COMMENT SERVIDES");
    print("comment is");
    print(comment.comment);
    print("Collection is $collectionName");
    await _firestore.collection(collectionName).add(comment.toMap());
  }
}
