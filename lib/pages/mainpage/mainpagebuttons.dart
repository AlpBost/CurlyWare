import 'package:flutter/material.dart';
import 'package:jjj/bottombar.dart';
import '../../chat/messagepage.dart';
import 'projecttypes.dart';
import 'ProjectsController.dart';
import 'package:jjj/pages/reportpage/reportspage.dart';

//It was created to call the methods and create pages to be created
// when the user select from bottombar.

class MainPageButtons extends StatefulWidget {

  @override
  _MainpageButtonsState createState() => _MainpageButtonsState();
}

class _MainpageButtonsState extends State<MainPageButtons> {
  int _selectedButtonIndex = 0;

  static final List<Widget> _pages = <Widget>[
    Column(
      children: [
        Expanded(child: ProjectTypes()),
        Expanded(child: ProjectController()),
      ],
    ),
    Center(child: MessagePage()),
    Column(
      children: [
        Expanded(child: ReportsPage()),
      ],
    ),
    Center(child: Text("Reports", style: TextStyle(fontSize: 18))),
  ];

  void onItemSelect(int index) {
    setState(() {
      _selectedButtonIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedButtonIndex],
        bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _selectedButtonIndex,
            onItemSelect: onItemSelect,
            ),
        );
    }
}