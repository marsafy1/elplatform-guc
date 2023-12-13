import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/post.dart';
import '../utils/images_slider.dart';
import '../utils/chip.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final String collection;
  const PostWidget({Key? key, required this.post, required this.collection})
      : super(key: key);

  @override
  State<PostWidget> createState() => _PostState();
}

class _PostState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      // margin: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 5.0, top: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            _buildPostContent(),
            const SizedBox(height: 10),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          backgroundColor: Colors.black,
          child: Text('AN'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  widget.post.user!.firstName +
                      " " +
                      widget.post.user!.lastName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text('5th year student',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ChipElement(category: widget.post.category),
            Text(timeago.format(widget.post.dateCreated),
                style: const TextStyle(color: Colors.grey)),
          ],
        )
      ],
    );
  }

  Widget _buildPostContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.post.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget.post.description,
          style: const TextStyle(height: 1.5),
        ),
        const SizedBox(height: 10),
        ImageSlider(photosUrlsOriginal: widget.post.photosUrls),
      ],
    );
  }

  Widget _buildFooter(context) {
    Map<String, IconData> collectionToInteractionIcon = {
      "questions": FontAwesomeIcons.arrowUp,
      "confessions": FontAwesomeIcons.heart
    };
    Map<String, String> collectionToInteractionAction = {
      "questions": "Upvote",
      "confessions": "Like"
    };
    Map<String, String> collectionToComment = {
      "questions": "Answers",
      "confessions": "Comments"
    };
    IconData interactionIcon = collectionToInteractionIcon[widget.collection] ??
        FontAwesomeIcons.heart;
    String interactionAction =
        collectionToInteractionAction[widget.collection] ?? "Like";
    String interactionComment =
        collectionToComment[widget.collection] ?? "Comments";
    return Column(
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1,441 ${interactionAction}s'),
            Text('213 $interactionComment'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(interactionIcon, size: 17),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(interactionAction)
                    ],
                  ),
                ),
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.comment, size: 17),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(interactionComment)
                    ],
                  ),
                ),
                onTap: () => showCommentsBottomSheet(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void showCommentsBottomSheet(BuildContext context) {
    TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Padding(
          padding: MediaQuery.of(bc).viewInsets,
          child: Wrap(
            children: <Widget>[
              const ListTile(
                leading: CircleAvatar(child: Text('AB')),
                title: Text('Commenter Name'),
                subtitle: Text('Comment text goes here...'),
              ),
              const ListTile(
                leading: CircleAvatar(child: Text('CD')),
                title: Text('Another Name'),
                subtitle: Text('Another comment text...'),
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
      },
    );
  }

  void handleCommentSubmission(String comment, BuildContext context,
      TextEditingController commentController) {
    if (comment.trim().isNotEmpty) {
      // TODO: Implement the logic to post the comment
      commentController.clear(); // Clear the text field after submission
      Navigator.pop(
          context); // Optionally close the bottom sheet after submission
    }
  }
}
