import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:face_recognition_attendance/features/attendance/models/attendance_model.dart';
import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/features/course_management/models/student_model.dart';
import 'package:face_recognition_attendance/services/constants/app_constants.dart';
import 'package:face_recognition_attendance/services/http/http-utils.dart';
import 'package:intl/intl.dart';

class CourseManagementController {
  final HTTPUtil httpUtil = HTTPUtil();

  Future addCourse(int teacherId, String name, String code, String session,
      String semester) async {
    var data = json.encode({
      'teacher_id': teacherId,
      'name': name,
      'code': code,
      'session': session,
      'semester': semester,
    });

    try {
      final response = await httpUtil.post(AppConstants.COURSES, data: data);
      final course = CourseModel.fromJson(response);
      return course;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future removeStudentsFromCourse(
      CourseModel course, List<StudentModel> students) async {
    var data =
        json.encode(students.map((student) => student.toJson()).toList());
    var queryParameters = {
      'course_id': course.id,
    };

    try {
      final response = await httpUtil.post(AppConstants.COURSES_STUDENT_DELETE,
          queryParameters: queryParameters, data: data);

      return response;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future getStudents() async {
    try {
      final response = await httpUtil.get(
        AppConstants.STUDENTS,
      );
      List<StudentModel> studentList = [];
      (response as List).forEach((element) {
        studentList.add(StudentModel.fromJson(element));
      });
      return studentList;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future addStudentsToCourse(
      CourseModel course, List<StudentModel> students) async {
    var queryParameters = {
      'course_id': course.id,
    };

    var data =
        json.encode(students.map((student) => student.toJson()).toList());
    try {
      final response = await httpUtil.post(
        AppConstants.COURSES_STUDENT,
        queryParameters: queryParameters,
        data: data,
      );

      return response;
    } catch (error) {
      return Future.error(error);
    }
  }
}
