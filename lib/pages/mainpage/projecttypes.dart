import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jjj/pages/mainpage/ProjectsController.dart';
import 'package:jjj/pages/mainpage/DetailedPages/ProjectDetailPage.dart';


class ProjectTypes extends StatefulWidget {
  const ProjectTypes({super.key});

  @override
  State<ProjectTypes> createState() => _ProjectTypesState();
}

class _ProjectTypesState extends State<ProjectTypes> {
  List<Project> projects = [];
  String selectedType = "To Do"; // Başlangıç tipi

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

    setState(() {
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

  Future<void> _addTask(Project project) async {
    await FirebaseFirestore.instance.collection('projects').add({
      'projectName': project.projectName,
      'projectType': project.projectType,
      'description': project.description,
      'assigned': project.assigned,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _fetchTasksFromFirebase();
  }

  void _showAddTaskDialog() {
    Project newProject = Project();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Project Details'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Project Name'),
                  onChanged: (value) {
                    newProject.projectName = value;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
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
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    newProject.description = value;
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(labelText: 'Assigned To'),
                  onChanged: (value) {
                    newProject.assigned = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (newProject.projectName != null &&
                    newProject.projectType != null &&
                    newProject.description != null &&
                    newProject.assigned != null) {
                  await _addTask(newProject);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Project'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProjects = projects
        .where((project) => project.projectType == selectedType)
        .toList();

    final categories = [
      {"label": "To Do", "icon": Icons.list_alt_rounded},
      {"label": "In Progress", "icon": Icons.timelapse_rounded},
      {"label": "Completed", "icon": Icons.check_circle_outline},
      {"label": "Bugs", "icon": Icons.bug_report_outlined},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Projects"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddTaskDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: categories.map((cat) {
              final isSelected = selectedType == cat["label"];
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.42,
                child: ChoiceChip(
                  labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        cat["icon"] as IconData,
                        size: 34,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          cat["label"].toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedType = cat["label"].toString();
                    });
                  },
                  selectedColor: Colors.blue.shade400, // Seçildiğinde farklı renk
                  backgroundColor: Colors.grey.shade200, // Seçilmemişken arka plan
                  showCheckmark: false, // Tik işaretini gizle
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredProjects.isEmpty
                ? const Center(child: Text("No projects found."))
                :ListView.builder(
              itemCount: filteredProjects.length,
              itemBuilder: (context, index) {
                final project = filteredProjects.isNotEmpty && filteredProjects[index] != null
                    ? filteredProjects[index]
                    : Project(); // Boş bir project nesnesi döndür

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        project.projectName ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(project.description ?? ''),
                      trailing: Text(
                        project.assigned ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailedProjectPage(
                              title: project.projectName ?? 'Unnamed Project',
                              previousState: project.projectType,
                            ),
                          ),
                        );
                      },

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
