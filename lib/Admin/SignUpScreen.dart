import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:toasty_box/toast_enums.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpScreen> {
  bool isAdmin = false; // Toggle between Admin and User SignUp
  bool isPasswordVisible = false; // Toggle password visibility
  bool isConfirmPasswordVisible = false; // Toggle confirm password visibility

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      // backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  "assets/images/list.png",
                  width: 90,
                  height: 90,
                ),
                const SizedBox(height: 5),
                // Logo or Welcome Text
                Text(
                  "Create Account",
                  style: GoogleFonts.quicksand(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                // Sign Up Type Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "User SignUp",
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: !isAdmin ? Colors.blue : Colors.black54,
                      ),
                    ),
                    Switch(
                      value: isAdmin,
                      onChanged: (value) {
                        setState(() {
                          isAdmin = value;
                        });
                      },
                    ),
                    Text(
                      "Admin SignUp",
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isAdmin ? Colors.blue : Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Sign Up Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.white, Color(0xFFEEEEEE)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                      const BoxShadow(
                        color: Colors.white,
                        blurRadius: 8,
                        offset: Offset(-4, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Email Field
                      _buildTextField(
                        controller: emailController,
                        label: isAdmin ? "Admin Email" : "User Email",
                        icon: Icons.email,
                        obscureText: false,
                      ),
                      const SizedBox(height: 16),
                      // Password Field with visibility toggle
                      _buildPasswordField(
                          "Password", isPasswordVisible, passwordController),
                      const SizedBox(height: 16),
                      // Confirm Password Field with visibility toggle
                      _buildPasswordField("Confirm Password",
                          isConfirmPasswordVisible, confirmPasswordController),
                      const SizedBox(height: 16),
                      // Sign Up Button
                      ElevatedButton(
                        onPressed: () async {
                          // Handle sign-up logic
                          if (emailController.text.trim().isNotEmpty &&
                              passwordController.text.trim().isNotEmpty &&
                              confirmPasswordController.text
                                  .trim()
                                  .isNotEmpty) {
                            try {
                              UserCredential userCredential =
                                  await _firebaseAuth
                                      .createUserWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                              final FirebaseFirestore _firestore =
                                  FirebaseFirestore.instance;
                              final currentTime =
                                  DateFormat('hh:mm a').format(DateTime.now());
                              final currentDate = DateFormat('EEEE, dd MMM')
                                  .format(DateTime.now());
                              try {
                                await _firestore
                                    .collection('userProfiles')
                                    .doc(emailController.text.trim())
                                    .set({
                                  'email': emailController.text.trim(),
                                  'password':
                                      confirmPasswordController.text.trim(),
                                  'loginTime': currentTime,
                                  'loginDate': currentDate,
                                  'isAdmin': isAdmin,                               
                                });
                              } on FirebaseException catch (error) {
                                ToastService.showWarningToast(
                                  context,
                                  length: ToastLength.medium,
                                  expandedHeight: 100,
                                  message: "${error.message}",
                                );
                              }
                              ToastService.showSuccessToast(
                                context,
                                length: ToastLength.medium,
                                expandedHeight: 100,
                                message:
                                    "Sign Up Successfull 🥂!\nPlease Proceed for Login",
                              );
                              Navigator.of(context).pop();
                            } on FirebaseAuthException catch (error) {
                              ToastService.showWarningToast(
                                context,
                                length: ToastLength.medium,
                                expandedHeight: 100,
                                message: "${error.message}",
                              );
                            }
                          } else {
                            ToastService.showWarningToast(
                              context,
                              length: ToastLength.medium,
                              expandedHeight: 100,
                              message: "Please fill all the Fields !",
                            );
                          }
                          setState(() {
                            emailController.clear();
                            passwordController.clear();
                            confirmPasswordController.clear();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.blue,
                          shadowColor: Colors.blue.withOpacity(0.3),
                          elevation: 5,
                        ),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.quicksand(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "OR",
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Google Sign-In Button
                      GestureDetector(
                        onTap: () {
                          // Handle Google Sign-In logic
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.white, Color(0xFFEEEEEE)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(4, 4),
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                blurRadius: 8,
                                offset: Offset(-4, -4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/svgs/google.svg"),
                              const SizedBox(width: 10),
                              Text(
                                "Sign up with Google",
                                style: GoogleFonts.quicksand(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: "Already have an Account? "),
                      TextSpan(
                        text: "Login",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green, // You can customize the color
                          decoration:
                              TextDecoration.underline, // Optional underline
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Add your SignUp tap action here
                            Navigator.pop(context);
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Footer
                Text(
                  "Powered by Shivam Khule",
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscureText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFEEEEEE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(3, 3),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.black54),
          hintText: label,
          hintStyle: GoogleFonts.quicksand(
            fontSize: 14,
            color: Colors.black38,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String label, bool isVisible, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFEEEEEE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(3, 3),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.lock, color: Colors.black54),
          hintText: label,
          hintStyle: GoogleFonts.quicksand(
            fontSize: 14,
            color: Colors.black38,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                if (label == "Password") {
                  isPasswordVisible = !isPasswordVisible;
                } else {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
