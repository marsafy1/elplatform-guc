import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/post.dart';
import '../components/managers/categories_manager.dart';
import '../components/posts/posts.dart';
import '../components/categories/category_icon.dart';
import '../components/categories/categories.dart';

import '../services/posts_service.dart';
import '../components/toast/toast.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final PostsService _postsService = PostsService();

  late List<Category> categories;
  List<Category> selectedCategories = [];

  late List<Category> categoriesChoices;
  List<Category> selectedCategoriesChoices = [];

  var categoriesMap = CategoryManager().categoriesMap;

  DateTime? latestPostTimestamp;
  bool hasNewPosts = false;

  @override
  void initState() {
    super.initState();
    categories = categoriesMap.entries.map((entry) {
      return Category(
        name: entry.value.name, // Use the name from the CategoryItem in the map
        icon: CategoryIcon(
            icon: entry.value.icon), // Use the icon from the CategoryItem
        addCategory: addCategory,
        removeCategory: removeCategory,
      );
    }).toList();

    categoriesChoices = categoriesMap.entries.map((entry) {
      return Category(
        name: entry.value.name, // Use the name from the CategoryItem in the map
        icon: CategoryIcon(
            icon: entry.value.icon), // Use the icon from the CategoryItem
        addCategory: addCategory,
        removeCategory: removeCategory,
      );
    }).toList();

    setState(() {
      categories[0].selected = true;
      categoriesChoices[0].selected = true;
    });
  }

  // void updateCategoriesAndReopenBottomSheet() {
  //   Navigator.pop(context); // Close the existing bottom sheet
  //   someFunctionThatUpdatesCategories(); // Update your categoriesChoices here
  //   showBottomSheetForNewPost(context); // Reopen the bottom sheet
  // }

  void addCategory(Category c, bool asFilter) {
    setState(() {
      if (asFilter) {
        if (c.name.toLowerCase() != "all") {
          selectedCategories.add(c);
          print('Added category: ${c.name}');
        }
        categories.forEach((element) {
          element.selected = false;
        });
        c.selected = true;
      } else {
        // Deselect all categories
        categoriesChoices.forEach((element) {
          element.selected = false;
        });

        // Select the chosen category
        c.selected = true;
        selectedCategoriesChoices = [c];
      }
    });

    categoriesChoices.forEach((element) {
      print(element.name + " " + element.selected.toString());
    });
  }

  void removeCategory(Category c, bool asFilter) {
    setState(() {
      print("remove category");
      if (asFilter) {
        selectedCategories.remove(c);
        print("checking if category is empty");
        if (selectedCategories.isEmpty) {
          print("empty");
          categories[0].selected = true;
          addCategory(categories[0], asFilter);
        }
      } else {
        selectedCategoriesChoices.remove(c);
      }
    });
  }

  final ScrollController _scrollController = ScrollController();
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
      stream: _postsService.getPosts(),
      builder: (context, AsyncSnapshot<List<Post>> snapshot) {
        if (snapshot.hasData) {
          DateTime? newestPostTimestamp = snapshot.data?.first.dateCreated;
          if (latestPostTimestamp == null) {
            latestPostTimestamp = newestPostTimestamp;
          } else if (newestPostTimestamp != null &&
              newestPostTimestamp.isAfter(latestPostTimestamp!)) {
            // New post received - Show toast
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Toast.show(context, "New posts available", "info", onTap: () {
                print("Toast tapped!");
                // Any additional action on tap
                scrollToTop();
              });
            });
            latestPostTimestamp = newestPostTimestamp;
          }
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        // Retrieve posts and filter them based on selected categories
        List<Post> allPosts = snapshot.data ?? [];
        List<Post> filteredPosts = selectedCategories.isEmpty
            ? allPosts
            : allPosts.where((post) {
                return selectedCategories.any((category) =>
                    post.category.toLowerCase() == category.name.toLowerCase());
              }).toList();

        return Column(
          children: [
            Categories(
                key: UniqueKey(), categories: categories, asFilter: true),
            Expanded(
              child: Posts(
                posts: filteredPosts,
                selectedCategories: selectedCategories,
                controller: _scrollController,
              ),
            ),
          ],
        );
      },
    );
  }
}
