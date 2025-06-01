import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jjj/main.dart';
import 'package:jjj/pages/mainpage/ProjectsController.dart';
import 'package:jjj/pages/LoginAndRegister/loginpage.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<Project> projects = [];

  int totalTaskCount = 0;
  int todoTaskCount = 0;
  int inprogressTaskCount = 0;
  int doneTaskCount = 0;
  int bugsTaskCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchTasksFromFirebase();
  }

  Future<void> _fetchTasksFromFirebase() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('projects')
        .orderBy('createdAt', descending: true)
        .get();

    print('Fetched ${snapshot.docs.length} tasks from Firestore');

    List<Project> fetchedProjects = snapshot.docs.map((doc) {
      return Project(
        projectName: doc['projectName'],
        projectType: doc['projectType'],
      );
    }).toList();

    for (var project in fetchedProjects) {
      switch (project.projectType) {
        case 'To Do':
          todoTaskCount++;
          break;
        case 'In Progress':
          inprogressTaskCount++;
          break;
        case 'Completed':
          doneTaskCount++;
          break;
        case 'Bugs':
          bugsTaskCount++;
          break;
      }
    }

    setState(() {
      projects = fetchedProjects;
      totalTaskCount = fetchedProjects.length;
    });
  }

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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
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
      height: 80,
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
              "$numberOfProjects Projects",
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
    double todoPercentage =
    totalTaskCount == 0 ? 0 : (todoTaskCount / totalTaskCount) * 100;
    double inprogressPercentage =
    totalTaskCount == 0 ? 0 : (inprogressTaskCount / totalTaskCount) * 100;
    double donePercentage =
    totalTaskCount == 0 ? 0 : (doneTaskCount / totalTaskCount) * 100;
    double bugsPercentage =
    totalTaskCount == 0 ? 0 : (bugsTaskCount / totalTaskCount) * 100;

    return Container(
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
            "Projects Overview",
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          _buildProjectProgress("To Do", todoPercentage.toInt(), Colors.blue[900]!),
          SizedBox(height: 10),
          _buildProjectProgress("In Process", inprogressPercentage.toInt(), Colors.red[800]!),
          SizedBox(height: 10),
          _buildProjectProgress("Completed", donePercentage.toInt(), Colors.blue[900]!),
          SizedBox(height: 10),
          _buildProjectProgress("Bugs", bugsPercentage.toInt(), Colors.purple[700]!),
        ],
      ),
    );
  }

  //Projects Overview (To Do , In Process , Completed , Bugs)
  Widget _buildProjectProgress(String title, int percentage, Color color) {
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
        LinearProgressIndicator(
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
        title: Text("Analytics & Reports"),
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
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  _buildProjectBox(context, "To Do", Colors.blue[600]!, todoTaskCount),
                  _buildProjectBox(context, "In Progress", Colors.blue[300]!, inprogressTaskCount),
                  _buildProjectBox(context, "Completed", Colors.blue[900]!, doneTaskCount),
                  _buildProjectBox(context, "Bugs", Colors.blue, bugsTaskCount),
                ],
              ),
              SizedBox(height: 30),
              _dailyTaskOverview(),
            ],
          ),
        ),
      ),
    );
  }
}
