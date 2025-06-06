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
    _username = user?.email?.split('@').first ?? 'Anonim';
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
                  title: Text(data['username'].toString().split('@').first ?? 'No user'),
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


  void _showAddTaskBottomSheet(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String? selectedState = 'To Do';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Task',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
                value: selectedState,
                items: ['To Do', 'In Progress', 'Done', 'Bugs']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  selectedState = value;
                },
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    if (nameController.text.trim().isNotEmpty) {
                      await _addTask(
                        nameController.text,
                        description: descriptionController.text,
                        state: selectedState,
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Task name cannot be empty')),
                      );
                    }
                  },
                  child: Text('Add Task', style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
  
  void _showMessagesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Project Messages',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('comments')
                        .where('projectTitle', isEqualTo: widget.title)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                        return Center(child: Text("No messages yet. Start a conversation!"));

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

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: docs.length,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          final timestamp = data['timestamp'] as Timestamp?;
                          final formattedTime = timestamp != null
                              ? DateTime.fromMillisecondsSinceEpoch(
                                  timestamp.millisecondsSinceEpoch)
                                  .toLocal()
                                  .toString()
                                  .substring(0, 16)
                              : 'Unknown time';
                          
                          final isCurrentUser = data['username'] == _username;
                          
                          return Align(
                            alignment: isCurrentUser 
                                ? Alignment.centerRight 
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isCurrentUser 
                                    ? Colors.blue.shade100 
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['username'].toString().split('@').first ?? 'No user',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(data['comment'] ?? ''),
                                  SizedBox(height: 4),
                                  Text(
                                    formattedTime,
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: IconButton(
                          icon: Icon(Icons.send, color: Colors.white),
                          onPressed: () async {
                            if (_commentController.text.trim().isNotEmpty) {
                              await _addComment(_commentController.text, _username!);
                              _commentController.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addTask(String task, {String? description, String? state}) async {
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
        'description': description ?? '',
        'state': state ?? 'To Do',
        'createdAt': FieldValue.serverTimestamp(),
        'assignedTo': _assignedController.text,
      });

      setState(() {

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
          doc.reference.update({'projectType': _selectedState});
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
  
  void _showConfirmStateChangeDialog(String? newState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm State Change'),
          content: Text('Are you sure you want to change the state of the project?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _selectedState = newState;
                });
                Navigator.pop(context);
                await _updateProjectState();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Color _getStateColor(String state) {
    switch (state) {
      case 'To Do':
        return Colors.blue;
      case 'In Progress':
        return Colors.orange;
      case 'Done':
        return Colors.green;
      case 'Bugs':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showUpdateTaskStateDialog(String taskId, String currentState) {
    String? selectedState = currentState;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Task State'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Current State: $currentState'),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'New State',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedState,
                  items: ['To Do', 'In Progress', 'Done', 'Bugs']
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    selectedState = value;
                  },
                ),
              ],
            ),
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
                if (selectedState != null && selectedState != currentState) {
                  bool success = await _updateTaskState(taskId, selectedState!);
                  if (success) {

                    Navigator.of(context).pop();
                  }
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _updateTaskState(String taskId, String newState) async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update({'state': newState});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task state updated successfully.')),
      );

      return true;
    } catch (e) {
      print('Error updating task state: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating task state.')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              _showMessagesBottomSheet(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Project State', 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedState,
                      hint: Text('Set Project State'),
                      items: ['To Do', 'In Progress', 'Completed', 'Bugs']
                          .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                          .toList(),
                      onChanged: (value) {
                        if (value != _selectedState) {
                          _showConfirmStateChangeDialog(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddTaskBottomSheet(context);
                  },
                  icon: Icon(Icons.add),
                  label: Text('New Task',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 300,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .where('projectTitle', isEqualTo: widget.title)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                    return Center(child: Text("No tasks have been added."));

                  var taskDocs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: (() {
                      taskDocs.sort((a, b) {
                        final aData = a.data() as Map<String, dynamic>;
                        final bData = b.data() as Map<String, dynamic>;
                        final aTimestamp = aData['createdAt'] as Timestamp?;
                        final bTimestamp = bData['createdAt'] as Timestamp?;

                        if (aTimestamp == null && bTimestamp == null) return 0;
                        if (aTimestamp == null) return 1;
                        if (bTimestamp == null) return -1;

                        return bTimestamp.compareTo(aTimestamp);
                      });
                      return taskDocs.length;
                    })(),
                    itemBuilder: (context, index) {
                      final doc = taskDocs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final timestamp = data['createdAt'] as Timestamp?;
                      final formattedTime = timestamp != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                          timestamp.millisecondsSinceEpoch)
                          .toLocal()
                          .toString()
                          .substring(0, 16)
                          : 'Unknown time';

                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${taskDocs.length - index}', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                            ],
                          ),
                          title: Text(data['task'] ?? 'Unnamed Task'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['description'] ?? ''),
                              Text(formattedTime),
                            ],
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStateColor(data['state'] ?? 'To Do'),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              data['state'] ?? 'To Do',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                          isThreeLine: true,
                          onTap: () => _showUpdateTaskStateDialog(doc.id, data['state'] ?? 'To Do'),
                      ));

                    },
                  );

                },
              ),
            ),

          ],
        ),
      ),
    );
  }


}
