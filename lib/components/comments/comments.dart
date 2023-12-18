import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import './comment.dart';
import '../../models/comment.dart';
import '../../services/comments_service.dart';

class Comments extends StatelessWidget {
  final String postId;
  final String collectionName;
  final String commentsDisplayedName;
  final CommentService _commentsService = CommentService();

  Comments(
      {super.key,
      required this.postId,
      required this.collectionName,
      required this.commentsDisplayedName});

  void handleCommentSubmission(String comment, BuildContext context,
      TextEditingController commentController, String postId) {
    CommentService commentService = CommentService();
    final userAuth = Provider.of<AuthProvider>(context, listen: false);
    if (comment.trim().isNotEmpty) {
      CommentModel newComment = CommentModel(
        postId: postId,
        userId: userAuth.user!.id,
        comment: commentController.text,
        dateCreated: DateTime.now(),
      );
      // Add the comment to Firestore
      print(collectionName);
      commentService.addComment(newComment, collectionName, postId).then((_) {
        print('Comment added successfully.');
        commentController.clear(); // Clear the text field after submission
        Navigator.pop(
            context); // Optionally close the bottom sheet after submission
      }).catchError((error) {
        print('Error adding comment: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();
    return StreamBuilder(
        stream: _commentsService.getComments(collectionName, postId),
        builder: (context, AsyncSnapshot<List<CommentModel>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // Retrieve posts and filter them based on selected categories
          List<CommentModel> allComments = snapshot.data ?? [];

          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(commentsDisplayedName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (snapshot.connectionState != ConnectionState.waiting &&
                    allComments.isNotEmpty)
                  Column(
                    children: allComments.map((comment) {
                      return Comment(comment: comment);
                    }).toList(),
                  ),
                if (snapshot.connectionState != ConnectionState.waiting &&
                    allComments.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Center(child: Text("No $commentsDisplayedName")),
                  ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (value) {
                            handleCommentSubmission(
                                value, context, commentController, postId);
                          },
                          decoration: InputDecoration(
                            hintText: "What's on your mind?",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[800],
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          handleCommentSubmission(commentController.text,
                              context, commentController, postId);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
