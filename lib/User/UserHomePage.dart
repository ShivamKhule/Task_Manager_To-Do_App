import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import '../User/UserHomePage.dart';
import 'package:dept_to_do_app/Admin/taskHistory.dart';

class UserHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<UserHomePage> {
  final List<Map<String, dynamic>> tasks = [
    {
      "title": "Buy groceries",
      "isCompleted": false,
      "members": ["John", "Jane"],
      "addedDate": DateTime.now().toString(),
      "startTime": DateTime.now().toString(),
      "timerDays": 0,
      "timerHours": 0,
      "timerMinutes": 15
    },
    {
      "title": "Complete Flutter project",
      "isCompleted": false,
      "members": ["Alice", "Bob"],
      "addedDate": DateTime.now().toString(),
      "startTime": DateTime.now().toString(),
      "timerDays": 0,
      "timerHours": 3,
      "timerMinutes": 30
    },
    {
      "title": "Schedule meeting with team",
      "isCompleted": false,
      "members": ["Sarah", "David"],
      "addedDate": DateTime.now().toString(),
      "startTime": DateTime.now().toString(),
      "timerDays": 0,
      "timerHours": 0,
      "timerMinutes": 45
    },
    {
      "title": "Prepare report for clients",
      "isCompleted": false,
      "members": ["John"],
      "addedDate": DateTime.now().toString(),
      "startTime": DateTime.now().toString(),
      "timerDays": 0,
      "timerHours": 0,
      "timerMinutes": 10
    },
    {
      "title": "Attend conference",
      "isCompleted": false,
      "members": ["Alice", "Sarah"],
      "addedDate": DateTime.now().toString(),
      "startTime": DateTime.now().toString(),
      "timerDays": 1,
      "timerHours": 0,
      "timerMinutes": 0
    },
    {
      "title": "Go for a run",
      "isCompleted": false,
      "members": ["David"],
      "addedDate": DateTime.now().toString(),
      "startTime": DateTime.now().toString(),
      "timerDays": 0,
      "timerHours": 0,
      "timerMinutes": 5
    },
    {
      "title": "Write blog post",
      "isCompleted": false,
      "members": ["John", "Sarah"],
      "addedDate": DateTime.now().toString(),
      "startTime": DateTime.now().toString(),
      "timerDays": 0,
      "timerHours": 1,
      "timerMinutes": 15
    },
    {
      "title": "Fix bug in app",
      "isCompleted": false,
      "members": ["Alice", "David"],
      "addedDate": DateTime.now().toString(),
      "startTime": DateTime.now().toString(),
      "timerDays": 0,
      "timerHours": 0,
      "timerMinutes": 20
    },
    {
      "title": "Clean the house",
      "isCompleted": false,
      "members": ["John"],
      "addedDate": DateTime.now().toString(),
      "startTime": DateTime.now().toString(),
      "timerDays": 0,
      "timerHours": 1,
      "timerMinutes": 30
    }
  ];

  List<Map<String, dynamic>> completedTasksHistory = [];
  List<Map<String, dynamic>> deletedTasksHistory = [];

  final List<String> members = [
    "John",
    "Mike",
    "Alice",
    "Anna",
    "Charlie",
    "Charis",
    "Taylor",
    "Sarah",
    "David",
    "Emily",
    "Jana"
  ];

  void _addNewTask(String title, List<String> members, Duration timerDuration) {
    final DateTime startTime = DateTime.now();
    final task = {
      'title': title,
      'members': members,
      'isCompleted': false,
      'timerDays': timerDuration.inDays,
      'timerHours': timerDuration.inHours % 24,
      'timerMinutes': timerDuration.inMinutes % 60,
      'startTime': startTime.toIso8601String(),
    };

    tasks.add(task);
    setState(() {});
    _startTaskTimer(task);
  }

