import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guc_swiss_knife/services/route_observer_service.dart';
import '../models/post.dart';
import '../components/posts/posts.dart';

import '../services/posts_service.dart';
import '../components/toast/toast.dart';
import '../components/utils/no_content.dart';

class ConfessionsPage extends StatefulWidget {
  const ConfessionsPage({super.key});

  @override
  State<ConfessionsPage> createState() => _ConfessionsPageState();
}

class _ConfessionsPageState extends State<ConfessionsPage> {
  final PostsService _postsService = PostsService();

  DateTime? latestPostTimestamp;
  bool hasNewPosts = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    RouteObserverService().logUserActivity('/confessions');
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Important to dispose the controller
    super.dispose();
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _postsService.getPosts('confessions'),
      builder: (context, AsyncSnapshot<List<Post>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            DateTime? newestPostTimestamp = snapshot.data?.first.dateCreated;
            if (latestPostTimestamp == null) {
              latestPostTimestamp = newestPostTimestamp;
            } else if (newestPostTimestamp != null &&
                newestPostTimestamp.isAfter(latestPostTimestamp!)) {
              // New post received - Show toast
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                Toast.show(context, "New posts available", "info", onTap: () {
                  // Any additional action on tap
                  scrollToTop();
                }, icon: FontAwesomeIcons.arrowUp);
              });
              latestPostTimestamp = newestPostTimestamp;
            }
          }
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Retrieve posts and filter them based on selected categories
        List<Post> allPosts = snapshot.data ?? [];
        if (snapshot.data!.isNotEmpty) {
          return Column(
            children: [
              Expanded(
                child: Posts(
                  posts: allPosts,
                  selectedCategories: const [],
                  controller: _scrollController,
                  collection: "confessions",
                ),
              ),
            ],
          );
        } else {
          return const NoContent(text: "No Confessions Available");
        }
      },
    );
  }
}
