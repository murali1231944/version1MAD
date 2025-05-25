import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'group_details_screen.dart';
import 'add_group_screen.dart';
import 'main.dart'; // Import GradientScaffold

class CourseDetailsScreen extends StatelessWidget {
  final String courseId;
  final String teacherId;

  const CourseDetailsScreen({super.key, required this.courseId, required this.teacherId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Groups', style: TextStyle(color: theme.colorScheme.onPrimary)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('groups')
              .where('courseId', isEqualTo: courseId)
              .where('teacherId', isEqualTo: teacherId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error loading groups', style: TextStyle(color: theme.colorScheme.onPrimary)));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary)));
            }
            final groups = snapshot.data!.docs;
            if (groups.isEmpty) {
              return Center(child: Text('No groups found.', style: TextStyle(color: theme.colorScheme.onPrimary)));
            }
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return Card(
                  color: theme.colorScheme.onPrimary.withOpacity(0.3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: ListTile(
                    title: Text(group['groupName'], style: TextStyle(color: theme.colorScheme.onPrimary)),
                    subtitle: Text(group['groupTopic'], style: TextStyle(color: theme.colorScheme.onPrimary)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetailsScreen(
                            groupId: group.id,
                            courseId: courseId,
                          ),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: theme.colorScheme.onPrimary),
                      onPressed: () => _deleteGroup(context, group.id),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddGroupScreen(courseId: courseId),
              ),
            );
          },
          backgroundColor: Colors.blue,
          child: Icon(Icons.add, color: theme.colorScheme.surface),
        ),
      ),
    );
  }

  Future<void> _deleteGroup(BuildContext context, String groupId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this group and its students?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () async {
                try {
                  // Delete students in the group
                  QuerySnapshot studentsSnapshot = await FirebaseFirestore.instance
                      .collection('students')
                      .where('groupId', isEqualTo: groupId)
                      .get();

                  for (QueryDocumentSnapshot studentDoc in studentsSnapshot.docs) {
                    await FirebaseFirestore.instance.collection('students').doc(studentDoc.id).delete();
                  }

                  // Delete the group itself
                  await FirebaseFirestore.instance.collection('groups').doc(groupId).delete();

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Group and its students deleted successfully.')));
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete group and students: $e')));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}