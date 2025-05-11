import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelect;

  const CustomBottomNavigationBar({Key? key, required this.currentIndex, required this.onItemSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF0A0A23),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.cyan,
      unselectedItemColor: Colors.white70,
      currentIndex: currentIndex,
      onTap: onItemSelect,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: "",
        ),
      ],
    );
  }
}
