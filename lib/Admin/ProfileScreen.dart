import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> employee = {
    "name": "Adrew Martin",
    "role": "Chef de projet Digital",
    "status": "Available",
    "avatar": "",
    "fix": "0112345644",
    "mobile": "0612345645",
    "email": "andre.martin@wsm.com",
    "address": "Immeuble les Miroirs - 18 avenue d'Alsace\n92400 Courbevoie",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(builder: (context) {
                      //   return const AdminHomePage();
                      // }), (Route route) => false);
                      Navigator.of(context).pop();
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
                    employee["name"],
                    style: GoogleFonts.quicksand(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Employee Details
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 225, 222, 222),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      // Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Colors.white, Color(0xFFEEEEEE)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(3, 3),
                              blurRadius: 6,
                            ),
                            const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-3, -3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          child: employee['avatar'] == ""
                              ? Icon(Icons.person,
                                  size: 50, color: Colors.grey[700])
                              : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Status
                      Text(
                        employee["status"],
                        style: GoogleFonts.quicksand(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Role
                      Text(
                        employee["role"],
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(Icons.call, Colors.green),
                          _buildActionButton(Icons.message, Colors.blue),
                          _buildActionButton(Icons.email, Colors.orange),
                          _buildActionButton(
                              Icons.linked_camera, Colors.indigo),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Divider
                      Divider(color: Colors.grey[300], thickness: 1),
                      const SizedBox(height: 16),
                      // Details
                      Expanded(
                        child: ListView(
                          children: [
                            _buildDetailRow("Fix", employee["fix"]),
                            _buildDetailRow("Mobile", employee["mobile"]),
                            _buildDetailRow("Email", employee["email"]),
                            _buildDetailRow("Address", employee["address"]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  }

  Widget _buildActionButton(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.white, color.withOpacity(0.2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 6,
            offset: Offset(-2, -2),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.transparent,
        child: Icon(icon, size: 28, color: color),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
