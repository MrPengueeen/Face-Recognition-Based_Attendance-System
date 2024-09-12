// class HTTPUtil {
//   static final HTTPUtil _instance = HTTPUtil._internal();

//   factory HTTPUtil() {
//     if (_instance == null) {
//       return HTTPUtil._internal();
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:face_recognition_attendance/services/constants/app_constants.dart';

class HTTPUtil {
  static final HTTPUtil _instance = HTTPUtil._internal();

  late Dio dio;

  factory HTTPUtil() {
    return _instance;
  }

  HTTPUtil._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 60),
      headers: {},
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );

    dio = Dio(options);
  }

  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    path = AppConstants.BASE_URL + path;
    try {
      var response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: requestOptions,
      );
      print("Response: ${response.toString()}");
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        return Future.error(e.response!.data);
      } else {
        print(e.requestOptions);
        print(e.message);
      }
    }
  }

  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    path = AppConstants.BASE_URL + path;
    print('path: $path');
    print("Request Body: $data");
    Options requestOptions = options ??
        Options(
          contentType: 'application/json',
        );
    requestOptions.headers = requestOptions.headers ?? {};

    try {
      var response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions,
      );
      print("Response: ${response.toString()}");
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        return Future.error(e.response!.data);
      } else {
        print(e.requestOptions);
        print(e.message);
      }
    }
  }
}
