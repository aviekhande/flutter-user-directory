import "package:equatable/equatable.dart";
import '../constants/app_strings.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure([this.message = '']);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = AppStrings.defaultServerError]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = AppStrings.defaultCacheError]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = AppStrings.defaultNetworkError]);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = AppStrings.defaultTimeoutError]);
}


