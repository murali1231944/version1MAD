class Student {
  String usn;
  String name;
  String section;
  String department;
  List<String> courses; // List of course IDs

  Student({
    required this.usn,
    required this.name,
    required this.section,
    required this.department,
    required this.courses,
  });

  Map<String, dynamic> toJson() {
    return {
      'usn': usn,
      'name': name,
      'section': section,
      'department': department,
      'courses': courses,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      usn: json['usn'],
      name: json['name'],
      section: json['section'],
      department: json['department'],
      courses: List<String>.from(json['courses']),
    );
  }
}