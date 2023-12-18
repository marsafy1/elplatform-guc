import 'package:flutter/material.dart';
import '../../models/category.dart';
import './category.dart';

class Categories extends StatelessWidget {
  final List<Category> categories;
  final bool asFilter;
  final VoidCallback? updateSheet; // Optional callback function

  const Categories({
    super.key,
    required this.categories,
    required this.asFilter,
    this.updateSheet, // Add it here as an optional parameter
  });

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
                  asFilter: asFilter,
                  updateSheet: updateSheet, // Pass it to each CategoryElement
                ))
            .toList(),
      ),
    );
  }
}
