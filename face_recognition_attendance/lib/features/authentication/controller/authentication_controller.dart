import 'package:face_recognition_attendance/services/constants/app_constants.dart';
import 'package:face_recognition_attendance/services/http/http-utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController {
  final HTTPUtil httpUtil = HTTPUtil();

  Future login(String email, String password) async {
    Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };

    try {
      final response = await httpUtil.post(
        AppConstants.LOGIN_URL,
        data: body,
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('user_id', response['id']);
    } catch (error) {
      print('In controller error');
      return Future.error((error as Map)['detail']);
    }
  }
}
