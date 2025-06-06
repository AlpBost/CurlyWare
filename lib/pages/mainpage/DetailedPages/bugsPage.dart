import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jjj/pages/mainpage/DetailedPages/ProjectDetailPage.dart';
import 'package:jjj/pages/mainpage/ProjectsController.dart';

class BugsPage extends StatefulWidget {
  @override
  _BugsPage createState() => _BugsPage();
}

class _BugsPage extends State<BugsPage> {
  List<Project> projects = [];

  // This function gets all projects where type is "Bugs"
  Future<void> _fetchToDoTasksFromFirebase() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('projects')
        .where('projectType', isEqualTo: 'Bugs') // Get only bugs
        .get();

    print('Fetched ${snapshot.docs.length} tasks from Firestore');

    setState(() {
      // Create Project objects from the database data
      projects = snapshot.docs.map((doc) {
        return Project(
          projectName: doc['projectName'],
          projectType: doc['projectType'],
        );
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchToDoTasksFromFirebase(); // Load data when screen opens
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bug Projects"), // Title of the page
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: projects.length, // Number of projects
                itemBuilder: (context, index) {
                  final task = projects[index];

                  return GestureDetector(
                    onTap: () async {
                      // When user taps a project, open details dialog
                      final updatedState = await showDialog<String>(
                        context: context,
                        builder: (context) => DetailedProjectPage(
                          title: task.projectName ?? "",
                          previousState: task.projectType,
                        ),
                      );

                      // If user changed the projectType
                      if (updatedState != null && updatedState != task.projectType) {
                        // Update in Firebase
                        final snapshot = await FirebaseFirestore.instance
                            .collection('projects')
                            .where('projectName', isEqualTo: task.projectName)
                            .get();

                        for (var doc in snapshot.docs) {
                          await doc.reference.update({'projectType': updatedState});
                        }

                        // Refresh the list
                        await _fetchToDoTasksFromFirebase();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 16,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[300]!,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            // Show project index in circle
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            // Show project name
                            Expanded(
                              child: Text(
                                task.projectName ?? '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // Show project type (example: Bugs)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                task.projectType ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
