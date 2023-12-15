import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../managers/categories_manager.dart';

class ChipElement extends StatelessWidget {
  final String category;
  final categoriesMap = CategoryManager().categoriesMap;

  ChipElement({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    var categoryItem = categoriesMap[category] ?? categoriesMap["all"];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      margin: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          FaIcon(categoryItem?.icon ?? FontAwesomeIcons.house, size: 10),
          const SizedBox(width: 5),
          Text(
            categoryItem?.name ?? "Unknown $category",
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
