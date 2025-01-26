import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AdminHomePage.dart';

class TimesUpTasksPage extends StatefulWidget {
  final DateTime? deletedTime;
  const TimesUpTasksPage({super.key, this.deletedTime});

  @override
  _TimesUpTasksPageState createState() => _TimesUpTasksPageState();
}

class _TimesUpTasksPageState extends State<TimesUpTasksPage> {
  // final List<Map<String, dynamic>> timesUpTasks = [
  //   {"title": "Buy groceries"},
  //   {"title": "Schedule meeting with team"},
  //   {"title": "Prepare report for clients"},
  // ];

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

  final List timesUpTasks = [];

  void load() async {
    QuerySnapshot response =
        await FirebaseFirestore.instance.collection("TimesUpTasks").get();

    timesUpTasks.clear();
    for (var value in response.docs) {
      try {
        timesUpTasks.add({
          'taskID': value.id,
          'title': value['title'],
          'members': value['members'],
          'startTime': value['startTime'],
          'timesUpTime': value['timesUpTime'],
        });
      } catch (e) {
        log("Error processing document ${value.id}: $e");
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    load();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return const AdminHomePage();
                    }), (Route route) => false);
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
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "Time Up Tasks",
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          // Tasks List Section
          Flexible(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 248, 164, 164),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 13, right: 13),
                      child: timesUpTasks.isEmpty
                          ? Center(
                              child: Text(
                                "No Time Up Tasks are Available",
                                style: GoogleFonts.quicksand(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: timesUpTasks.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 8,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  shadowColor: Colors.black38,
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Colors.grey[100]!
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 6,
                                          offset: Offset(2, 2),
                                        ),
                                        BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 6,
                                          offset: Offset(-2, -2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          timesUpTasks[index]["title"],
                                          style: GoogleFonts.quicksand(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
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
                                          children: (timesUpTasks[index]
                                                          ['members'] ??
                                                      [])
                                                  .isNotEmpty
                                              ? (timesUpTasks[index]
                                                          ['members'] ??
                                                      [])
                                                  .map<Widget>((member) {
                                                  return Chip(
                                                    avatar: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.blue.shade100,
                                                      child: Text(
                                                        member[0].toUpperCase(),
                                                        style: const TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                    label: Text(
                                                      member,
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  );
                                                }).toList()
                                              : [
                                                  Text(
                                                    'No members assigned.',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Colors.red.shade600,
                                                    ),
                                                  ),
                                                ],
                                        ),
                                        const SizedBox(height: 6),
                                      ],
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
    );
  }
}