  void _startTaskTimer(Map<String, dynamic> task) {
    final DateTime startTime = DateTime.parse(task['startTime']);
    final Duration totalDuration = Duration(
      days: task['timerDays'],
      hours: task['timerHours'],
      minutes: task['timerMinutes'],
    );

    Timer.periodic(const Duration(seconds: 1), (timer) {
      final remainingTime =
          totalDuration - DateTime.now().difference(startTime);

      if (remainingTime.isNegative) {
        // Timer has completed, move task to history
        setState(() {
          tasks.remove(task);
          completedTasksHistory.add(task);
        });
        timer.cancel();
      } else {
        // Update remaining time dynamically (optional for UI)
        setState(() {
          task['remainingDays'] = remainingTime.inDays;
          task['remainingHours'] = remainingTime.inHours % 24;
          task['remainingMinutes'] = remainingTime.inMinutes % 60;
        });
      }
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index]['isCompleted'] = !tasks[index]['isCompleted'];
      if (tasks[index]['isCompleted']) {
        completedTasksHistory.add(tasks[index]);
        tasks.removeAt(index);
      }
    });
  }

  void _deleteTask(int index) {
    setState(() {
      deletedTasksHistory.add(tasks[index]);
      tasks.removeAt(index);
    });
  }

  void _restoreTask(int index) {
    setState(() {
      Map<String, dynamic> restoredTask = deletedTasksHistory[index];
      restoredTask['isCompleted'] = false;
      tasks.add(restoredTask);
      deletedTasksHistory.removeAt(index);
    });
  }

  void _restoreCompletedTask(int index) {
    setState(() {
      Map<String, dynamic> restoredTask = completedTasksHistory[index];
      restoredTask['isCompleted'] = false;
      tasks.add(restoredTask);
      completedTasksHistory.removeAt(index);
    });
  }

  Future<void> _editTaskDialog(int taskIndex) async {
    TextEditingController taskController = TextEditingController(
      text: tasks[taskIndex]['title'],
    );
    List<String> selectedMembers =
        List<String>.from(tasks[taskIndex]['members']);
    TextEditingController timerDaysController = TextEditingController(
      text: tasks[taskIndex]['timerDays'].toString(),
    );
    TextEditingController timerHoursController = TextEditingController(
      text: tasks[taskIndex]['timerHours'].toString(),
    );
    TextEditingController timerMinutesController = TextEditingController(
      text: tasks[taskIndex]['timerMinutes'].toString(),
    );
    DateTime? selectedStartTime = tasks[taskIndex]['startTime'] != null
        ? DateTime.parse(tasks[taskIndex]['startTime'])
        : DateTime.now();

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Edit Task',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: taskController,
                      decoration: InputDecoration(
                        hintText: "Edit task title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Assign to members:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      children: members.map((member) {
                        final isSelected = selectedMembers.contains(member);
                        return ChoiceChip(
                          label: Text(member),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setDialogState(() {
                              if (selected) {
                                selectedMembers.add(member);
                              } else {
                                selectedMembers.remove(member);
                              }
                            });
                          },
                          selectedColor: Colors.blue.shade200,
                          backgroundColor: Colors.grey.shade200,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Set Timer:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: timerDaysController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Days",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: timerHoursController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Hours",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: timerMinutesController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Minutes",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Start Time:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? pickedTime = await showDatePicker(
                          context: context,
                          initialDate: selectedStartTime!,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedTime != null) {
                          setDialogState(() {
                            selectedStartTime = pickedTime;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Text(
                        "Picked Date: ${selectedStartTime?.toLocal().toString().split(' ')[0]}",
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      setState(() {
                        tasks[taskIndex]['title'] = taskController.text;
                        tasks[taskIndex]['members'] = selectedMembers;
                        tasks[taskIndex]['timerDays'] =
                            int.tryParse(timerDaysController.text) ?? 0;
                        tasks[taskIndex]['timerHours'] =
                            int.tryParse(timerHoursController.text) ?? 0;
                        tasks[taskIndex]['timerMinutes'] =
                            int.tryParse(timerMinutesController.text) ?? 0;
                        tasks[taskIndex]['startTime'] =
                            selectedStartTime?.toIso8601String();
                      });
                      Navigator.of(context).pop();
                    } else {
                      // Handle validation errors
                    }
                  },
                  child: Text(
                    'Save',
                    style: GoogleFonts.quicksand(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showAddTaskDialog() async {
    TextEditingController taskController = TextEditingController();
    List<String> selectedMembers = [];
    int selectedDays = 1;
    int selectedHours = 0; // Default timer set to 1 hour
    int selectedMinutes = 0;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Add New Task',
                      style: GoogleFonts.quicksand(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: taskController,
                      style: GoogleFonts.quicksand(),
                      decoration: InputDecoration(
                        labelText: "Task Title",
                        hintText: "Enter task title",
                        labelStyle: GoogleFonts.quicksand(color: Colors.blue),
                        hintStyle: GoogleFonts.quicksand(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: taskController,
                      style: GoogleFonts.quicksand(),
                      decoration: InputDecoration(
                        labelText: "Task Description",
                        hintText: "Enter task description",
                        labelStyle: GoogleFonts.quicksand(color: Colors.blue),
                        hintStyle: GoogleFonts.quicksand(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Assign to Members :-",
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 8,
                      children: members.map((member) {
                        final isSelected = selectedMembers.contains(member);
                        return ChoiceChip(
                          label: Text(member),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setDialogState(() {
                              if (selected) {
                                selectedMembers.add(member);
                              } else {
                                selectedMembers.remove(member);
                              }
                            });
                          },
                          selectedColor: Colors.green.shade200,
                          backgroundColor: Colors.grey.shade200,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Set Timer :-",
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Days Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blue.shade50,
                            border: Border.all(
                                color: Colors.blue.shade200, width: 1.5),
                          ),
                          child: DropdownButton<int>(
                            value: selectedDays,
                            onChanged: (value) {
                              setDialogState(() {
                                selectedDays = value!;
                              });
                            },
                            items: List.generate(32, (index) {
                              return DropdownMenuItem<int>(
                                value: index,
                                child: Text(
                                  '$index day${index > 1 ? 's' : ''}',
                                  style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontSize: 16),
                                ),
                              );
                            }),
                            underline: Container(),
                            style: TextStyle(
                                fontSize: 16, color: Colors.blue.shade700),
                            icon: Icon(Icons.calendar_today,
                                color: Colors.blue.shade700),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          ':',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Hours Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blue.shade50,
                            border: Border.all(
                                color: Colors.blue.shade200, width: 1.5),
                          ),
                          child: DropdownButton<int>(
                            value: selectedHours,
                            onChanged: (value) {
                              setDialogState(() {
                                selectedHours = value!;
                              });
                            },
                            items: List.generate(24, (index) {
                              return DropdownMenuItem<int>(
                                value: index,
                                child: Text(
                                  '$index hour${index > 1 ? 's' : ''}',
                                  style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontSize: 16),
                                ),
                              );
                            }),
                            underline: Container(),
                            style: TextStyle(
                                fontSize: 16, color: Colors.blue.shade700),
                            icon: Icon(Icons.access_time,
                                color: Colors.blue.shade700),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          ':',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Minutes Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blue.shade50,
                            border: Border.all(
                                color: Colors.blue.shade200, width: 1.5),
                          ),
                          child: DropdownButton<int>(
                            value: selectedMinutes,
                            onChanged: (value) {
                              setDialogState(() {
                                selectedMinutes = value!;
                              });
                            },
                            items: List.generate(60, (index) {
                              return DropdownMenuItem<int>(
                                value: index,
                                child: Text(
                                  '$index min',
                                  style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontSize: 16),
                                ),
                              );
                            }),
                            underline: Container(),
                            style: TextStyle(
                                fontSize: 16, color: Colors.blue.shade700),
                            icon:
                                Icon(Icons.timer, color: Colors.blue.shade700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 6),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 6),
                            ),
                            onPressed: () {
                              if (taskController.text.isNotEmpty &&
                                  selectedMembers.isNotEmpty) {
                                final taskTimer = Duration(
                                  days: selectedDays,
                                  hours: selectedHours,
                                  minutes: selectedMinutes,
                                );
                                _addNewTask(
                                  taskController.text,
                                  selectedMembers,
                                  taskTimer,
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "Add",
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showTaskInfoDialog(
      BuildContext context,
      Map<String, dynamic> task,
      DateTime addedDate,
      String remainingTime) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.all(15),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SingleChildScrollView(
                // Ensures content is scrollable to prevent overflow
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      "Task Info...",
                      style: GoogleFonts.quicksand(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      task['title'],
                      style: GoogleFonts.quicksand(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.grey.shade700),
                        const SizedBox(width: 10),
                        Text(
                          'Added Date: $addedDate',
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.timer, color: Colors.grey.shade700),
                        const SizedBox(width: 10),
                        Text(
                          'Time Left: $remainingTime',
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: remainingTime == "Time's up!"
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Task Details:',
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      task['details'] ?? "No additional details provided.",
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Assigned Members:',
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Displaying assigned members as chips
                    Wrap(
                      spacing: 10,
                      children: (task['members'] ?? []).isNotEmpty
                          ? (task['members'] ?? []).map<Widget>((member) {
                              return Chip(
                                avatar: CircleAvatar(
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text(
                                    member[0].toUpperCase(),
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ),
                                label: Text(
                                  member,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList()
                          : [
                              Text(
                                'No members assigned.',
                                style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red.shade600,
                                ),
                              ),
                            ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -10,
                right: -10,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTaskHistory(String type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskHistoryPage(
          taskHistory:
              type == 'completed' ? completedTasksHistory : deletedTasksHistory,
          onRestoreTask:
              type == 'completed' ? _restoreCompletedTask : _restoreTask,
        ),
      ),
    );
    setState(() {});
  }

  // Format time (e.g., 2:30 PM)
  String formatTime(DateTime date) {
    final DateFormat timeFormat = DateFormat('h:mm a');
    return timeFormat.format(date);
  }

  // Format date (e.g., 2024-12-28)
  String formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(date);
  }

  // Get the day of the week (e.g., Monday)
  String getDayOfWeek(DateTime date) {
    final DateFormat dayFormat = DateFormat('EEEE');
    return dayFormat.format(date);
  }

  // Calculate the remaining time and update the task timer
  String getRemainingTime(int index) {
    // final DateTime startTime = DateTime.parse(tasks[index]['startTime']);
    final DateTime startTime = tasks[index]['startTime'] != null
        ? DateTime.parse(tasks[index]['startTime'])
        : DateTime.now(); // Default to current time

    final DateTime endTime = startTime.add(Duration(
      days: tasks[index]['timerDays'],
      hours: tasks[index]['timerHours'],
      minutes: tasks[index]['timerMinutes'],
    ));

    final Duration remainingTime = endTime.difference(DateTime.now());

    if (remainingTime.isNegative) {
      return "Time's up!";
    } else {
      final int remainingDays = remainingTime.inDays;
      final int remainingHours = remainingTime.inHours % 24;
      final int remainingMinutes = remainingTime.inMinutes % 60;
      return "$remainingDays day${remainingDays > 1 ? 's' : ''}, $remainingHours hour${remainingHours > 1 ? 's' : ''}, $remainingMinutes min";
    }
  }

  // Update task timer every minute
  void startCountdown(int index) {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {});
      if (getRemainingTime(index) == "Time's up!") {
        timer.cancel(); // Stop the timer when the countdown reaches zero
      }
    });
  }

  String name = "Shivam";

  final currentTime = DateFormat('hh:mm a').format(DateTime.now());
  final currentDate = DateFormat('EEEE, dd MMM').format(DateTime.now());

  // MENU Button Contents
  bool _isDrawerOpen = false;
  void toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade900,
      // drawer: DrawerWidget(showTaskHistory: _showTaskHistory),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 40),
              Row(
                children: [
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      log("Menu Button Pressed");
                      toggleDrawer();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 9, horizontal: 5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.white,
                            Color.fromARGB(255, 196, 196, 196)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(3, 3),
                            blurRadius: 6,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-3, -3),
                            blurRadius: 6,
                          ),
                        ],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                          bottom: Radius.circular(16),
                        ),
                      ),
                      child: const Icon(Icons.menu),
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 28,
                    backgroundColor:
                        Colors.grey[300], // Background color for the 3D effect
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [Colors.white, Colors.grey],
                          center: Alignment(-0.3,
                              -0.3), // Light source offset for a 3D effect
                          radius: 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(4, 4),
                            blurRadius: 5,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-4, -4),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/SethGodin.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Hello ',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '$name!',
                                      style: GoogleFonts.quicksand(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              "Have a Nice Day !",
                              style: GoogleFonts.quicksand(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  // const SizedBox(width: 20), // Add spacing between the two columns
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "Current Login ",
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          currentTime,
                          style: GoogleFonts.quicksand(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        // const SizedBox(height: 5),
                        Text(
                          currentDate,
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 235, 193),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Current Tasks",
                        style: GoogleFonts.quicksand(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10, left: 7, right: 7),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: tasks.length,
                            padding: const EdgeInsets.only(bottom: 70),
                            itemBuilder: (context, index) {
                              // final task = tasks[index];
                              // final addedDate = task["addedDate"] != null
                              //     ? DateTime.parse(task["addedDate"])
                              //     : DateTime.now();
                              // final remainingTime = getRemainingTime(index);

                              // Sort the tasks by the 'addedDate' before rendering
                              tasks.sort((a, b) {
                                final dateA = DateTime.parse(a["addedDate"]);
                                final dateB = DateTime.parse(b["addedDate"]);
                                return dateA.compareTo(dateB); // Earliest first
                              });

                              final task = tasks[index];
                              final addedDate =
                                  DateTime.parse(task["addedDate"]);
                              final remainingTime = getRemainingTime(index);

                              // Format the time, date, and day
                              final time = formatTime(addedDate);
                              final date = formatDate(addedDate);
                              final day = getDayOfWeek(addedDate);

                              // Start the countdown when the task is added
                              startCountdown(index);

                              return GestureDetector(
                                onTap: () async {
                                  await _isDrawerOpen
                                      ? toggleDrawer()
                                      : _showTaskInfoDialog(context, task,
                                          addedDate, remainingTime);
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(
                                        left: 12, top: 6, bottom: 4, right: 2),
                                    title: Text(
                                      task['title'],
                                      style: GoogleFonts.quicksand(
                                        fontSize: 18.5,
                                        fontWeight: FontWeight.w600,
                                        decoration: task['isCompleted']
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        color: task['isCompleted']
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        Text(
                                          'Time Left: $remainingTime',
                                          style: GoogleFonts.quicksand(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                            color: remainingTime == "Time's up!"
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _editTaskDialog(index);
                                          },
                                          icon: const Icon(
                                            Icons.edit_note,
                                            color: Colors.green,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _deleteTask(index);
                                          },
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
                ),
              ),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right: _isDrawerOpen ? 0 : -320,
            top: 0,
            bottom: 0,
            child: DrawerWidget(
              showTaskHistory: _showTaskHistory,
            ),
            /*child: Container(
              width: 250,
              color: Colors.blue,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  ListTile(
                    leading: const Icon(Icons.home, color: Colors.white),
                    title: const Text('Home',
                        style: TextStyle(color: Colors.white)),
                    onTap: toggleDrawer,
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: const Text('Settings',
                        style: TextStyle(color: Colors.white)),
                    onTap: toggleDrawer,
                  ),
                ],
              ),
            ),*/
          ),
        ],
      ),
      /*bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 11),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(30),
          // color: const Color.fromARGB(255, 240, 235, 193),
        ),
        child: GNav(
          haptic: true, // Haptic feedback
          tabBorderRadius: 20,
          curve: Curves.fastOutSlowIn, // Smooth tab animation curve
          duration: const Duration(
              milliseconds:
                  100), // Reduced animation duration for responsiveness
          gap: 10,
          iconSize: 28,
          padding: const EdgeInsets.symmetric(
              horizontal: 24, vertical: 10), // Adjusted padding for larger tabs
          tabs: [
            GButton(
              icon: LineIcons.home,
              text: 'Home',
              backgroundGradient: LinearGradient(
                colors: [
                  // ignore: deprecated_member_use
                  Colors.blue.withOpacity(0.2),
                  // ignore: deprecated_member_use
                  Colors.blue.withOpacity(0.3)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              activeBorder: Border.all(color: Colors.blue, width: 1),
              iconActiveColor: Colors.blue,
              textStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600),
            ),
            GButton(
              icon: Icons.done_all,
              text: 'Completed',
              backgroundGradient: LinearGradient(
                colors: [
                  // ignore: deprecated_member_use
                  Colors.green.withOpacity(0.2),
                  // ignore: deprecated_member_use
                  Colors.green.withOpacity(0.3)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              activeBorder: Border.all(color: Colors.green, width: 1),
              iconActiveColor: Colors.green,
              textStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.w600),
            ),
            GButton(
              icon: Icons.timer_off_outlined,
              text: 'Timed Out',
              backgroundGradient: LinearGradient(
                colors: [
                  // ignore: deprecated_member_use
                  Colors.red.withOpacity(0.2),
                  // ignore: deprecated_member_use
                  Colors.red.withOpacity(0.3)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              activeBorder: Border.all(color: Colors.red, width: 1),
              iconActiveColor: Colors.red,
              textStyle: const TextStyle(
                  fontSize: 20, color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),*/
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _showAddTaskDialog,
      //   child: const Icon(Icons.add),
      // ),

      floatingActionButton: _isDrawerOpen
          ? const SizedBox()
          : SizedBox(
              width: 190,
              height: 50,
              child: FloatingActionButton.extended(
                onPressed: () {
                  _showAddTaskDialog();
                },
                label: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      size: 32,
                      color: Colors.black,
                      weight: 10,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Create Task ",
                      style: GoogleFonts.quicksand(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                backgroundColor: const Color.fromARGB(255, 157, 215, 85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 4,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class DrawerWidget extends StatelessWidget {
  final Function(String) showTaskHistory;

  const DrawerWidget({required this.showTaskHistory});

  final String fullName = "Shivam Khule";
  final email = 'shivamkhule@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header Section with Gradient and User Info
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.greenAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              fullName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              email,
              style: const TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              // child: Icon(
              //   Icons.person,
              //   size: 40,
              //   color: Colors.teal,
              // ),
              child: ClipOval(
                child: Image.asset(
                  "assets/images/SethGodin.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Menu Items Section
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  icon: Icons.task,
                  text: 'All Tasks',
                  color: Colors.teal,
                  onTap: () {
                    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                    //   return UserHomePage();
                    // }), (Route<dynamic> route => false));
                  },
                ),
                _buildMenuItem(
                  icon: Icons.check_circle,
                  text: 'Completed Tasks',
                  color: Colors.green,
                  onTap: () {
                    showTaskHistory('completed');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.timer_off,
                  text: 'Time Ended Tasks',
                  color: const Color.fromARGB(255, 122, 66, 195),
                  onTap: () {
                    showTaskHistory('timeleft');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.delete,
                  text: 'Deleted Tasks',
                  color: Colors.red,
                  onTap: () {
                    Navigator.of(context).pop();
                    showTaskHistory('deleted');
                  },
                ),
              ],
            ),
          ),
          // Settings and Logout Section
          Column(
            children: [
              const Divider(),
              _buildMenuItem(
                icon: Icons.settings,
                text: 'Settings',
                color: Colors.blue,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              _buildMenuItem(
                icon: Icons.logout,
                text: 'Logout',
                color: Colors.red,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          // Footer Section with App Version
          Container(
            color: Colors.teal.withOpacity(0.1),
            padding: const EdgeInsets.all(4),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'App version 1.0.0',
                  style: TextStyle(color: Colors.teal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build menu items
  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color),
      ),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
    );
  }

  // Helper function to build menu items
  // Widget _buildMenuItem({
  //   required IconData icon,
  //   required String text,
  //   required Color color,
  //   required VoidCallback onTap,
  // }) {
  //   return ListTile(
  //     leading: Icon(icon, color: color),
  //     title: Text(
  //       text,
  //       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  //     ),
  //     onTap: onTap,
  //     trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
  //   );
  // }
}

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
        // appBar: AppBar(
        //   title: const Text('Task History'),
        // ),
        body: Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                log("Back Button Pressed");
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                    return UserHomePage();
                  }),
                  (Route<dynamic> route) => false,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color.fromARGB(255, 196, 196, 196)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(3, 3),
                      blurRadius: 6,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-3, -3),
                      blurRadius: 6,
                    ),
                  ],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                    bottom: Radius.circular(16),
                  ),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
          ],
        ),
        taskHistory.isEmpty
            ? const Center(child: Text('No tasks available.'))
            : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: taskHistory.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text(taskHistory[index]['title']),
                      subtitle: Text(
                          "Assigned to: ${taskHistory[index]['members'].join(', ')}"),
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
      ],
    ));
  }
}


/*class TaskListView extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final Function(int) onTaskToggle;
  final Function(int) onDeleteTask;
  final Function(int) onEditTask;

  const TaskListView({
    required this.tasks,
    required this.onTaskToggle,
    required this.onDeleteTask,
    required this.onEditTask,
  });

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
              style: GoogleFonts.quicksand(
                decoration: tasks[index]['isCompleted']
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              "Assigned to: ${tasks[index]['members'].join(', ')}",
              style: GoogleFonts.quicksand(),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    onEditTask(index);
                  },
                  icon: const Icon(
                    Icons.edit_note,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    onDeleteTask(index);
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
*/

/*Future<void> _showAddTaskDialog() async {
    TextEditingController taskController = TextEditingController();
    List<String> selectedMembers = [];

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Add New Task',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: taskController,
                      decoration: InputDecoration(
                        hintText: "Enter task title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Assign to members:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      children: members.map((member) {
                        final isSelected = selectedMembers.contains(member);
                        return ChoiceChip(
                          label: Text(member),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setDialogState(() {
                              if (selected) {
                                selectedMembers.add(member);
                              } else {
                                selectedMembers.remove(member);
                              }
                            });
                          },
                          selectedColor: Colors.green.shade200,
                          backgroundColor: Colors.grey.shade200,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (taskController.text.isNotEmpty &&
                        selectedMembers.isNotEmpty) {
                      _addNewTask(taskController.text, selectedMembers);
                      Navigator.of(context).pop();
                    } else {
                      // Show validation message if task title or members are empty
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  */

/*
void openBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Create To-Do",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Title:",
                    style: TextStyle(
                      color: Color.fromRGBO(2, 167, 177, 1),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: "Title",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Description:",
                    style: TextStyle(
                      color: Color.fromRGBO(2, 167, 177, 1),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: "Description",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Date:",
                    style: TextStyle(
                      color: Color.fromRGBO(2, 167, 177, 1),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2025),
                        );
                        String formattedDate =
                            DateFormat.yMMMd().format(pickedDate!);
                        dateController.text = formattedDate;
                        setState(() {});
                      },
                      readOnly: true,
                      controller: dateController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.calendar_month_outlined,
                          color: Color.fromRGBO(2, 167, 177, 1),
                        ),
                        hintText: "Select date",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  if (titleController.text.trim().isNotEmpty &&
                      descriptionController.text.trim().isNotEmpty &&
                      dateController.text.trim().isNotEmpty) {
                    cardList.add(
                      Todomodel(title: titleController.text, description: descriptionController.text, date: dateController.text),
                    );
                  }
                  titleController.clear();
                  descriptionController.clear();
                  dateController.clear();
                  Navigator.pop(context);
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromRGBO(2, 167, 177, 1),
                  ),
                  child: const Text(
                    "Submit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        );
      },
    );
  }
*/


// DecoratedBox(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(
//                 "assets/images/bg4.avif",
//               ),
//               fit: BoxFit.cover,
//               opacity: 0.3,
//             ),
//           ),

