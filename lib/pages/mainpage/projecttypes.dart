import 'package:flutter/material.dart';
import 'package:jjj/bottombar.dart';
import 'package:jjj/pages/LoginAndRegister/loginpage.dart';
import 'package:jjj/pages/mainpage/mainpagebuttons.dart';
import '../../bugsPage.dart';
import '../../completedPage.dart';
import '../../inProgressPage.dart';
import '../../toDoPage.dart';
import 'ProjectsController.dart';

class ProjectTypes extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
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
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          childAspectRatio: 1.5,
          children: [
            _buildProjectBox(context, "To Do", Colors.green[900]!, ToDoPage()),
            _buildProjectBox(context, "In Progress", Colors.red[800]!, InProgressPage()),
            _buildProjectBox(context, "Completed", Colors.blue[900]!, CompletedPage()),
            _buildProjectBox(context, "Bugs", Colors.purple[700]!, BugsPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectBox(BuildContext context, String title, Color color, Widget page) {
    return GestureDetector( //to push  project types
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(39),
          boxShadow: [
            BoxShadow(color: Colors.black38, blurRadius: 19, offset: Offset(0, 4)),
          ],
        ),

        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
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
}

class ProjectTypesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          childAspectRatio: 1.5,
          children: [
            _buildProjectBox(context, "Ongoing", Colors.purple[300]!, ToDoPage()),
            _buildProjectBox(context, "In Process", Colors.green[400]!, InProgressPage()),
            _buildProjectBox(context, "Complet", Colors.orange[300]!, CompletedPage()),
            _buildProjectBox(context, "Bugs", Colors.blue[300]!, BugsPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectBox(BuildContext context, String title, Color color, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(39),
          boxShadow: [
            BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

