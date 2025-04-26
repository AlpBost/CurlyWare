import 'package:flutter/material.dart';
import 'package:jjj/main.dart';
import 'package:jjj/pages/mainpage/projecttypes.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {

  // bu bilgiler db den al
  int totalTaskCount = 15;
  int completedTaskCount = 8;
  int ongoingTaskCount = 6;
  int doneTaskCount = 1;

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
              Navigator.pushReplacementNamed(context, "/login");
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
      height: 100,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "$numberOfProjects Tasks",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dailyTaskOverview() {
    double completedPercentage = (completedTaskCount / totalTaskCount) * 100;
    double ongoingPercentage = (ongoingTaskCount / totalTaskCount) * 100;
    double donePercentage = (doneTaskCount / totalTaskCount) * 100;

    return Container(
      height: 300,
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Task Overview",
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          _buildTaskProgress("Completed", completedPercentage.toInt(), Colors.green),
          SizedBox(height: 10),
          _buildTaskProgress("Ongoing", ongoingPercentage.toInt(), Colors.blue),
          SizedBox(height: 10),
          _buildTaskProgress("Done", donePercentage.toInt(), Colors.red),
        ],
      ),
    );
  }

  Widget _buildTaskProgress(String title, int percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        LinearProgressIndicator( // internetten bakıldı
          value: percentage / 100,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        SizedBox(height: 5),
        Text(
          "$percentage%",
          style: TextStyle(
            color: color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: [
                  _buildProjectBox(context, "Completed", Colors.green, completedTaskCount),
                  _buildProjectBox(context, "Ongoing", Colors.blue, ongoingTaskCount),
                  _buildProjectBox(context, "Done", Colors.red, doneTaskCount),
                ],
              ),
              SizedBox(height: 20),
              _dailyTaskOverview(),
            ],
          ),
        ),
      ),
    );
  }
}
