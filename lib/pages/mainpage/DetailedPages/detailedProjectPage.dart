import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth importu
import 'package:flutter/material.dart';

import '../../../auth/auth_service.dart';



class DetailedProjectPage extends StatefulWidget {
  final String title;
  final String? previousState;



  DetailedProjectPage({required this.title,this.previousState});

  @override
  _DetailedProjectPageState createState() => _DetailedProjectPageState();
}

class _DetailedProjectPageState extends State<DetailedProjectPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _assignedController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String? _selectedState;
  String? _username;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Kullanıcıyı FirebaseAuth ile alıyoruz
    User? user = _authService.getCurrentUser();
    _username = user?.email ?? 'Anonim'; // Kullanıcı adı alınır

  }

  Future<void> _addComment(String comment, String username) async {

    if (comment.trim().isEmpty || username.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment Place cannot be null.')),
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
      print('Adding comment error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error while sending message.')),
      );
    }
  }
  // Save butonuna tıklanınca proje state'ini güncelleyen fonksiyon
  Future<void> _updateProjectState() async {
    if (_selectedState == null && widget.previousState != null) {
        _selectedState = widget.previousState;
    }

    try {
      // Proje durumunu Firestore'da güncelle
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
        SnackBar(content: Text('Project saved successfully.')),
      );
      Navigator.of(context).pop(_selectedState);// Dialogu kapat
    } catch (e) {
      print('Error updating project state: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating project state.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedState,
              hint: Text('Set State'),
              items: ['To Do', 'In Progress', 'Completed', 'Bugs']
                  .map((String value) => DropdownMenuItem(
                value: value,
                child: Text(value),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedState = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _assignedController,
              decoration: InputDecoration(labelText: 'Assigned'),
            ),
            Divider(height: 30),
            // Kullanıcı adını sadece Text olarak gösteriyoruz
            Text(
              'Your Name: $_username', // Kullanıcının adı burada gösterilir
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Add Comment'),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  await _addComment(
                    _commentController.text,
                    _username!,
                  );
                },
              ),
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

                // Yeni → eski sıralama
                docs.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;
                  final aTimestamp = aData['timestamp'] as Timestamp?;
                  final bTimestamp = bData['timestamp'] as Timestamp?;

                  if (aTimestamp == null && bTimestamp == null) return 0;
                  if (aTimestamp == null) return 1;
                  if (bTimestamp == null) return -1;

                  return bTimestamp.compareTo(aTimestamp); // yeni → eski
                });

                return Column(
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
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                          title: Text(data['username'] ?? 'No such user'),
                          subtitle: Text('${data['comment'] ?? ''}\n$formattedTime'),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Save butonuna basıldığında proje state'ini güncelle
            _updateProjectState();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
