import 'package:flutter/material.dart';
import 'package:jjj/bottombar.dart';
import '../../chat/messagepage.dart';
import 'projecttypes.dart';
import 'tasks.dart';
import 'package:jjj/pages/reportpage/reportspage.dart';



class MainPageButtons extends StatefulWidget {

  @override
  _MainpageButtonsState createState() => _MainpageButtonsState();
}

class _MainpageButtonsState extends State<MainPageButtons> {
  int _selectedButtonIndex = 0;

  static final List<Widget> _pages = <Widget>[
    Column(
      children: [
        Expanded(child: ProjectTypes()), // İlk bileşen
        Expanded(child: Tasks()), // İkinci bileşen
      ],
    ),
    Center(child: MessagePage()),
    Center(child: Text("Projects", style: TextStyle(fontSize: 18))),
    Column(
      children: [
        Expanded(child: ReportsPage()),
        //Expanded(child: ProjectBoxes()),
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