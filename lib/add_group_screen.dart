import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart'; // Import GradientScaffold

class AddGroupScreen extends StatefulWidget {
  final String courseId;

  const AddGroupScreen({super.key, required this.courseId});

  @override
  _AddGroupScreenState createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _groupTopicController = TextEditingController();
  final _studentUsnsController = TextEditingController();
  final _studentNamesController = TextEditingController();

  Future<void> _addGroup() async {
    if (_formKey.currentState!.validate()) {
      try {
        String teacherId = FirebaseAuth.instance.currentUser!.uid;
        List<String> studentUsns = _studentUsnsController.text.split(',').map((usn) => usn.trim()).toList();
        List<String> studentNames = _studentNamesController.text.split(',').map((name) => name.trim()).toList();

        if (studentUsns.length != studentNames.length) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Number of USNs and names must match.')),
          );
          return;
        }

        if (studentUsns.toSet().length != studentUsns.length) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Duplicate USNs found in input.')),
          );
          return;
        }

        bool usnsAreUnique = await _areUsnsUniqueForCourse(studentUsns);
        if (!usnsAreUnique) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('One or more USNs already exist in other groups for this course.')),
          );
          return;
        }

        List<String> students = [];
        for (int i = 0; i < studentUsns.length; i++) {
          students.add(studentUsns[i]);

          await FirebaseFirestore.instance.collection('students').doc(studentUsns[i]).set({
            'name': studentNames[i],
            'usn': studentUsns[i],
          });
        }

        await FirebaseFirestore.instance.collection('groups').add({
          'courseId': widget.courseId,
          'groupName': _groupNameController.text,
          'groupTopic': _groupTopicController.text,
          'teacherId': teacherId,
          'studentUsns': students,
        });

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add group or student: ${e.toString()}')),
        );
      }
    }
  }

  Future<bool> _areUsnsUniqueForCourse(List<String> usns) async {
    QuerySnapshot groupsSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where('courseId', isEqualTo: widget.courseId)
        .get();

    for (QueryDocumentSnapshot groupDoc in groupsSnapshot.docs) {
      List<dynamic> existingUsns = groupDoc['studentUsns'] ?? [];
      for (String usn in usns) {
        if (existingUsns.contains(usn)) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get theme context

    return GradientScaffold( // Use GradientScaffold
      child: Scaffold(
        backgroundColor: Colors.transparent, // Transparent Scaffold
        appBar: AppBar(
          title: Text('Add Group', style: TextStyle(color: theme.colorScheme.onPrimary)),
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
                  controller: _groupNameController,
                  decoration: InputDecoration(
                    labelText: 'Group Name',
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded rectangle border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.onPrimary.withOpacity(0.3),
                  ),
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter group name';
                    }
                    return null;
                  },
                  autocorrect: false,
                  enableSuggestions: false,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _groupTopicController,
                  decoration: InputDecoration(
                    labelText: 'Group Topic',
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded rectangle border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.onPrimary.withOpacity(0.3),
                  ),
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter group topic';
                    }
                    return null;
                  },
                  autocorrect: false,
                  enableSuggestions: false,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _studentUsnsController,
                  decoration: InputDecoration(
                    labelText: 'Student USNs (comma separated)',
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded rectangle border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.onPrimary.withOpacity(0.3),
                  ),
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter student USNs';
                    }
                    return null;
                  },
                  autocorrect: false,
                  enableSuggestions: false,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _studentNamesController,
                  decoration: InputDecoration(
                    labelText: 'Student Names (comma separated)',
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded rectangle border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.onPrimary.withOpacity(0.3),
                  ),
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter student Names';
                    }
                    return null;
                  },
                  autocorrect: false,
                  enableSuggestions: false,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.5),
                    textStyle: TextStyle(color: theme.colorScheme.surface),
                  ),
                  child: Text('Add Group'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}