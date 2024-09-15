import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:face_recognition_attendance/features/attendance/models/attendance_model.dart';
import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/features/course_management/models/student_model.dart';
import 'package:face_recognition_attendance/services/constants/app_constants.dart';
import 'package:face_recognition_attendance/services/http/http-utils.dart';
import 'package:intl/intl.dart';

class AttendanceController {
  final HTTPUtil httpUtil = HTTPUtil();

  Future getCoursesByTeacher(int teacherId) async {
    Map<String, dynamic> queryParameters = {
      'teacher_id': teacherId,
    };

    try {
      final response = await httpUtil.get(AppConstants.COURSES,
          queryParameters: queryParameters);
      List<CourseModel> courseList = [];
      (response as List).forEach((element) {
        courseList.add(CourseModel.fromJson(element));
      });
      return courseList;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future processAttendanceFromImage(CourseModel course, List<int> image) async {
    Map<String, dynamic> queryParameters = {
      'course_id': course.id,
    };
    var formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(image, filename: 'attendance.jpg'),
    });
    try {
      final response = await httpUtil.post(AppConstants.ATTENDANCE,
          queryParameters: queryParameters, data: formData);
      List<StudentModel> presentStudents = [];
      (response as List).forEach((element) {
        presentStudents.add(StudentModel.fromJson(element));
      });

      return presentStudents;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future getAttendanceByDate(CourseModel course, DateTime date) async {
    Map<String, dynamic> queryParameters = {
      'course_id': course.id,
      'date': DateFormat('yyyy-MM-dd').format(date).toString(),
    };

    try {
      final response = await httpUtil.get(AppConstants.ATTENDANCE,
          queryParameters: queryParameters);
      List<AttendanceModel> attendanceList =
          (response as List).map((e) => AttendanceModel.fromJson(e)).toList();

      return attendanceList;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future submitAttendance(
      CourseModel course, List<StudentModel> presentStudents) async {
    Map<String, dynamic> queryParameters = {
      'course_id': course.id,
    };
    var data = json.encode(presentStudents.map((e) => e.toJson()).toList());
    try {
      final response = await httpUtil.post(AppConstants.SUBMIT_ATTENDANCE,
          queryParameters: queryParameters, data: data);

      return response;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future getAttendanceSummary(CourseModel course) async {
    Map<String, dynamic> queryParameters = {
      'course_id': course.id,
    };

    try {
      final response = await httpUtil.get(AppConstants.ATTENDANCE_SUMMARY,
          queryParameters: queryParameters);
      List<AttendanceModel> attendanceList =
          (response as List).map((e) => AttendanceModel.fromJson(e)).toList();

      return attendanceList;
    } catch (error) {
      return Future.error(error);
    }
  }
}
