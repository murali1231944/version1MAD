import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'register_screen.dart';

import 'dashboard_screen.dart';

import 'main.dart'; // Import your main.dart where GradientScaffold is defined.



class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});



  @override

  _LoginScreenState createState() => _LoginScreenState();

}



class _LoginScreenState extends State<LoginScreen> {

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();



  Future<void> _handleSignIn() async {

    if (_formKey.currentState!.validate()) {

      try {

        await FirebaseAuth.instance.signInWithEmailAndPassword(

          email: _emailController.text,

          password: _passwordController.text,

        );

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(builder: (context) => DashboardScreen()),

        );

      } on FirebaseAuthException catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(content: Text('Login failed: ${e.message}')),

        );

      }

    }

  }



  @override

  Widget build(BuildContext context) {

    final theme = Theme.of(context); // Access the current theme



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

                  Icon(Icons.lock_outline, size: 80, color: theme.colorScheme.onPrimary), // Use theme colors

                  SizedBox(height: 24),

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

                      if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')

                          .hasMatch(value)) {

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

                      labelText: 'Password',

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

                        return 'Please enter your password';

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