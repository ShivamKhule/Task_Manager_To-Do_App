import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AdminHomePage.dart';

class StaffListScreen extends StatefulWidget {
  @override
  _StaffListScreenState createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  final List<Map<String, dynamic>> employees = [
    {"name": "Bouilhou Pierre", "role": "UX Designer", "isFavorite": false},
    {"name": "Lhenry Jules", "role": "Front End", "isFavorite": false},
    {"name": "Mariam Yeu", "role": "Back End", "isFavorite": true},
    {"name": "Martin Patrick", "role": "Chef de project", "isFavorite": true},
    {"name": "Kane Mane", "role": "Graphiste", "isFavorite": false},
    {"name": "Jeni Roxy", "role": "Graphiste", "isFavorite": false},
    {"name": "Marry Jane", "role": "Graphiste", "isFavorite": false},
    {"name": "Oliver Twist", "role": "Mobile Developer", "isFavorite": true},
    {"name": "Sophia Brown", "role": "Product Manager", "isFavorite": false},
    {"name": "Liam Smith", "role": "Data Analyst", "isFavorite": false},
    {"name": "Bouilhou Pierre", "role": "UX Designer", "isFavorite": false},
    {"name": "Lhenry Jules", "role": "Front End", "isFavorite": false},
    {"name": "Mariam Yeu", "role": "Back End", "isFavorite": true},
    {"name": "Martin Patrick", "role": "Chef de project", "isFavorite": true},
    {"name": "Kane Mane", "role": "Graphiste", "isFavorite": false},
    {"name": "Jeni Roxy", "role": "Graphiste", "isFavorite": false},
    {"name": "Marry Jane", "role": "Graphiste", "isFavorite": false},
    {"name": "Oliver Twist", "role": "Mobile Developer", "isFavorite": true},
    {"name": "Sophia Brown", "role": "Product Manager", "isFavorite": false},
    {"name": "Liam Smith", "role": "Data Analyst", "isFavorite": false},
  ];

  late List<Map<String, dynamic>> filteredEmployees;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredEmployees = employees; // Initially show all employees
    searchController.addListener(() {
      filterEmployees();
    });
  }

  void filterEmployees() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredEmployees = employees.where((employee) {
        return employee['name'].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Back Button and Title
            Padding(
              padding: const EdgeInsets.only(
                  left: 12, bottom: 10, right: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) {
                            return const AdminHomePage();
                          }), (Route route) => false);
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
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(3, 3),
                                blurRadius: 6,
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                offset: Offset(-2, -2),
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
                        "Staff List",
                        style: GoogleFonts.quicksand(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.white,
                          Color.fromARGB(255, 199, 197, 197)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: "Search employee...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            // Employee List
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 171, 137, 230),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 18,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final employee = filteredEmployees[index];
                    return GestureDetector(
                      onTap: () {
                        // Handle employee card tap
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          gradient: employee['isFavorite']
                              ? const LinearGradient(
                                  colors: [Colors.amber, Colors.orangeAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Avatar with glow effect for favorites
                            Container(
                              decoration: employee['isFavorite']
                                  ? const BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.amberAccent,
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    )
                                  : null,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey.shade200,
                                child: const Icon(Icons.person,
                                    size: 35, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Employee Name
                            Text(
                              employee["name"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Employee Role
                            Text(
                              employee["role"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
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
    );
  }
}
