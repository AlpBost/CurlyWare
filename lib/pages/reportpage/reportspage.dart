import 'package:flutter/material.dart';
import 'package:jjj/main.dart';
import 'package:jjj/pages/mainpage/projecttypes.dart';


class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {

  int completedProjectCounter = 0;
  int ongoingProjectCounter = 0;

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/login"); //DÜZELT
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectBox(
      BuildContext context, String title, Color color, int numberOfProjects) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(39),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 19,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _dailyTaskOverview() {
    return Container(
      height: 200,
      width: 300,  // Genişlik ekledim
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 19,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "Task Overview",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Wrap(
              spacing: 20.0,
              runSpacing: 20.0,
              children: [
                _buildProjectBox(context, "Ongoing " + completedProjectCounter.toString(), Colors.blueGrey[800]!, completedProjectCounter),
                _buildProjectBox(context, "In Process " + ongoingProjectCounter.toString(), Colors.grey[900]!, ongoingProjectCounter),
              ],
            ),
            SizedBox(height: 20),
            _dailyTaskOverview(),
          ],
        ),
      ),
    );
  }
}

