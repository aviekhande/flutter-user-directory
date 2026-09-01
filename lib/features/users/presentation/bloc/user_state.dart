import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

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

class UserLoadingMore extends UserState {
  final List<UserEntity> users;

  const UserLoadingMore({required this.users});

  @override
  List<Object?> get props => [users];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserEmpty extends UserState {}

