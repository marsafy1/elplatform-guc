import 'package:flutter/material.dart';
import 'dart:math';
import 'package:timeago/timeago.dart' as timeago;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../models/post.dart';
import '../utils/images_slider.dart';
import '../utils/chip.dart';
import '../utils/verified_check.dart';
import '../comments/comments.dart';
import '../../utils_functions/profile.dart';
import '../../utils_functions/ghost.dart';
import '../../utils_functions/success_chip.dart';
import '../../services/posts_service.dart';
import '../toast/toast.dart';

class PostWidget extends StatefulWidget {
  final PostsService _postsService = PostsService();
  final Post post;
  final String collection;
  PostWidget({Key? key, required this.post, required this.collection})
      : super(key: key);

  @override
  State<PostWidget> createState() => _PostState();
}

class _PostState extends State<PostWidget> {
  bool isLikedByUser = false;
  bool isLikedByUserUI = false;
  bool isResolved = false;
  bool isResolvedUI = false;
  int interactionsCount = 0;
  @override
  void initState() {
    super.initState();

    final userAuth = Provider.of<AuthProvider>(context, listen: false);
    String currentUserId = userAuth.user!.id;

    if (widget.post.likedByUsers != null) {
      isLikedByUser = widget.post.likedByUsers!.contains(currentUserId);
      isLikedByUserUI = isLikedByUser;
    }
    isResolved = widget.post.resolved;
    isResolvedUI = isResolved;
    interactionsCount =
        widget.post.likedByUsers != null ? widget.post.likedByUsers!.length : 0;
  }

  Map<String, IconData> collectionToInteractionIcon = {
    "feed": FontAwesomeIcons.thumbsUp,
    "questions": FontAwesomeIcons.circleUp,
    "lost_and_founds": FontAwesomeIcons.circleUp,
    "confessions": FontAwesomeIcons.heart
  };
  Map<String, IconData> collectionToInteractedIcon = {
    "feed": FontAwesomeIcons.solidThumbsUp,
    "questions": FontAwesomeIcons.solidCircleUp,
    "lost_and_founds": FontAwesomeIcons.solidCircleUp,
    "confessions": FontAwesomeIcons.solidHeart
  };
  Map<String, String> collectionToInteractionAction = {
    "questions": "Upvote",
    "lost_and_founds": "Upvote",
    "confessions": "Like"
  };
  Map<String, String> collectionToComment = {
    "questions": "Answers",
    "confessions": "Comments"
  };

