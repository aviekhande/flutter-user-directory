import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

/// Abstract base class for all UI states emitted by [UserBloc].
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// Initial uninitialized state before any fetch operation.
class UserInitial extends UserState {}

/// State emitted while performing initial user load or pull-to-refresh.
class UserLoading extends UserState {}

/// State emitted when users are successfully loaded and ready for display.
class UserLoaded extends UserState {
  final List<UserEntity> users;
  final bool hasMore;
  final int currentPage;

  const UserLoaded({
    required this.users,
    required this.hasMore,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [users, hasMore, currentPage];
}

/// State emitted while loading subsequent pagination batches at bottom of list.
class UserLoadingMore extends UserState {
  final List<UserEntity> users;

  const UserLoadingMore({required this.users});

  @override
  List<Object?> get props => [users];
}

/// State emitted when an error occurs during fetch or search operations.
class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State emitted when no matching users are found in search or API response.
class UserEmpty extends UserState {}
