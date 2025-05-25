GIimport 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';
import '../models/course_model.dart';
import '../models/group_model.dart';
import '../models/mark_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Students
  Future<void> addStudent(Student student) async {
    await _firestore.collection('students').doc(student.usn).set(student.toJson());
  }

  Future<Student?> getStudent(String usn) async {
    DocumentSnapshot doc = await _firestore.collection('students').doc(usn).get();
    if (doc.exists) {
      return Student.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Courses
  Future<void> addCourse(Course course) async {
    await _firestore.collection('courses').doc(course.courseId).set(course.toJson());
  }

  Future<Course?> getCourse(String courseId) async {
    DocumentSnapshot doc = await _firestore.collection('courses').doc(courseId).get();
    if (doc.exists) {
      return Course.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Groups
  Future<void> addGroup(Group group) async {
    await _firestore.collection('groups').doc(group.groupId).set(group.toJson());
  }

  Future<Group?> getGroup(String groupId) async {
    DocumentSnapshot doc = await _firestore.collection('groups').doc(groupId).get();
    if (doc.exists) {
      return Group.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Group>> getGroupsForCourse(String courseId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('groups')
        .where('courseId', isEqualTo: courseId)
        .get();

    return querySnapshot.docs
        .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<bool> isStudentInGroup(String studentUsn, String courseId) async {
    List<Group> groups = await getGroupsForCourse(courseId);

    for (Group group in groups) {
      if (group.studentUsns.contains(studentUsn)) {
        return true;
      }
    }
    return false;
  }

  Future<void> addStudentToGroup(String groupId, String studentUsn) async {
    DocumentReference groupRef = _firestore.collection('groups').doc(groupId);
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(groupRef);
      if (!snapshot.exists) {
        throw Exception("Group does not exist!");
      }

      Group group = Group.fromJson(snapshot.data() as Map<String, dynamic>);
      if (!group.studentUsns.contains(studentUsn)) {
        group.studentUsns.add(studentUsn);
        transaction.update(groupRef, group.toJson());
      }
    });
  }

  // Marks
  Future<void> addMark(Mark mark) async {
    await _firestore.collection('marks').doc('${mark.studentUsn}-${mark.courseId}').set(mark.toJson());
  }

  Future<Mark?> getMark(String studentUsn, String courseId) async {
    DocumentSnapshot doc = await _firestore.collection('marks').doc('$studentUsn-$courseId').get();
    if (doc.exists) {
      return Mark.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}