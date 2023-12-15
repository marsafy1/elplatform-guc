import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/post.dart';
import '../utils/images_slider.dart';
import '../utils/chip.dart';
import '../utils/verified_check.dart';
import '../comments/comments.dart';
import '../../utils_functions/profile.dart';

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
    Widget userAvatar = generateAvatar(context, widget.post.user!);

    return Row(
      children: [
        userAvatar,
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                      "${widget.post.user!.firstName} ${widget.post.user!.lastName}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (widget.post.user!.isPublisher) const VerifiedCheck(),
                ],
              ),
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
      "feed": FontAwesomeIcons.thumbsUp,
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Comments(postId: widget.post.id);
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
