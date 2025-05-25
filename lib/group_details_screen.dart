import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'display_marks_screen.dart';
import 'main.dart'; // Import GradientScaffold

class GroupDetailsScreen extends StatelessWidget {
  final String groupId;
  final String courseId;

  const GroupDetailsScreen({super.key, required this.groupId, required this.courseId});

  Future<void> _removeStudentFromGroup(BuildContext context, String groupId, String studentUsn) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Removal"),
          content: Text("Are you sure you want to remove this student from the group?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Remove"),
              onPressed: () async {
                try {
                  DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance.collection('groups').doc(groupId).get();
                  if (groupSnapshot.exists) {
                    final groupData = groupSnapshot.data() as Map<String, dynamic>;
                    List<dynamic> studentUsns = List.from(groupData['studentUsns'] ?? []);
                    if (studentUsns.contains(studentUsn)) {
                      studentUsns.remove(studentUsn);
                      await FirebaseFirestore.instance.collection('groups').doc(groupId).update({'studentUsns': studentUsns});
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Student removed from group successfully.')));
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Student not found in group.')));
                      Navigator.of(context).pop();
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Group not found.')));
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove student: $e')));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Group Details', style: TextStyle(color: theme.colorScheme.onPrimary)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('groups').doc(groupId).get(),
          builder: (context, groupSnapshot) {
            if (groupSnapshot.hasError) {
              return Center(child: Text('Error loading group details', style: TextStyle(color: theme.colorScheme.onPrimary)));
            }
            if (!groupSnapshot.hasData || !groupSnapshot.data!.exists) {
              return Center(child: Text('Group not found', style: TextStyle(color: theme.colorScheme.onPrimary)));
            }
            final groupData = groupSnapshot.data!.data() as Map<String, dynamic>;
            final studentUsns = groupData['studentUsns'] as List<dynamic>? ?? [];

            if (studentUsns.isEmpty) {
              return Center(child: Text('No students in this group.', style: TextStyle(color: theme.colorScheme.onPrimary)));
            }

            return ListView.builder(
              itemCount: studentUsns.length,
              itemBuilder: (context, index) {
                final studentUsn = studentUsns[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('students').doc(studentUsn).get(),
                  builder: (context, studentSnapshot) {
                    if (studentSnapshot.hasError) {
                      return ListTile(title: Text('Error loading student', style: TextStyle(color: theme.colorScheme.onPrimary)));
                    }
                    if (!studentSnapshot.hasData || !studentSnapshot.data!.exists) {
                      return ListTile(title: Text('Student not found', style: TextStyle(color: theme.colorScheme.onPrimary)));
                    }
                    final studentData = studentSnapshot.data!.data() as Map<String, dynamic>;
                    final studentName = studentData['name'];

                    return Card(
                      color: theme.colorScheme.onPrimary.withOpacity(0.3),
                      child: ListTile(
                        title: Text(studentName, style: TextStyle(color: theme.colorScheme.onPrimary)),
                        subtitle: Text(studentUsn, style: TextStyle(color: theme.colorScheme.onPrimary)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisplayMarksScreen(
                                usn: studentUsn,
                                groupId: groupId,
                                courseId: courseId,
                              ),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: theme.colorScheme.onPrimary),
                          onPressed: () {
                            _removeStudentFromGroup(context, groupId, studentUsn);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}