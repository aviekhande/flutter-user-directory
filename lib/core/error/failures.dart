import 'package:equatable/equatable.dart';
import '../constants/app_strings.dart';

/// Base Failure class representing domain-level error conditions.
/// Uses [Equatable] to facilitate value equality comparisons in BLoC states.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Represents failures resulting from remote server issues.
class ServerFailure extends Failure {
  const ServerFailure([super.message = AppStrings.defaultServerError]);
}

/// Represents failures resulting from local Hive storage read/write errors.
class CacheFailure extends Failure {
  const CacheFailure([super.message = AppStrings.defaultCacheError]);
}

/// Represents failures due to network disconnectivity.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = AppStrings.defaultNetworkError]);
}

/// Represents failures due to API response timeouts.
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = AppStrings.defaultTimeoutError]);
}
