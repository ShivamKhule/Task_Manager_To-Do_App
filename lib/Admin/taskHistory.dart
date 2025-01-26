import 'dart:developer';

import 'package:flutter/material.dart';

import 'AdminHomePage.dart';

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
                    return AdminHomePage();
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
