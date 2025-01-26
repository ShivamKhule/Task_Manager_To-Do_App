import 'dart:developer';

import 'package:dept_to_do_app/Admin/AdminHomePage.dart';
import 'package:dept_to_do_app/Admin/Demo.dart';
import 'package:dept_to_do_app/Admin/SignUpScreen.dart';
import 'package:dept_to_do_app/User/UserHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:toasty_box/toast_enums.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  bool isAdmin = false; // Toggle between Admin and User login
  bool isPasswordVisible = false; // Toggle password visibility

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
          // Prevent overflow when keyboard appears
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
                  "Welcome Back!",
                  style: GoogleFonts.quicksand(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isAdmin ? "Admin Login" : "User Login",
                  style: GoogleFonts.quicksand(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 10),
                // Login Card
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
                      _buildPasswordField(passwordController),
                      const SizedBox(height: 16),
                      // Login Button
                      ElevatedButton(
                        onPressed: () async {
                          // Handle login logic
                          if (emailController.text.trim().isNotEmpty &&
                              passwordController.text.trim().isNotEmpty) {
                            try {
                              UserCredential userCredential =
                                  await _firebaseAuth
                                      .signInWithEmailAndPassword(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim());
                              ToastService.showSuccessToast(
                                context,
                                length: ToastLength.medium,
                                expandedHeight: 100,
                                message: "Login Successfull 🥂!",
                              );
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return const AdminHomePage();
                              }));
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
                            "Login",
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
                                "Sign in with Google",
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
                const SizedBox(height: 20),
                // Toggle Login Type
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAdmin = !isAdmin;
                    });
                  },
                  child: Text(
                    isAdmin ? "Switch to User Login" : "Switch to Admin Login",
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
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
                      const TextSpan(text: "Don't Have an Account? "),
                      TextSpan(
                        text: "Sign Up",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green, // You can customize the color
                          decoration:
                              TextDecoration.underline, // Optional underline
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Add your SignUp tap action here
                            Navigator.push((context),
                                MaterialPageRoute(builder: (context) {
                              return SignUpScreen();
                            }));
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

  Widget _buildTextField(
      {required String label,
      required IconData icon,
      required TextEditingController controller,
      required bool obscureText}) {
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

  Widget _buildPasswordField(TextEditingController controller) {
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
        obscureText: !isPasswordVisible,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.lock, color: Colors.black54),
          hintText: "Password",
          hintStyle: GoogleFonts.quicksand(
            fontSize: 14,
            color: Colors.black38,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
