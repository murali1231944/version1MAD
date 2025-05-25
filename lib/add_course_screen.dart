import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'models/default_teachers.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courseNameController = TextEditingController();
  final _sectionController = TextEditingController();
  DefaultTeacher? _selectedTeacher;  Future<void> _addCourse() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_selectedTeacher == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a teacher')),
          );
          return;
        }
        await FirebaseFirestore.instance.collection('courses').add({
          'courseName': "${_courseNameController.text}-${DateTime.now().year}",
          'section': _sectionController.text,
          'teacherId': _selectedTeacher!.teacherId,
          'teacherName': _selectedTeacher!.teacherName,
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
    final theme = Theme.of(context);

    return GradientScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                      borderRadius: BorderRadius.circular(15),
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
                    // Validate if the course is in teacher's allowed courses
                    if (_selectedTeacher != null && 
                        !_selectedTeacher!.courses.contains(value.split('-')[0].trim())) {
                      return 'This teacher cannot teach this course';
                    }
                    return null;
                  },
                  autocorrect: false,
                  enableSuggestions: false,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<DefaultTeacher>(
                  value: _selectedTeacher,
                  decoration: InputDecoration(
                    labelText: 'Select Teacher',
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
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
                  dropdownColor: theme.colorScheme.primary,
                  items: defaultTeachers.map((teacher) {
                    return DropdownMenuItem<DefaultTeacher>(
                      value: teacher,
                      child: Text(
                        '${teacher.teacherName} (${teacher.courses.join(", ")})',
                        style: TextStyle(color: theme.colorScheme.onPrimary),
                      ),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a teacher';
                    }
                    return null;
                  },
                  onChanged: (DefaultTeacher? value) {
                    setState(() {
                      _selectedTeacher = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _sectionController,
                  decoration: InputDecoration(
                    labelText: 'Section',
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.5),
                    textStyle: TextStyle(color: theme.colorScheme.surface),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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