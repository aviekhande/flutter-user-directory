import 'package:dio/dio.dart';
import '../constants/constants.dart';

class DioClient {
  final Dio dio;

  DioClient(this.dio) {
    dio
      ..options.baseUrl = AppConstants.baseUrl
      ..options.connectTimeout = const Duration(milliseconds: AppConstants.connectTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: AppConstants.receiveTimeout)
      ..options.responseType = ResponseType.json
      ..interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
  }
}
