import 'package:dio/dio.dart';
import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/features/course_management/models/student_model.dart';
import 'package:face_recognition_attendance/services/constants/app_constants.dart';
import 'package:face_recognition_attendance/services/http/http-utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
