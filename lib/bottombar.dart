import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex; // Currently selected tab index
  final Function(int) onItemSelect; // Callback when a tab is selected

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onItemSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Fixed navigation bar type
      backgroundColor: const Color(0xFF0A0A23), // Background color
      showSelectedLabels: false, // Hide labels for selected items
      showUnselectedLabels: false, // Hide labels for unselected items
      selectedItemColor: Colors.cyan, // Color of selected icon
      unselectedItemColor: Colors.white70, // Color of unselected icons
      currentIndex: currentIndex, // Currently selected tab
      onTap: onItemSelect, // Called when a tab is tapped
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home), // Home icon
          label: "", // No label shown
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message), // Message icon
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart), // Analytics icon
          label: "",
        ),
      ],
    );
  }
}
