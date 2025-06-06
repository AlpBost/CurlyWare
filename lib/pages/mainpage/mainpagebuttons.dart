import 'package:flutter/material.dart';
import 'package:jjj/bottombar.dart';
import '../../pages/chat/messagepage.dart';
import 'projecttypes.dart';
import 'package:jjj/pages/reportpage/reportspage.dart';

// This class shows different pages when user clicks buttons on bottom bar
class MainPageButtons extends StatefulWidget {
  @override
  _MainpageButtonsState createState() => _MainpageButtonsState();
}

class _MainpageButtonsState extends State<MainPageButtons> {
  int _selectedButtonIndex = 0; // Current selected button index

  // List of pages to show for each button
  static final List<Widget> _pages = <Widget>[
    Column(
      children: [
        Expanded(child: ProjectTypes()), // Show project types page
      ],
    ),
    Center(child: MessagePage()), // Show chat message page
    Column(
      children: [
        Expanded(child: ReportsPage()), // Show reports page
      ],
    ),
    Center(child: Text("Reports", style: TextStyle(fontSize: 18))), // Simple text page
  ];

  // Change page when user taps a button
  void onItemSelect(int index) {
    setState(() {
      _selectedButtonIndex = index; // Update selected button index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedButtonIndex], // Show selected page
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedButtonIndex, // Highlight selected button
        onItemSelect: onItemSelect, // Function to change page
      ),
    );
  }
}
