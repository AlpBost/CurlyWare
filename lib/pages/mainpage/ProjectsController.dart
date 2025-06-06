import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'DetailedPages/ProjectDetailPage.dart';

class Project {
  String? projectName;
  String? projectType;
  String? description;
  String? assigned;

  Project({
    this.projectName,
    this.projectType,
    this.description,
    this.assigned,
  });
}

class ProjectController extends StatefulWidget {
  @override
  _ProjectControllerState createState() => _ProjectControllerState();
}

class _ProjectControllerState extends State<ProjectController> {
  List<Project> projects = [];

  // Add new project to Firebase
  Future<void> _addTask(Project project) async {
    await FirebaseFirestore.instance.collection('projects').add({
      'projectName': project.projectName,
      'projectType': project.projectType,
      'description': project.description,
      'assigned': project.assigned,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _fetchTasksFromFirebase(); // Refresh list after add
  }

  // Get all projects from Firebase ordered by date
  Future<void> _fetchTasksFromFirebase() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('projects')
        .orderBy('createdAt', descending: true)
        .get();

    setState(() {
      // Map documents to Project objects
      projects = snapshot.docs.map((doc) {
        return Project(
          projectName: doc['projectName'],
          projectType: doc['projectType'],
          description: doc['description'],
          assigned: doc['assigned'],
        );
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTasksFromFirebase(); // Load projects when start
  }

  // Show dialog to add a new project
  void _showAddTaskDialog() {
    Project newProject = Project();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Project Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Input for project name
                TextField(
                  decoration: InputDecoration(labelText: 'Project Name'),
                  onChanged: (value) {
                    newProject.projectName = value;
                  },
                ),
                SizedBox(height: 10),
                // Dropdown for project type
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Project Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['To Do', 'In Progress', 'Completed', 'Bugs']
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    newProject.projectType = value;
                  },
                ),
                SizedBox(height: 10),
                // Input for description
                TextField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    newProject.description = value;
                  },
                ),
                SizedBox(height: 10),
                // Input for assigned person
                TextField(
                  decoration: InputDecoration(labelText: 'Assigned To'),
                  onChanged: (value) {
                    newProject.assigned = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog without saving
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Check all fields have value before add
                if (newProject.projectName != null &&
                    newProject.projectType != null &&
                    newProject.description != null &&
                    newProject.assigned != null) {
                  await _addTask(newProject); // Add project to Firebase
                  Navigator.pop(context); // Close dialog
                }
              },
              child: Text('Add Project'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "-Recent Projects-",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: _showAddTaskDialog, // Show add project dialog
                  child: Text("Add Project"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final task = projects[index];

                return GestureDetector(
                  onTap: () async {
                    // Open project detail page dialog
                    final updatedState = await showDialog<String>(
                      context: context,
                      builder: (context) => DetailedProjectPage(
                        title: task.projectName ?? "",
                        previousState: task.projectType,
                      ),
                    );
                    if (updatedState != null) {
                      setState(() {
                        projects[index].projectType = updatedState; // Update project type
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              '${index + 1}', // Show number
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
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
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
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
        ],
      ),
    );
  }
}
