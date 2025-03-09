import 'package:flutter/material.dart';
import 'package:jjj/bottombar.dart';
import 'package:jjj/pages/mainpage/mainpage.dart';
import 'tasks.dart';

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
            _buildProjectBox(context, "Ongoing", Colors.green[900]!, OngoingPage()),
            _buildProjectBox(context, "In Process", Colors.grey[700]!, InProcessPage()),
            _buildProjectBox(context, "Complet", Colors.blueGrey[700]!, CompletPage()),
            _buildProjectBox(context, "Bugs", Colors.purple[900]!, BugsPage()),
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
              Navigator.pushReplacementNamed(context, "/login"); // Giriş sayfasına yönlendirme
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
            _buildProjectBox(context, "Ongoing", Colors.purple[300]!, OngoingPage()),
            _buildProjectBox(context, "In Process", Colors.green[400]!, InProcessPage()),
            _buildProjectBox(context, "Complet", Colors.orange[300]!, CompletPage()),
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
              Navigator.pushReplacementNamed(context, "/login"); // Giriş sayfasına yönlendirme
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
class OngoingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proje "),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              ProjectTypesPage()._logout(context);
            },
          ),
        ],
      ),
      body: Center(child: Text("Proje 2 Detayları")),
    );
  }
}


class InProcessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proje 2"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              ProjectTypesPage()._logout(context);
            },
          ),
        ],
      ),
      body: Center(child: Text("Proje 2 Detayları")),
    );
  }
}

class CompletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proje 3"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              ProjectTypesPage()._logout(context);
            },
          ),
        ],
      ),
      body: Center(child: Text("Proje 3 Detayları")),
    );
  }
}

class BugsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proje 4"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              ProjectTypesPage()._logout(context);
            },
          ),
        ],
      ),
      body: Center(child: Text("Proje 4 Detayları")),
    );
  }
}
