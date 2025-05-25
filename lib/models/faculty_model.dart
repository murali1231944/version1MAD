class Faculty {
  final String id;
  final String name;
  final String email;
  final String department;
  final String courseId;
  final List<String> registeredStudentIds;

  Faculty({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.courseId,
    required this.registeredStudentIds,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      department: json['department'] as String,
      courseId: json['courseId'] as String,
      registeredStudentIds: List<String>.from(
        json['registeredStudentIds'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department': department,
      'courseId': courseId,
      'registeredStudentIds': registeredStudentIds,
    };
  }
}
