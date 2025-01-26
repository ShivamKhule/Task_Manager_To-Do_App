import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import '../User/UserHomePage.dart';

class Demo_AdminHomePage extends StatefulWidget {
  @override
  _Demo_AdminHomePageState createState() => _Demo_AdminHomePageState();
}

class _Demo_AdminHomePageState extends State<Demo_AdminHomePage> {
  final List<Map<String, dynamic>> tasks = [
    {
      "title": "Buy groceries",
      "isCompleted": false,
      "members": ["John", "Jane"],
      "addedDate": DateTime.now().toString(),
      "startTime": DateTime.now().toString(), // Ensure startTime is set
      "timerDays": 0,
      "timerHours": 1,
      "timerMinutes": 0
    }

    // Add more tasks here...
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
                        "Picked  Date: ${selectedStartTime?.toLocal().toString().split(' ')[0]}",
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
                      fontSize: 16,
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
    int selectedDays = 0;
    int selectedHours = 1; // Default timer set to 1 hour
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
                    Text(
                      "Assign to Members",
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                      "Set Timer",
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton<int>(
                          value: selectedDays,
                          onChanged: (value) {
                            setDialogState(() {
                              selectedDays = value!;
                            });
                          },
                          items: List.generate(30, (index) {
                            return DropdownMenuItem<int>(
                              value: index,
                              child: Text('$index day${index > 1 ? 's' : ''}'),
                            );
                          }),
                        ),
                        const Text(':'),
                        DropdownButton<int>(
                          value: selectedHours,
                          onChanged: (value) {
                            setDialogState(() {
                              selectedHours = value!;
                            });
                          },
                          items: List.generate(24, (index) {
                            return DropdownMenuItem<int>(
                              value: index,
                              child: Text('$index hour${index > 1 ? 's' : ''}'),
                            );
                          }),
                        ),
                        const Text(':'),
                        DropdownButton<int>(
                          value: selectedMinutes,
                          onChanged: (value) {
                            setDialogState(() {
                              selectedMinutes = value!;
                            });
                          },
                          items: List.generate(60, (index) {
                            return DropdownMenuItem<int>(
                              value: index,
                              child: Text('$index min'),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
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
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade900,
      // drawer: DrawerWidget(showTaskHistory: _showTaskHistory),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              const SizedBox(width: 12),
              Container(
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
                child: const Icon(Icons.menu),
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
                      center: Alignment(
                          -0.3, -0.3), // Light source offset for a 3D effect
                      radius: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  RichText(
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
              const SizedBox(height: 15),
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.amber.shade200,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
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
                  Flexible(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        final addedDate = task["addedDate"] != null
                      ? DateTime.parse(task["addedDate"])
                      : DateTime.now();
                        final remainingTime = getRemainingTime(index);

                        // Format the time, date, and day
                        final time = formatTime(addedDate);
                        final date = formatDate(addedDate);
                        final day = getDayOfWeek(addedDate);

                        // Start the countdown when the task is added
                        startCountdown(index);

                        return Card(
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
                                fontSize: 18,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Assigned to: ${task['members'].join(', ')}',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Added: $time | $date | $day',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Remaining Time: $remainingTime',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: remainingTime == "Time's up!"
                                        ? Colors.red
                                        : Colors.grey,
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      /*bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 11),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(30),
        ),
        child: GNav(
          haptic: true, // Haptic feedback
          tabBorderRadius: 20,
          curve: Curves.fastOutSlowIn, // Smooth tab animation curve
          duration: const Duration(
              milliseconds:
                  100), // Reduced animation duration for responsiveness
          gap: 10,
          iconSize: 28, // Slightly larger icon size
          tabBackgroundGradient: LinearGradient(
            colors: [
              Colors.purple.withOpacity(0.1),
              Colors.purple.withOpacity(0.2)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ), // Gradient background for active tab
          padding: const EdgeInsets.symmetric(
              horizontal: 24, vertical: 10), // Adjusted padding for larger tabs
          tabs: [
            GButton(
              icon: LineIcons.home,
              text: 'Home',
              backgroundGradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.2),
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
                  Colors.green.withOpacity(0.2),
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
                  Colors.red.withOpacity(0.2),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
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



/*GestureDetector(
                onTap: () async {
                  log("Create Task Button Pressed");
                  await _showAddTaskDialog();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 14),
                  padding:
                      const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 107, 209, 115),
                        Color.fromARGB(255, 126, 194, 111)
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
                  // child: const Icon(Icons.menu),
                  child: Column(
                    children: [
                      Text(
                        "Create",
                        style: GoogleFonts.quicksand(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Task",
                        style: GoogleFonts.quicksand(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/