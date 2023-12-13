import 'package:flutter/material.dart';
import '../../models/category.dart';
import './category.dart';

class Categories extends StatelessWidget {
  final List<Category> categories;
  final bool asFilter;
  const Categories(
      {super.key, required this.categories, required this.asFilter});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: categories
            .map((category) => CategoryElement(
                index: categories.indexOf(category),
                category: category,
                asFilter: asFilter))
            .toList(),
      ),
    );
  }
}
