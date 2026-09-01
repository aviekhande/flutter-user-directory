import 'package:equatable/equatable.dart';

/// Abstract base class for all [UserBloc] events.
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers initial page fetching for users.
class FetchUsersEvent extends UserEvent {
  final int page;

  const FetchUsersEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

/// Triggers infinite scroll pagination to fetch the next batch of users.
class LoadMoreUsersEvent extends UserEvent {}

/// Triggers a fresh cache-clearing pull-to-refresh reload.
class RefreshUsersEvent extends UserEvent {}

/// Triggers a debounced search filter by user name.
class SearchUsersEvent extends UserEvent {
  final String query;

  const SearchUsersEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Alias for [FetchUsersEvent] for compatibility.
class GetUsersEvent extends FetchUsersEvent {
  const GetUsersEvent({super.page = 1});
}
