class DefaultTeacher {
  final String teacherId;
  final String teacherName;
  final String email;
  final List<String> courses;

  DefaultTeacher({
    required this.teacherId,
    required this.teacherName,
    required this.email,
    required this.courses,
  });
}

final List<DefaultTeacher> defaultTeachers = [
  DefaultTeacher(
    teacherId: 'T001',
    teacherName: 'Dr. Smith',
    email: 'smith@faculty.com',
    courses: ['SE', 'MAD'],
  ),
  DefaultTeacher(
    teacherId: 'T002',
    teacherName: 'Dr. Johnson',
    email: 'johnson@faculty.com',
    courses: ['USP', 'FWD'],
  ),
  DefaultTeacher(
    teacherId: 'T003',
    teacherName: 'Dr. Williams',
    email: 'williams@faculty.com',
    courses: ['ML', 'SE'],
  ),
  DefaultTeacher(
    teacherId: 'T004',
    teacherName: 'Dr. Brown',
    email: 'brown@faculty.com',
    courses: ['UHV', 'ML'],
  ),
];
