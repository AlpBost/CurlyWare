import 'dart:ffi';

import 'package:flutter/material.dart';

class Task {
  Int? id;
  String? taskName;
  List<String>? contributors;
  Task (this.id,this.taskName,this.contributors);
}

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  List<String> tasks = []; // Başlangıçta boş bir liste
  List<String> visibleTasks = []; // Arama yapılınca görüntülenecek task
  // bi tane daha list açtık çünkü üstte görüntüleyebilmek için tas kın listte sırasını
  // ddeğiştiriyoruz ama ana liste sırası değişmiyo

  void _addTask(String task) {
    setState(() {
      tasks.add(task);
      visibleTasks = List.from(tasks);
    });
  }
  void _deleteTask(String taskName) {

  }
  void _addContributor () {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                _addTask("New Task ${tasks.length + 1}");
              },
              child: Text("Add Task"),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: visibleTasks.map((task) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      width: double.infinity,  // Genişliği ekranın tamamına yayılacak şekilde ayarla
                      height: 80,              // Yüksekliği artırarak kutuları büyüt
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300]!,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        task,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          )

        ],
      ),
    );
  }
}
