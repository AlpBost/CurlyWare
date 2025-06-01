import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../auth/auth_service.dart';

class DetailedProjectPage extends StatefulWidget {
  final String title;
  final String? previousState;

  DetailedProjectPage({required this.title, this.previousState});

  @override
  _DetailedProjectPageState createState() => _DetailedProjectPageState();
}

class _DetailedProjectPageState extends State<DetailedProjectPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _assignedController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  String? _selectedState;
  String? _username;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    User? user = _authService.getCurrentUser();
    _username = user?.email ?? 'Anonim';
  }

  Future<void> _addComment(String comment, String username) async {
    if (comment.trim().isEmpty || username.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment cannot be null.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('comments').add({
        'projectTitle': widget.title,
        'comment': comment,
        'username': username,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _commentController.clear();
    } catch (e) {
      print('Error adding comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error while sending comment.')),
      );
    }
  }

  void _showAllCommentsPopup(
      BuildContext context,
      List<QueryDocumentSnapshot> docs,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('All Comments'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final timestamp = data['timestamp'] as Timestamp?;
                final formattedTime = timestamp != null
                    ? DateTime.fromMillisecondsSinceEpoch(
                    timestamp.millisecondsSinceEpoch)
                    .toLocal()
                    .toString()
                    .substring(0, 16)
                    : 'Unknown time';

                return ListTile(
                  title: Text(data['username'] ?? 'No user'),
                  subtitle: Text('${data['comment'] ?? ''}\n$formattedTime'),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addTask(String task) async {
    if (task.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task cannot be empty.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('tasks').add({
        'projectTitle': widget.title,
        'task': task,
        'createdAt': FieldValue.serverTimestamp(),
        'assignedTo': _assignedController.text,
      });

      _taskController.clear();
    } catch (e) {
      print('Error adding task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error while adding task.')),
      );
    }
  }

  Future<void> _updateProjectState() async {
    if (_selectedState == null && widget.previousState != null) {
      _selectedState = widget.previousState;
    }

    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .where('projectName', isEqualTo: widget.title)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.update({'projectState': _selectedState});
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project updated successfully.')),
      );
      Navigator.of(context).pop(_selectedState);
    } catch (e) {
      print('Error updating project state: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating project state.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedState,
              hint: Text('Set State'),
              items: ['To Do', 'In Progress', 'Completed', 'Bugs']
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedState = value;
                });
              },
            ),
            Divider(height: 30),
            Text('Your Name: $_username',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Add Comment'),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  await _addComment(_commentController.text, _username!);
                },
              ),
            ),
            TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Add Task'),
            ),
            IconButton(
              icon: Icon(Icons.add_task),
              onPressed: () async {
                await _addTask(_taskController.text);
              },
            ),
            SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('comments')
                  .where('projectTitle', isEqualTo: widget.title)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  return Text("No comments have been made.");

                var docs = snapshot.data!.docs;

                docs.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;
                  final aTimestamp = aData['timestamp'] as Timestamp?;
                  final bTimestamp = bData['timestamp'] as Timestamp?;

                  if (aTimestamp == null && bTimestamp == null) return 0;
                  if (aTimestamp == null) return 1;
                  if (bTimestamp == null) return -1;

                  return bTimestamp.compareTo(aTimestamp);
                });

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...docs.take(3).map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final timestamp = data['timestamp'] as Timestamp?;
                      final formattedTime = timestamp != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                          timestamp.millisecondsSinceEpoch)
                          .toLocal()
                          .toString()
                          .substring(0, 16)
                          : 'Unknown time';

                      return Column(
                        children: [
                          ListTile(
                            title: Text(data['username'] ?? 'No user'),
                            subtitle:
                            Text('${data['comment'] ?? ''}\n$formattedTime'),
                          ),
                          Divider(),
                        ],
                      );
                    }).toList(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          _showAllCommentsPopup(context, docs);
                        },
                        child: Text('See All Comments'),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 30),
            Text('Tasks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .where('projectTitle', isEqualTo: widget.title)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  return Text("No tasks have been added.");

                var taskDocs = snapshot.data!.docs;

                return Column(
                  children: taskDocs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final timestamp = data['createdAt'] as Timestamp?;
                    final formattedTime = timestamp != null
                        ? DateTime.fromMillisecondsSinceEpoch(
                        timestamp.millisecondsSinceEpoch)
                        .toLocal()
                        .toString()
                        .substring(0, 16)
                        : 'Unknown time';

                    return Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.task_alt),
                          title: Text(data['task'] ?? 'Unnamed Task'),
                          subtitle: Text(
                              'Assigned to: ${data['assignedTo'] ?? 'N/A'}\n$formattedTime'),
                        ),
                        Divider(),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          _updateProjectState();
        },
        child: Text('Save'),
      ),
    );
  }
}
