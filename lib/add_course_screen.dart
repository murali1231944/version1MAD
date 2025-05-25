import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart'; // Import GradientScaffold

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courseNameController = TextEditingController();
  final _sectionController = TextEditingController();
  final _maxInternal1Controller = TextEditingController();
  final _maxInternal2Controller = TextEditingController();
  final _maxInternal3Controller = TextEditingController();
  final _maxExternalController = TextEditingController();

  Future<void> _addCourse() async {
    if (_formKey.currentState!.validate()) {
      try {
        String teacherId = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance.collection('courses').add({
          'courseName': "${_courseNameController.text}-${DateTime.now().year}",
          'section': _sectionController.text,
          'teacherId': teacherId,
          'maxInternal1': int.parse(_maxInternal1Controller.text),
          'maxInternal2': int.parse(_maxInternal2Controller.text),
          'maxInternal3': int.parse(_maxInternal3Controller.text),
          'maxExternal': int.parse(_maxExternalController.text),
        });
        Navigator.pop(context); // Go back to dashboard
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add course.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get theme context

    return GradientScaffold( // Use GradientScaffold
      child: Scaffold(
        backgroundColor: Colors.transparent, // Transparent Scaffold
        appBar: AppBar(
          title: Text('Add Course', style: TextStyle(color: theme.colorScheme.onPrimary)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _courseNameController,
                  decoration: InputDecoration(
                    labelText: 'Course Name',
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15), // Increased radius
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.onPrimary.withOpacity(0.3),
                  ),
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter course name';
                    }
                    return null;
                  },
                  autocorrect: false,
                  enableSuggestions: false,
                ),
                SizedBox(height: 10), // Add spacing
                TextFormField(
                  controller: _sectionController,
                  decoration: InputDecoration(
                    labelText: 'Section',
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15), // Increased radius
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.onPrimary.withOpacity(0.3),
                  ),
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter section';
                    }
                    return null;
                  },
                  autocorrect: false,
                  enableSuggestions: false,
                ),
                SizedBox(height: 10), // Add spacing
                TextFormField(
                  controller: _maxInternal1Controller,
                  decoration: InputDecoration(
                    labelText: 'Max Internal 1 Marks',
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15), // Increased radius
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.onPrimary.withOpacity(0.3),
                  ),
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter max marks';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10), // Add spacing
                TextFormField(
                  controller: _maxInternal2Controller,
                  decoration: InputDecoration(
                    labelText: 'Max Internal 2 Marks',
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15), // Increased radius
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.onPrimary.withOpacity(0.3),
                  ),
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter max marks';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10), // Add spacing
                TextFormField(
                  controller: _maxInternal3Controller,
                  decoration: InputDecoration(
                    labelText: 'Max Internal 3 Marks',
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15), // Increased radius
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.onPrimary.withOpacity(0.3),
                  ),
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter max marks';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10), // Add spacing
                TextFormField(
                  controller: _maxExternalController,
                  decoration: InputDecoration(
                    labelText: 'Max External Marks',
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15), // Increased radius
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.onPrimary.withOpacity(0.3),
                  ),
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter max marks';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.5),
                    textStyle: TextStyle(color: theme.colorScheme.surface),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Rounded button
                  ),
                  child: Text('Add Course'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}