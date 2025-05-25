import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart'; // Import GradientScaffold

class DisplayMarksScreen extends StatefulWidget {
  final String usn;
  final String groupId;
  final String courseId;

  const DisplayMarksScreen({super.key, required this.usn, required this.groupId, required this.courseId});

  @override
  _DisplayMarksScreenState createState() => _DisplayMarksScreenState();
}

class _DisplayMarksScreenState extends State<DisplayMarksScreen> {
  Map<String, TextEditingController> _marksControllers = {};
  bool _isEditing = false;
  Map<String, double> _maxMarks = {};

  @override
  void initState() {
    super.initState();
    _loadMarksAndMaxMarks();
  }

  Future<void> _loadMarksAndMaxMarks() async {
    try {
      DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance.collection('courses').doc(widget.courseId).get();

      if (courseSnapshot.exists) {
        final courseData = courseSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _maxMarks = {
            'internal1': courseData['maxInternal1']?.toDouble() ?? 100.0,
            'internal2': courseData['maxInternal2']?.toDouble() ?? 100.0,
            'internal3': courseData['maxInternal3']?.toDouble() ?? 100.0,
            'external': courseData['maxExternal']?.toDouble() ?? 100.0,
          };
        });
      }

      DocumentReference marksDocRef = FirebaseFirestore.instance.collection('marks').doc('${widget.usn}-${widget.groupId}');

      DocumentSnapshot marksSnapshot = await marksDocRef.get();

      if (marksSnapshot.exists) {
        final marksData = marksSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _marksControllers = {
            'internal1': TextEditingController(text: marksData['internal1'].toString()),
            'internal2': TextEditingController(text: marksData['internal2'].toString()),
            'internal3': TextEditingController(text: marksData['internal3'].toString()),
            'external': TextEditingController(text: marksData['external'].toString()),
          };
        });
      } else {
        await marksDocRef.set({
          'internal1': 0.0,
          'internal2': 0.0,
          'internal3': 0.0,
          'external': 0.0,
        });
        setState(() {
          _marksControllers = {
            'internal1': TextEditingController(text: '0'),
            'internal2': TextEditingController(text: '0'),
            'internal3': TextEditingController(text: '0'),
            'external': TextEditingController(text: '0'),
          };
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
    }
  }

  Future<void> _saveMarks() async {
    try {
      Map<String, dynamic> updatedMarks = {};
      for (var entry in _marksControllers.entries) {
        double mark = double.parse(entry.value.text);
        if (mark > _maxMarks[entry.key]!) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marks for ${entry.key} exceeds the maximum allowed.')));
          return;
        }
        updatedMarks[entry.key] = mark;
      }

      await FirebaseFirestore.instance.collection('marks').doc('${widget.usn}-${widget.groupId}').update(updatedMarks);

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marks saved successfully.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save marks: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Marks for ${widget.usn}', style: TextStyle(color: theme.colorScheme.onPrimary)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit, color: theme.colorScheme.onPrimary),
              onPressed: () {
                setState(() {
                  if (_isEditing) {
                    _saveMarks();
                  }
                  _isEditing = !_isEditing;
                });
              },
            ),
          ],
        ),
        body: _marksControllers.isEmpty
            ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary)))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var entry in _marksControllers.entries)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: entry.value,
                          enabled: _isEditing,
                          decoration: InputDecoration(
                            labelText: entry.key,
                            hintText: 'Max: ${_maxMarks[entry.key]}',
                            labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: _isEditing ? theme.colorScheme.onPrimary : Colors.grey,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          style: TextStyle(color: theme.colorScheme.onPrimary),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}