import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
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
}
