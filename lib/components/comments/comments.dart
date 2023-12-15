import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import './comment.dart';
import '../../models/user.dart';
import '../../models/comment.dart';
import '../../services/comments_service.dart';

class Comments extends StatelessWidget {
  final String postId;
  final String collectionName;

  const Comments(
      {super.key, required this.postId, required this.collectionName});

  void handleCommentSubmission(String comment, BuildContext context,
      TextEditingController commentController) {
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
      commentService.addComment(newComment, collectionName).then((_) {
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
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(
        children: <Widget>[
          Comment(
            user: User.defaultUser,
            comment: "Test comment",
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
                          value, context, commentController);
                    },
                    decoration: InputDecoration(
                      hintText: 'Write an answer...',
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
                    handleCommentSubmission(
                        commentController.text, context, commentController);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
