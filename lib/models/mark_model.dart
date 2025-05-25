class Mark {
  String studentUsn;
  String courseId;
  int internal1;
  int internal2;
  int internal3;
  int external;

  Mark({
    required this.studentUsn,
    required this.courseId,
    required this.internal1,
    required this.internal2,
    required this.internal3,
    required this.external,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentUsn': studentUsn,
      'courseId': courseId,
      'internal1': internal1,
      'internal2': internal2,
      'internal3': internal3,
      'external': external,
    };
  }

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      studentUsn: json['studentUsn'],
      courseId: json['courseId'],
      internal1: json['internal1'],
      internal2: json['internal2'],
      internal3: json['internal3'],
      external: json['external'],
    );
  }
}