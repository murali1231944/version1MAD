import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';
import 'main.dart';
import 'models/default_teachers.dart'; // Import default teachers

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isTeacherLogin = false; // Toggle between teacher and student login

  // Helper method to check if email and password match a default teacher
  DefaultTeacher? _findMatchingTeacher(String email, String password) {
    return defaultTeachers.firstWhere(
      (teacher) => teacher.email == email && teacher.teacherId == password,
      orElse: () => null as DefaultTeacher,
    );
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_isTeacherLogin) {
          // Check if the credentials match a default teacher
          DefaultTeacher? matchingTeacher = _findMatchingTeacher(
            _emailController.text,
            _passwordController.text,
          );

          if (matchingTeacher == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid teacher credentials')),
            );
            return;
          }
        }

        // Proceed with Firebase authentication
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.lock_outline, size: 80, color: theme.colorScheme.onPrimary),
                  SizedBox(height: 24),
                  // Toggle button for teacher/student login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Student', style: TextStyle(color: !_isTeacherLogin ? theme.colorScheme.onPrimary : theme.colorScheme.onPrimary.withOpacity(0.5))),
                      Switch(
                        value: _isTeacherLogin,
                        onChanged: (value) {
                          setState(() {
                            _isTeacherLogin = value;
                            // Clear the form when switching
                            _emailController.clear();
                            _passwordController.clear();
                          });
                        },
                        activeColor: theme.colorScheme.onPrimary,
                      ),
                      Text('Teacher', style: TextStyle(color: _isTeacherLogin ? theme.colorScheme.onPrimary : theme.colorScheme.onPrimary.withOpacity(0.5))),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: theme.colorScheme.onPrimary)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: theme.colorScheme.onPrimary)),
                      filled: true,
                      fillColor: theme.colorScheme.onPrimary.withOpacity(0.3),
                    ),
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (_isTeacherLogin) {
                        // For teacher login, check if email exists in default teachers
                        bool isValidTeacherEmail = defaultTeachers.any((t) => t.email == value);
                        if (!isValidTeacherEmail) {
                          return 'Invalid teacher email';
                        }
                      }
                      if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: _isTeacherLogin ? 'Teacher ID' : 'Password',
                      labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: theme.colorScheme.onPrimary)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: theme.colorScheme.onPrimary)),
                      filled: true,
                      fillColor: theme.colorScheme.onPrimary.withOpacity(0.3),
                    ),
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _isTeacherLogin ? 'Please enter your Teacher ID' : 'Please enter your password';
                      }
                      if (_isTeacherLogin) {
                        // For teacher login, check if ID exists in default teachers
                        bool isValidTeacherId = defaultTeachers.any((t) => t.teacherId == value);
                        if (!isValidTeacherId) {
                          return 'Invalid Teacher ID';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.5),
                      textStyle: TextStyle(fontSize: 18, color: theme.colorScheme.surface),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Login'),
                  ),
                  SizedBox(height: 16),
                  if (!_isTeacherLogin) // Only show register button for students
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text('Register', style: TextStyle(color: theme.colorScheme.onPrimary)),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}