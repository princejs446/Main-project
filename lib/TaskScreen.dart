import 'package:flutter/material.dart';

import 'package:main_project/AppwriteService.dart';

class TaskScreen extends StatefulWidget {
  final String? taskId;
  final String? initialTitle;
  final String? initialDescription;
  final String? initialDate;
  final String? initalTime;

  TaskScreen({this.taskId,this.initialTitle, this.initialDescription,this.initialDate,this.initalTime});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final DateTime dateTime = DateTime.now();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    // Check if editing an existing task
    if (widget.taskId != null) {
      isEditing = true;
      titleController.text = widget.initialTitle ?? '';
      descriptionController.text = widget.initialDescription ?? '';
    }
  }

  // Save or Update Task
  Future<void> saveOrUpdateTask() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    final date ="${dateTime.day}-${dateTime.month}-${dateTime.year}";
    final time ="${dateTime.hour}.${dateTime.minute}";

    if (title.isEmpty || description.isEmpty && date.isNotEmpty && time.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      
      if (isEditing) {
      
        await appwriteService.database.updateDocument(
         databaseId: '67525ff4002131301021', // Replace with your database ID
        collectionId:'6752604000126c2f3359',
          documentId: widget.taskId!,
          data: {
            'title': title,
            'description': description,
            'date':date,
            'time':time,
          },
        );
      } else {
        // Create a new task
        await appwriteService.database.createDocument(
         databaseId: '67525ff4002131301021', // Replace with your database ID
        collectionId:'6752604000126c2f3359',
          documentId: 'unique()',
          data: {
            'title': title,
            'description': description,
            'date':date,
            'time':time,

          },
        );
      }

      // Return the result to refresh the Homescreen
      Navigator.pop(context, {'title': title, 'description': description,'date':date,'time':time});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to ${isEditing ? "update" : "save"} task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          isEditing ? 'Edit Task' : 'Add New Task',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: saveOrUpdateTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            Spacer(),
                        Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${DateTime.now().toLocal().toString().split(' ')[0]}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  TimeOfDay.now().format(context),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}