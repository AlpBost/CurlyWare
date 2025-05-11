import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jjj/detailedProjectPage.dart';

//Object for saving to db
class Project {
  String? projectName;
  String? projectType;

  Project({this.projectName, this.projectType});
}

class ProjectController extends StatefulWidget {
  @override
  _ProjectControllerState createState() => _ProjectControllerState();

}

class _ProjectControllerState extends State<ProjectController> {
  List<Project> projects = [];


  Future<void> _addTask(Project project) async {
    await FirebaseFirestore.instance.collection('projects').add({
      'projectName': project.projectName,
      'projectType': project.projectType,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _fetchTasksFromFirebase();
  }

  Future<void> _fetchTasksFromFirebase() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('projects')
            .orderBy('createdAt', descending: true)
            .get();

    print('Fetched ${snapshot.docs.length} tasks from Firestore');

    setState(() {
      projects =
          snapshot.docs.map((doc) {
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
    _fetchTasksFromFirebase();
  }

  void _showAddTaskDialog() {
    Project newTask = Project();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Project Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Project Name'),
                onChanged: (value) {
                  newTask.projectName = value;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Project Type',
                  border: OutlineInputBorder(),
                ),
                items:
                    ['To Do', 'In Progress', 'Completed', 'Bugs']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  newTask.projectType = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (newTask.projectName != null &&
                    newTask.projectType != null) {
                  await _addTask(newTask);
                  Navigator.pop(context);
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: _showAddTaskDialog,
              child: Text("Add Project"),
            ),
          ),

          Expanded(
            child: Center(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final task = projects[index];

                  return GestureDetector(
                    onTap: () async {
                      final updatedState =await
                      showDialog<String>(
                        context: context,
                        builder:
                            (context) => DetailedProjectPage(
                              title: task.projectName ?? "",
                              previousState: task.projectType,
                            ),
                      );
                      if (updatedState != null) {
                        setState(() {
                          projects[index].projectType = updatedState;
                        });
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
