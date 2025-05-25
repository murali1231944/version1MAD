class Group {
  String groupId;
  String courseId;
  List<String> studentUsns; // List of student USNs

  Group({
    required this.groupId,
    required this.courseId,
    required this.studentUsns,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'courseId': courseId,
      'studentUsns': studentUsns,
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['groupId'],
      courseId: json['courseId'],
      studentUsns: List<String>.from(json['studentUsns']),
    );
  }
}