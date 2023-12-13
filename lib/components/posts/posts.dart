import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../models/post.dart';
import './post.dart';

class Posts extends StatelessWidget {
  final List<Category> selectedCategories;
  final List<Post> posts;
  final ScrollController controller;

  const Posts(
      {super.key,
      required this.posts,
      required this.selectedCategories,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.vertical,
      child: Column(
        children: posts.map((post) {
          return PostWidget(
            post: post,
          );
        }).toList(),
      ),
    );
  }
}
