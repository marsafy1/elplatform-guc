import 'package:cloud_firestore/cloud_firestore.dart';
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
}
