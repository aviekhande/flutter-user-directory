import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsersEvent extends UserEvent {
  final int page;

  const FetchUsersEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class LoadMoreUsersEvent extends UserEvent {}

class RefreshUsersEvent extends UserEvent {}

class SearchUsersEvent extends UserEvent {
  final String query;

  const SearchUsersEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class GetUsersEvent extends FetchUsersEvent {
  const GetUsersEvent({super.page = 1});
}

