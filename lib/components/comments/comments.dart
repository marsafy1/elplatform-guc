import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import './comment.dart';
import '../../models/comment.dart';
import '../../services/comments_service.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String collectionName;
  final String commentsDisplayedName;

  const Comments({
    super.key,
    required this.postId,
    required this.collectionName,
    required this.commentsDisplayedName,
  });

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final CommentService _commentsService = CommentService();
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    commentFocusNode.addListener(() {
      if (commentFocusNode.hasFocus) {
        setState(() => isKeyboardVisible = true);
      } else {
        setState(() => isKeyboardVisible = false);
      }
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    commentFocusNode.dispose();
    super.dispose();
  }

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
      commentService
          .addComment(newComment, widget.collectionName, postId)
          .then((_) {
        commentController.clear(); // Clear the text field after submission
      }).catchError((error) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          _commentsService.getComments(widget.collectionName, widget.postId),
      builder: (context, AsyncSnapshot<List<CommentModel>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // Retrieve comments
        List<CommentModel> allComments = snapshot.data ?? [];

        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(widget.commentsDisplayedName,
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    maxHeight: isKeyboardVisible ? 200 : 450,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: allComments.map((comment) {
                        return Comment(
                            key: ValueKey(comment.id), comment: comment);
                      }).toList(),
                    ),
                  ),
                ),
              if (snapshot.connectionState != ConnectionState.waiting &&
                  allComments.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child:
                      Center(child: Text("No ${widget.commentsDisplayedName}")),
                ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        focusNode: commentFocusNode,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (value) {
                          handleCommentSubmission(
                              value, context, commentController, widget.postId);
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
                        handleCommentSubmission(commentController.text, context,
                            commentController, widget.postId);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
