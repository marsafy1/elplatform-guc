import 'package:flutter/material.dart';
import 'dart:ui';

class GlassMorphicBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final List<BottomNavigationBarItem> listItems;
  final double blurStrength;

  const GlassMorphicBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.listItems,
    this.blurStrength = 10.0, // Default blur strength
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    var isDarkTheme = brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16)), // Rounded corners
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkTheme
                ? const Color.fromARGB(255, 9, 5, 5).withOpacity(0.3)
                : const Color.fromARGB(255, 9, 5, 5)
                    .withOpacity(0.3), // Semi-transparent container
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent, // Transparent background color
            items: listItems,
            currentIndex: selectedIndex,
            onTap: (index) => onItemSelected(index),
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            showSelectedLabels:
                false, // Do not show label for the selected item
            showUnselectedLabels:
                false, // Do not show label for the unselected items
          ),
        ),
      ),
    );
  }
}
