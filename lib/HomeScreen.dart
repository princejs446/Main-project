import 'package:flutter/material.dart';
import 'package:main_project/AppwriteService.dart';
import 'package:main_project/TaskScreen.dart';


class Homescreen extends StatefulWidget {
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  
  Future<void> fetchTasks() async {
    try {
      final response = await appwriteService.database.listDocuments(
         databaseId: '67525ff4002131301021',
        collectionId:'6752604000126c2f3359',
      );

      setState(() {
        tasks = response.documents
            .map((doc) => {
                  'id': doc.$id,
                  'title': doc.data['title'],
                  'description': doc.data['description'],
                  'date':doc.data['date'],
                  'time':doc.data['time']
                })
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch tasks: $e')),
      );
    }
  }

  
  void editTask(String taskId, String title, String description,String date,String time) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskScreen(
          taskId: taskId,
          initialTitle: title,
          initialDescription: description,
          initialDate:date,
          initalTime:time,
        ),
      ),
    );

    if (result != null) {
      fetchTasks(); 
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await appwriteService.database.deleteDocument(
  databaseId: '67525ff4002131301021', 
        collectionId:'6752604000126c2f3359', 
        documentId: taskId,
      );

      setState(() {
        tasks.removeWhere((task) => task['id'] == taskId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Echo Note',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 15.0, 
                mainAxisSpacing: 15.0, 
                childAspectRatio: 0.90, 
              ),
              padding: const EdgeInsets.all(10.0), 
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: Text(
                            task['description'],
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                      Row(
                         children: [
                                 Text(
                                      task['date'],
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                                const Spacer(), 
                                  Text(
                                    task['time'],
                                   style: const TextStyle(fontSize: 12, color: Colors.black54),
                                   ),
                                       ],
                                      ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => editTask(
                                task['id'],
                                task['title'],
                                task['description'],
                                task['date'],
                                task['time']
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteTask(task['id']),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToTaskScreen();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  
  void navigateToTaskScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskScreen()),
    );

    if (result != null) {
      fetchTasks(); 
    }
  }
}