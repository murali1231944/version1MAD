  class Course {
  String courseId;
  String courseName;
  int maxInternal1;
  int maxInternal2;
  int maxInternal3;
  int maxExternal;

  Course({
    required this.courseId,
    required this.courseName,
    required this.maxInternal1,
    required this.maxInternal2,
    required this.maxInternal3,
    required this.maxExternal,
  });

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'maxInternal1': maxInternal1,
      'maxInternal2': maxInternal2,
      'maxInternal3': maxInternal3,
      'maxExternal': maxExternal,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['courseId'],
      courseName: json['courseName'],
      maxInternal1: json['maxInternal1'],
      maxInternal2: json['maxInternal2'],
      maxInternal3: json['maxInternal3'],
      maxExternal: json['maxExternal'],
    );
  }
}