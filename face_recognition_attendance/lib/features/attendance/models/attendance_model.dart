import 'package:face_recognition_attendance/features/course_management/models/student_model.dart';

class AttendanceModel {
  int? id;
  int? courseId;
  String? topic;
  String? date;
  List<StudentModel>? students;

  AttendanceModel(
      {this.id, this.courseId, this.topic, this.date, this.students});

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseId = json['course_id'];
    topic = json['topic'];
    date = json['date'];
    if (json['students'] != null) {
      students = <StudentModel>[];
      json['students'].forEach((v) {
        students!.add(StudentModel.fromJson(v));
      });
    }

    students!.sort((a, b) => a.studentId!.compareTo(b.studentId!));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_id'] = this.courseId;
    data['topic'] = this.topic;
    data['date'] = this.date;
    if (this.students != null) {
      data['students'] = this.students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
