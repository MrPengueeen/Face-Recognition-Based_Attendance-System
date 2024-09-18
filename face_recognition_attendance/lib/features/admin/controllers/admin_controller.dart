import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:face_recognition_attendance/features/attendance/models/attendance_model.dart';
import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/features/course_management/models/student_model.dart';
import 'package:face_recognition_attendance/services/constants/app_constants.dart';
import 'package:face_recognition_attendance/services/http/http-utils.dart';
import 'package:intl/intl.dart';

class AdminController {
  final HTTPUtil httpUtil = HTTPUtil();

  Future addNewStudent(
      String name, int studentId, String session, List<int> image) async {
    Map<String, dynamic> queryParameters = {
      'student_id': studentId.toString(),
      'name': name,
      'session': session,
    };

    var formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(image, filename: 'image.jpg'),
    });
    try {
      final response = await httpUtil.post(AppConstants.STUDENTS,
          queryParameters: queryParameters, data: formData);

      final student = StudentModel.fromJson(response);
      return student;
    } catch (error) {
      return Future.error(error);
    }
  }
}
