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
  String selectedType = "To Do";

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

  Future<Map<String, dynamic>> _getTaskCompletionRate(String projectName) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('projectTitle', isEqualTo: projectName)
        .get();

    if (snapshot.docs.isEmpty) {
      return {'rate': 0.0, 'total': 0, 'completed': 0};
    }

    final int totalTasks = snapshot.docs.length;
    final int completedTasks = snapshot.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['state'] == 'Done';
    }).length;

    final double completionRate = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return {
      'rate': completionRate,
      'total': totalTasks,
      'completed': completedTasks,
    };
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

  Future<void> _deleteProjectByProjectName(String projectName) async {
    // 1. projects koleksiyonundan projectName ile dokümanı bul ve sil
    final projectSnapshot = await FirebaseFirestore.instance
        .collection('projects')
        .where('projectName', isEqualTo: projectName)
        .get();

    for (var doc in projectSnapshot.docs) {
      await FirebaseFirestore.instance.collection('projects').doc(doc.id).delete();
    }

    // 2. tasks koleksiyonundaki ilgili görevleri sil
    final taskSnapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('projectTitle', isEqualTo: projectName)
        .get();

    for (var taskDoc in taskSnapshot.docs) {
      await FirebaseFirestore.instance.collection('tasks').doc(taskDoc.id).delete();
    }

    // 3. UI'yi güncelle
    await _fetchTasksFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProjects =
    projects.where((project) => project.projectType == selectedType).toList();

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
                  selectedColor: Colors.blue.shade400,
                  backgroundColor: Colors.grey.shade200,
                  showCheckmark: false,
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
                : ListView.builder(
              itemCount: filteredProjects.length,
              itemBuilder: (context, index) {
                final project = filteredProjects[index];
                return Dismissible(
                  key: Key(project.projectName ?? index.toString()),
                  direction: DismissDirection.endToStart, // Yatay silme işlevi için bu satırı güncelleyin
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Delete Project"),
                        content: const Text("Are you sure you want to delete this project?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Delete", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) async {
                    if (project.projectName != null) {
                      await _deleteProjectByProjectName(project.projectName!);
                    }
                  },
                  child: Padding(
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
                          child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(
                          project.projectName ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(project.description ?? ''),
                            const SizedBox(height: 5),
                            FutureBuilder<Map<String, dynamic>>(
                              future: _getTaskCompletionRate(project.projectName ?? ''),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox(height: 5);
                                }

                                final data = snapshot.data ?? {'rate': 0.0, 'total': 0, 'completed': 0};
                                final double completionRate = data['rate'];
                                final int totalTasks = data['total'];
                                final int completedTasks = data['completed'];

                                return Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: completionRate,
                                          backgroundColor: Colors.grey[300],
                                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                          minHeight: 8,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '$completedTasks/$totalTasks',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        trailing: Text(
                          project.assigned ?? '',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailedProjectPage(
                                title: project.projectName ?? 'Unnamed Project',
                                previousState: project.projectType,
                              ),
                            ),
                          );
                          await _fetchTasksFromFirebase();
                        },
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
