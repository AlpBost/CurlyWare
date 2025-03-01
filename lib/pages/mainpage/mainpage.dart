import 'package:flutter/material.dart';
import 'package:jjj/bottombar.dart';



class MainPageButtons extends StatefulWidget {

  @override
  _MainpageButtonsState createState() => _MainpageButtonsState();
}

class _MainpageButtonsState extends State<MainPageButtons> {
  int _selectedButtonIndex = 0;

  static final List<Widget> _pages = <Widget>[
    Center(child: Text("Home Page", style: TextStyle(fontSize: 18))),
    Center(child: Text("Messages", style: TextStyle(fontSize: 18))),
    Center(child: Text("Projects", style: TextStyle(fontSize: 18))),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _pages[_selectedButtonIndex],
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedButtonIndex,
        onItemSelect: onItemSelect,
      ),
    );
  }
}