  Map<String, String> collectionToResolvedOption = {
    "questions": "Answered",
    "lost_and_founds": "Found"
  };
  Map<String, String> collectionToResolveOption = {
    "questions": "Mark as Answered",
    "lost_and_founds": "Mark as Found"
  };
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
    String displayedName =
        "${widget.post.user!.firstName} ${widget.post.user!.lastName}";
    if (widget.post.anon) {
      userAvatar = generateGhostAvatar();
      displayedName = "Ghost";
    }
    bool showCategory = widget.collection == "questions" ||
        widget.collection == "lost_and_founds";
    bool showResolveOption = widget.collection == "questions" ||
        widget.collection == "lost_and_founds";
    String resolvedString =
        collectionToResolvedOption[widget.collection] ?? "Resolved";
    String bio = "";
    if (widget.post.user != null) {
      if (widget.post.user!.bio != null) {
        bio = widget.post.user!.bio!;
        bio = bio.substring(0, min(bio.length, 20));
      }
    }
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
                  Text(displayedName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (widget.post.user!.isPublisher && !widget.post.anon)
                    const VerifiedCheck(),
                ],
              ),
              if (!widget.post.anon && bio.isNotEmpty)
                Text(bio, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (showCategory) ChipElement(category: widget.post.category),
            Text(timeago.format(widget.post.dateCreated),
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildPostContent() {
    final userAuth = Provider.of<AuthProvider>(context, listen: false);
    String currentUserId = userAuth.user!.id;
    bool userOwnsPost = widget.post.userId == currentUserId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.post.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (userOwnsPost)
                PopupMenuButton<String>(
                  onSelected: _handleMenuSelection,
                  color: Theme.of(context).secondaryHeaderColor,
                  itemBuilder: (BuildContext context) {
                    return {'Delete'}.map((String choice) {
                      return PopupMenuItem<String>(
                        height: 12,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        value: choice,
                        child: Row(
                          children: [
                            Icon(
                                choice == 'Delete'
                                    ? FontAwesomeIcons.trash
                                    : null,
                                size: 13),
                            const SizedBox(width: 8),
                            Text(
                              choice,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.ellipsisVertical,
                    size: 17,
                    color: Colors.grey,
                  ),
                ),
            ],
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

  void _handleMenuSelection(String choice) {
    if (choice == 'Delete') {
      _showDeleteConfirmationBottomSheet();
    } else {
      // Handle other menu options here
    }
  }

  void _showDeleteConfirmationBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('Confirm Deletion'),
                subtitle: Text('Are you sure you want to delete this post?'),
              ),
              ButtonBar(
                children: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss the bottom sheet
                    },
                  ),
                  TextButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      // Call your deletion function here
                      _deletePost();
                      Navigator.of(context).pop(); // Dismiss the bottom sheet
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _deletePost() {
    try {
      widget._postsService.deletePost(widget.collection, widget.post.id);
      Toast.show(context, "Deleted Successfully", "success",
          onTap: () {}, icon: FontAwesomeIcons.check);
    } catch (e) {
      Toast.show(context, "Error Occurred", "error",
          onTap: () {}, icon: FontAwesomeIcons.xmark);
    }
  }

  Widget _buildFooter(context) {
    IconData interactionIcon = collectionToInteractionIcon[widget.collection] ??
        FontAwesomeIcons.heart;
    IconData interactedIcon = collectionToInteractedIcon[widget.collection] ??
        FontAwesomeIcons.solidHeart;
    IconData interactionIconBtn = interactionIcon;
    if (isLikedByUserUI) {
      interactionIconBtn = interactedIcon;
    }
    String interactionAction =
        collectionToInteractionAction[widget.collection] ?? "Like";
    String interactionComment =
        collectionToComment[widget.collection] ?? "Comments";

    String interactionActionText =
        interactionsCount != 1 ? "${interactionAction}s" : interactionAction;

    bool showResolveOption = widget.collection == "questions" ||
        widget.collection == "lost_and_founds";
    final userAuth = Provider.of<AuthProvider>(context, listen: false);
    String currentUserId = userAuth.user!.id;
    bool userOwnsPost = widget.post.userId == currentUserId;
    String resolvedString = "Resolved";
    String resolveString = "Resolve";
    String displayedResolveOption = "Resolve";
    if (showResolveOption) {
      resolvedString =
          collectionToResolvedOption[widget.collection] ?? resolvedString;
      resolveString =
          collectionToResolveOption[widget.collection] ?? resolveString;
      if (isResolvedUI) {
        displayedResolveOption = resolvedString;
      } else {
        displayedResolveOption = resolveString;
      }
    }

    return Column(
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$interactionsCount $interactionActionText'),
            if (showResolveOption && isResolvedUI)
              statusChip(resolvedString, Colors.green),
            if (showResolveOption && !isResolvedUI)
              statusChip("", Colors.transparent),
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
                      FaIcon(
                        interactionIconBtn,
                        size: 17,
                        color: isLikedByUserUI
                            ? Theme.of(context).brightness == Brightness.dark
                                ? (Theme.of(context).colorScheme.primary)
                                : Colors.white
                            : Colors.white,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(interactionAction)
                    ],
                  ),
                ),
                onTap: () {
                  final userAuth =
                      Provider.of<AuthProvider>(context, listen: false);
                  String currentUserId = userAuth.user!.id;
                  if (isLikedByUserUI) {
                    widget._postsService.unlikePost(
                        widget.collection, widget.post.id, currentUserId);

                    setState(() {
                      isLikedByUserUI = false;
                      interactionsCount -= 1;
                    });
                  } else {
                    print("will like");
                    //TODO: notification
                    widget._postsService.likePost(
                        widget.collection, widget.post.id, currentUserId);
                    setState(() {
                      isLikedByUserUI = true;
                      interactionsCount += 1;
                    });
                  }
                },
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
        if (showResolveOption && userOwnsPost)
          const SizedBox(
            height: 10,
          ),
        if (showResolveOption && userOwnsPost)
          Row(
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
                        FaIcon(
                          FontAwesomeIcons.check,
                          size: 17,
                          color: isResolvedUI ? Colors.green : Colors.white,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(displayedResolveOption)
                      ],
                    ),
                  ),
                  onTap: () {
                    if (isResolvedUI) {
                      widget._postsService.changeResolveStatusPost(
                          widget.collection, widget.post.id, false);

                      setState(() {
                        isResolvedUI = false;
                      });
                    } else {
                      widget._postsService.changeResolveStatusPost(
                          widget.collection, widget.post.id, true);
                      setState(() {
                        isResolvedUI = true;
                      });
                    }
                  },
                ),
              ),
            ],
          )
      ],
    );
  }

  void showCommentsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Comments(
          postId: widget.post.id,
          commentsDisplayedName:
              collectionToComment[widget.collection] ?? "Comments",
          collectionName: "comments_${widget.collection}",
        );
      },
    );
  }
}
