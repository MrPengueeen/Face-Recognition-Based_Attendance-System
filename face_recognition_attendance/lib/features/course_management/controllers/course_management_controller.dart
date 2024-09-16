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
}
