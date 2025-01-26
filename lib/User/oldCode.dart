 import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  // Active tasks list
  List<Map<String, dynamic>> tasks = [
    {"title": "Buy groceries", "isCompleted": false, "members": ["John", "Jane"]},
    {"title": "Complete Flutter project", "isCompleted": false, "members": ["Alice"]},
  ];

  // Completed tasks history
  List<Map<String, dynamic>> completedTasksHistory = [];

  // Deleted tasks history
  List<Map<String, dynamic>> deletedTasksHistory = [];

  // List of members to whom tasks can be assigned
  final List<String> members = ["John", "Jane", "Alice", "Bob", "Charlie"];

  // This method will add a new task to the list
  void _addNewTask(String taskTitle, List<String> selectedMembers) {
    setState(() {
      tasks.add({"title": taskTitle, "isCompleted": false, "members": selectedMembers});
    });
  }

  // This method will toggle task completion and move it to completed tasks history if completed
  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index]['isCompleted'] = !tasks[index]['isCompleted'];
      if (tasks[index]['isCompleted']) {
        completedTasksHistory.add(tasks[index]); // Move to completed history
        tasks.removeAt(index); // Remove from active tasks
      }
    });
  }

  // This method will remove a task and move it to deleted tasks history
  void _deleteTask(int index) {
    setState(() {
      deletedTasksHistory.add(tasks[index]); // Move to deleted history before deleting
      tasks.removeAt(index);
    });
  }

  // This method will restore a task from deleted tasks history back to active tasks
  void _restoreTask(int index) {
    setState(() {
      Map<String, dynamic> restoredTask = deletedTasksHistory[index];
      restoredTask['isCompleted'] = false; // Mark the task as incomplete
      tasks.add(restoredTask); // Add the task back to the active tasks list
      deletedTasksHistory.removeAt(index); // Remove it from the deleted history
    });
  }

  // This method will restore a task from completed tasks history back to active tasks
  void _restoreCompletedTask(int index) {
    setState(() {
      Map<String, dynamic> restoredTask = completedTasksHistory[index];
      restoredTask['isCompleted'] = false; // Mark the task as incomplete
      tasks.add(restoredTask); // Add the task back to the active tasks list
      completedTasksHistory.removeAt(index); // Remove it from the completed history
    });
  }

  // Task Input Dialog (for adding new tasks with member selection)
  Future<void> _showAddTaskDialog() async {
    TextEditingController taskController = TextEditingController();
    List<String> selectedMembers = [];

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Dismiss dialog on tapping outside
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: taskController,
                      decoration: const InputDecoration(hintText: "Enter task title"),
                    ),
                    const SizedBox(height: 20),
                    const Text("Assign to members:"),
                    ...members.map((member) {
                      return CheckboxListTile(
                        title: Text(member),
                        value: selectedMembers.contains(member),
                        onChanged: (bool? value) {
                          setDialogState(() {
                            if (value == true) {
                              selectedMembers.add(member);
                            } else {
                              selectedMembers.remove(member);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    if (taskController.text.isNotEmpty && selectedMembers.isNotEmpty) {
                      _addNewTask(taskController.text, selectedMembers);
                    }
                    Navigator.of(context).pop(); // Dismiss the dialog after adding
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Method to display task history
  void _showTaskHistory(String type) {
    if (type == 'completed') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TaskHistoryPage(
            taskHistory: completedTasksHistory,
            onRestoreTask: _restoreCompletedTask,
          )),
      );
    } else if (type == 'deleted') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TaskHistoryPage(
            taskHistory: deletedTasksHistory,
            onRestoreTask: _restoreTask,
          )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do Application'),
      ),
      drawer: MediaQuery.of(context).size.width < 600
          ? DrawerWidget(showTaskHistory: _showTaskHistory)
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              children: [
                Expanded(flex: 2, child: TaskListView(tasks: tasks, onTaskToggle: _toggleTaskCompletion, onDeleteTask: _deleteTask)),
                Expanded(flex: 3, child: TaskDetailView())
              ],
            );
          } else {
            return TaskListView(tasks: tasks, onTaskToggle: _toggleTaskCompletion, onDeleteTask: _deleteTask);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog, // Show dialog to add new task
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskListView extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final Function(int) onTaskToggle;
  final Function(int) onDeleteTask;

  const TaskListView({required this.tasks, required this.onTaskToggle, required this.onDeleteTask});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          child: ListTile(
            title: Text(
              tasks[index]['title'],
              style: TextStyle(
                decoration: tasks[index]['isCompleted']
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text("Assigned to: ${tasks[index]['members'].join(', ')}"), // Show assigned members
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  onChanged: (bool? value) {
                    onTaskToggle(index); // Toggle task completion state
                  },
                  value: tasks[index]['isCompleted'],
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    onDeleteTask(index); // Delete the task
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TaskDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Select a task to view details',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  final Function(String) showTaskHistory;

  const DrawerWidget({required this.showTaskHistory});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('All Tasks'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Completed Tasks'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              showTaskHistory('completed'); // Open completed tasks history page
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Deleted Tasks'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              showTaskHistory('deleted'); // Open deleted tasks history page
            },
          ),
        ],
      ),
    );
  }
}

// Task history page to display completed or deleted tasks
class TaskHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> taskHistory;
  final Function(int) onRestoreTask;

  const TaskHistoryPage({
    required this.taskHistory,
    required this.onRestoreTask,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task History'),
      ),
      body: taskHistory.isEmpty
          ? const Center(child: Text('No tasks available.'))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: taskHistory.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(taskHistory[index]['title']),
                    subtitle: Text("Assigned to: ${taskHistory[index]['members'].join(', ')}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.restore, color: Colors.blue),
                      onPressed: () {
                        onRestoreTask(index); // Restore the task
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
