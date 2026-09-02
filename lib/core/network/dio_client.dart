import 'package:dio/dio.dart';
import '../constants/constants.dart';

/// Configured [Dio] HTTP client singleton factory.
/// Enforces standard connection timeouts, headers, and log interceptors.
class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: false,
        requestHeader: false,
        responseHeader: false,
        responseBody: false,
        error: true,
      ),
    );

    return dio;
  }
}
