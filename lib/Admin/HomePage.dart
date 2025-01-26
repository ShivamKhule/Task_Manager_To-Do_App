import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'ProfileScreen.dart';
import 'drawerWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> tasks = [];

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

// MENU Button Contents
  bool _isDrawerOpen = false;
  void toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  // Calculate the remaining time and update the task timer
  String getRemainingTime(int index, String taskID, String title, List members,
      String oldstartTime) {
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
      // tasks.removeAt(index);
      load();
      _timesUpTask(taskID, title, members, oldstartTime);

      return "Time's up!";
    } else {
      final int remainingDays = remainingTime.inDays;
      final int remainingHours = remainingTime.inHours % 24;
      final int remainingMinutes = (remainingTime.inMinutes % 60) + 1;
      return "$remainingDays day${remainingDays > 1 ? 's' : ''}, $remainingHours hour${remainingHours > 1 ? 's' : ''}, $remainingMinutes min";
    }
  }

  Future<void> _timesUpTask(
      String taskID, String title, List members, String startTime) async {
    final DateTime currentTime = DateTime.now();
    final timesUpTask = {
      'title': title,
      'members': members,
      'startTime': startTime,
      'timesUpTime': currentTime,
    };

    DocumentReference ref = await FirebaseFirestore.instance
        .collection("TimesUpTasks")
        .add(timesUpTask);

    log("$ref");

    CollectionReference task =
        FirebaseFirestore.instance.collection('CurrentTasks');

    // Delete a specific document
    await task.doc(taskID).delete();

    // tasks.removeAt(index);
    // setState(() {});
    // load();
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
                          'Added Date: ${formatDateTime(addedDate)}',
                          // 'Added Date: $addedDate',
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade900,
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

  String formatDateTime(DateTime dateTime) {
    final formattedDate = "${dateTime.year} "
        "${_getMonthName(dateTime.month)} "
        "${dateTime.day.toString().padLeft(2, '0')} "
        "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}:"
        "${dateTime.second.toString().padLeft(2, '0')}";
    return formattedDate;
  }

  String _getMonthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
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
    TextEditingController descriptionController = TextEditingController();
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
                    // const SizedBox(height: 20),
                    // TextField(
                    //   controller: descriptionController,
                    //   style: GoogleFonts.quicksand(),
                    //   decoration: InputDecoration(
                    //     labelText: "Task Description",
                    //     hintText: "Enter task description",
                    //     labelStyle: GoogleFonts.quicksand(color: Colors.blue),
                    //     hintStyle: GoogleFonts.quicksand(color: Colors.grey),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(15),
                    //       borderSide:
                    //           const BorderSide(color: Colors.blueAccent),
                    //     ),
                    //   ),
                    // ),
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
                            onPressed: () async {
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
                                setState(() {
                                  load();
                                });
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

  void _addNewTask(
      String title, List<String> members, Duration timerDuration) async {
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

    DocumentReference ref =
        await FirebaseFirestore.instance.collection("CurrentTasks").add(task);

    // DocumentReference adminRef = FirebaseFirestore.instance.collection("Admin").doc("CurrentTasks"); // Replace `adminId` with the actual document ID of the admin.
    // DocumentReference ref = await adminRef.collection("CurrentTasks").add(task);

    _startTaskTimer(task);
  }

  void load() async {
    QuerySnapshot response =
        await FirebaseFirestore.instance.collection("CurrentTasks").get();

    tasks.clear();
    for (var value in response.docs) {
      try {
        tasks.add({
          'taskID': value.id,
          'title': value['title'],
          'members': value['members'],
          'timerDays': value['timerDays'],
          'timerHours': value['timerHours'],
          'timerMinutes': value['timerMinutes'],
          'startTime': value['startTime'],
        });
      } catch (e) {
        log("Error processing document ${value.id}: $e");
      }
    }
    setState(() {});
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
          // completedTasksHistory.add(task);
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

  void _deleteTask(int index, String taskID, String title, List members,
      String startTime) async {
    CollectionReference task =
        FirebaseFirestore.instance.collection('CurrentTasks');

    // Delete a specific document
    await task.doc(taskID).delete();

    final DateTime deletedTime = DateTime.now();
    final deletedTask = {
      'title': title,
      'members': members,
      'startTime': startTime,
      'deletedTime': deletedTime
    };

    DocumentReference ref = await FirebaseFirestore.instance
        .collection("DeletedTasks")
        .add(deletedTask);

    // deletedTasksHistory.add(tasks[index]);
    tasks.removeAt(index);
    setState(() {
      log("${tasks[index]['title']}");
      log("${tasks[index]['members']}");
      log("${tasks[index]['taskID']}");
    });
  }

  List<Map<String, dynamic>> deletedTasksHistory = [];

  String name = "Shivam";

  final currentTime = DateFormat('hh:mm a').format(DateTime.now());
  final currentDate = DateFormat('EEEE, dd MMM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    load();
    log("$tasks");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    toggleDrawer();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 9, horizontal: 5),
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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return ProfileScreen();
                      }),
                    );
                  },
                  child: CircleAvatar(
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
                                      color: Colors.deepPurpleAccent,
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
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 7, right: 7),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            load(); // Call your data loading method
                            setState(
                                () {}); // Refresh the UI after reloading data
                          },
                          child: tasks.isEmpty
                              ? Center(
                                  child: SpinKitCubeGrid(
                                    color: Colors.deepPurple,
                                    size: 50.0,
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: tasks.length,
                                  padding: const EdgeInsets.only(bottom: 60),
                                  itemBuilder: (context, index) {
                                    final task = tasks[index];
                                    final addedDate = task["addedDate"] != null
                                        ? DateTime.parse(task["addedDate"])
                                        : DateTime.now();
                                    final remainingTime = getRemainingTime(
                                        index,
                                        task['taskID'],
                                        task['title'],
                                        task['members'],
                                        task['startTime']);

                                    return GestureDetector(
                                      onTap: () async {
                                        _isDrawerOpen
                                            ? toggleDrawer()
                                            : _showTaskInfoDialog(context, task,
                                                addedDate, remainingTime);
                                      },
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.only(
                                              left: 12,
                                              top: 6,
                                              bottom: 4,
                                              right: 2),
                                          title: Text(
                                            task['title'],
                                            style: GoogleFonts.quicksand(
                                              fontSize: 18.5,
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  (task['isCompleted'] ?? false)
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : TextDecoration.none,
                                              color:
                                                  (task['isCompleted'] ?? false)
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
                                                  color: remainingTime ==
                                                          "Time's up!"
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
                                                  _deleteTask(
                                                    index,
                                                    task['taskID'],
                                                    task['title'],
                                                    task['members'],
                                                    task['startTime'],
                                                  );
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
              // showTaskHistory: _showTaskHistory,
              ),
        ),
        Positioned(
          bottom: 10,
          // left: 108,
          left: 0,
          right: 0,
          child: _isDrawerOpen
              ? const SizedBox()
              : Container(
                  // width: 40,
                  height: 45,
                  margin: const EdgeInsets.symmetric(horizontal: 90),
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
        ),
      ],
    );
  }
}
