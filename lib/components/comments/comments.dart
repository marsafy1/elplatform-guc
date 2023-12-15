import 'package:flutter/material.dart';
import './comment.dart';
import '../../models/user.dart';

class Comments extends StatelessWidget {
  final String postId;

  const Comments({super.key, required this.postId});

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
                      // handleCommentSubmission(
                      // value, context, commentController);
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
                    // handleCommentSubmission(
                    // commentController.text, context, commentController);
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
