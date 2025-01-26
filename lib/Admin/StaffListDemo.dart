import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeLookupScreen extends StatelessWidget {
  final List<Map<String, dynamic>> employees = [
    {"name": "Bouilhou Pierre", "role": "UX Designer", "avatar": "", "isFavorite": false},
    {"name": "Lhenry Jules", "role": "Front End", "avatar": "", "isFavorite": false},
    {"name": "Mariam Yeu", "role": "Back End", "avatar": "", "isFavorite": true},
    {"name": "Martin Patrick", "role": "Chef de project", "avatar": "", "isFavorite": true},
    {"name": "Kane Mane", "role": "Graphiste", "avatar": "", "isFavorite": false},
    {"name": "Jeni Roxy", "role": "Graphiste", "avatar": "", "isFavorite": false},
    {"name": "Marry Jane", "role": "Graphiste", "avatar": "", "isFavorite": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Employee Lookup",
                    style: GoogleFonts.quicksand(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.search, size: 28),
                ],
              ),
              const SizedBox(height: 16),
              // Employee Sections
              _buildSectionTitle("My Favorite"),
              _buildEmployeeGrid(employees.where((e) => e['isFavorite']).toList()),
              const SizedBox(height: 16),
              _buildSectionTitle("My Team"),
              _buildEmployeeGrid(employees.where((e) => !e['isFavorite']).toList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.quicksand(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmployeeGrid(List<Map<String, dynamic>> employees) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              child: employee['avatar'] == ""
                  ? Icon(Icons.person, size: 30, color: Colors.grey[700])
                  : null, // Placeholder for avatar
            ),
            const SizedBox(height: 4),
            Text(
              employee['name'].split(" ")[0],
              style: GoogleFonts.quicksand(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
