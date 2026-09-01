/// Base class for all domain-level exceptions in the application.
abstract class AppException implements Exception {
  final String message;
  const AppException([this.message = '']);
}

/// Thrown when a remote server error or invalid response occurs.
class ServerException extends AppException {
  const ServerException([super.message]);
}

/// Thrown when local Hive storage cache read/write operation fails.
class CacheException extends AppException {
  const CacheException([super.message]);
}

/// Thrown when internet connectivity is unavailable.
class NetworkException extends AppException {
  const NetworkException([super.message]);
}

/// Thrown when a network request times out.
class TimeoutException extends AppException {
  const TimeoutException([super.message]);
}
