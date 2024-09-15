import 'package:face_recognition_attendance/features/course_management/models/student_model.dart';

class CourseModel {
  String? name;
  String? code;
  String? semester;
  String? session;
  String? teacherName;
  int? teacherId;
  int? id;
  DateTime? createdAt;
  List<StudentModel>? students;

  CourseModel(
      {this.name,
      this.code,
      this.semester,
      this.session,
      this.teacherId,
      this.id,
      this.students,
      this.createdAt,
      this.teacherName});

  CourseModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    semester = json['semester'];
    session = json['session'];
    teacherId = json['teacher_id'];
    id = json['id'];
    createdAt = DateTime.parse(json['created_at']);
    teacherName = json['teacher_name'];
    if (json['students'] != null) {
      students = <StudentModel>[];
      json['students'].forEach((v) {
        students!.add(new StudentModel.fromJson(v));
      });
    }
    students!.sort((a, b) => a.studentId!.compareTo(b.studentId!));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    data['semester'] = this.semester;
    data['session'] = this.session;
    data['teacher_id'] = this.teacherId;
    data['id'] = this.id;
    if (this.students != null) {
      data['students'] = this.students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
