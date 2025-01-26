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

  // // Calculate the remaining time and update the task timer
  // String getRemainingTime(int index, String taskID, String title, List members,
  //     String oldstartTime) {
  //   // final DateTime startTime = DateTime.parse(tasks[index]['startTime']);
  //   final DateTime startTime = tasks[index]['startTime'] != null
  //       ? DateTime.parse(tasks[index]['startTime'])
  //       : DateTime.now(); // Default to current time

  //   final DateTime endTime = startTime.add(Duration(
  //     days: tasks[index]['timerDays'],
  //     hours: tasks[index]['timerHours'],
  //     minutes: tasks[index]['timerMinutes'],
  //   ));

  //   final Duration remainingTime = endTime.difference(DateTime.now());

  //   if (remainingTime.isNegative) {
  //     // tasks.removeAt(index);
  //     load();
  //     _timesUpTask(taskID, title, members, oldstartTime);

  //     return "Time's up!";
  //   } else {
  //     final int remainingDays = remainingTime.inDays;
  //     final int remainingHours = remainingTime.inHours % 24;
  //     final int remainingMinutes = (remainingTime.inMinutes % 60) + 1;
  //     return "$remainingDays day${remainingDays > 1 ? 's' : ''}, $remainingHours hour${remainingHours > 1 ? 's' : ''}, $remainingMinutes min";
  //   }
  // }

  bool _isLoading = false;

  String getRemainingTime(int index, String taskID, String title, List members,
      String oldstartTime) {
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
      if (!_isLoading) {
        _isLoading = true; // Prevent further calls
        load();
        _timesUpTask(taskID, title, members, oldstartTime);
        _isLoading = false; // Reset the flag after execution
      }
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
    log("TimesUpTasks :- $ref");

    CollectionReference task =
        FirebaseFirestore.instance.collection('CurrentTasks');

    // Delete a specific document
    await task.doc(taskID).delete();
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
                              } else {
                                ToastService.showWarningToast(
                                  context,
                                  length: ToastLength.medium,
                                  expandedHeight: 100,
                                  message:
                                      "Please Enter Title or Select Members",
                                );
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
      children: [],
    );
  }
}
