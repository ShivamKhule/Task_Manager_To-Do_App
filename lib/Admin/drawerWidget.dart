import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AdminHomePage.dart';
import 'StaffList.dart';
import 'TimesUpTasks.dart';

class DrawerWidget extends StatelessWidget {
  // final Function(String) showTaskHistory;

  const DrawerWidget({super.key});

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
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              email,
              style: GoogleFonts.quicksand(
                fontSize: 14,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
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
                /*_buildMenuItem(
                  icon: Icons.task,
                  text: 'All Tasks',
                  color: Colors.teal,
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                        return const AdminHomePage();
                      }),
                      (route) => false,
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.delete,
                  text: 'Deleted Tasks',
                  color: Colors.red,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return DeletedTasksPage();
                      }),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.groups,
                  text: 'Staff List',
                  color: Colors.deepPurple,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return StaffListScreen();
                      }),
                    );
                  },
                ),*/
                _buildMenuItem(
                  icon: Icons.delete_sweep_rounded,
                  text: 'Deleted Tasks',
                  color: Colors.redAccent,
                  onTap: () {
                    // Navigator.of(context).pop();
                  },
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  text: 'Settings',
                  color: Colors.blue,
                  onTap: () {
                    // Navigator.of(context).pop();
                  },
                ),
                _buildMenuItem(
                  icon: Icons.logout,
                  text: 'Logout',
                  color: Colors.brown,
                  onTap: () {
                    // Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
// Settings and Logout Section
          /*Column(
            children: [
              const Divider(),
              _buildMenuItem(
                icon: Icons.settings,
                text: 'Settings',
                color: Colors.blue,
                onTap: () {
                  // Navigator.of(context).pop();
                },
              ),
              _buildMenuItem(
                icon: Icons.logout,
                text: 'Logout',
                color: Colors.red,
                onTap: () {
                  // Navigator.of(context).pop();
                },
              ),
            ],
          ),*/
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
        style: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
    );
  }
}
