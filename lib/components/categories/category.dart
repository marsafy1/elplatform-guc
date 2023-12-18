import 'package:flutter/material.dart';
import '../../models/category.dart';

class CategoryElement extends StatefulWidget {
  final int index;
  final Category category;
  final bool asFilter;
  final VoidCallback? updateSheet; // Optional callback function

  const CategoryElement(
      {super.key,
      required this.index,
      required this.category,
      required this.asFilter,
      this.updateSheet});

  @override
  State<CategoryElement> createState() => _CategoryElementState();
}

class _CategoryElementState extends State<CategoryElement> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          // Use gradient instead of a solid color
          gradient: widget.category.selected
              ? LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                    // You can add more colors to create a more complex gradient
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null, // No gradient when not selected
          color: widget.category.selected
              ? null // Set to null because gradient is used
              : Theme.of(context)
                  .secondaryHeaderColor, // Use solid color when not selected
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            widget.category.icon,
            const SizedBox(width: 5),
            Text(widget.category.name),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          widget.category.selected = true;
          widget.category.addCategory(widget.category, widget.asFilter);
          if (widget.updateSheet != null) {
            widget.updateSheet!();
          }
        });
      },
    );
  }
}
