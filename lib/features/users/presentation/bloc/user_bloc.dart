import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/search_users_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

EventTransformer<Event> debounceSwitch<Event>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsersUseCase;
  final SearchUsersUseCase searchUsersUseCase;

  UserBloc({
    required this.getUsersUseCase,
    required this.searchUsersUseCase,
  }) : super(UserInitial()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<LoadMoreUsersEvent>(_onLoadMoreUsers);
    on<RefreshUsersEvent>(_onRefreshUsers);
    on<SearchUsersEvent>(
      _onSearchUsers,
      transformer: debounceSwitch(const Duration(milliseconds: 300)),
    );
  }

  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await getUsersUseCase(page: event.page);
    result.fold(
      (failure) => emit(UserError(message: _mapFailureToMessage(failure))),
      (users) {
        if (users.isEmpty && event.page == 1) {
          emit(UserEmpty());
        } else {
          emit(UserLoaded(
            users: users,
            hasMore: users.length >= 6,
            currentPage: event.page,
          ));
        }
      },
    );
  }

  Future<void> _onLoadMoreUsers(
    LoadMoreUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;
    if (currentState is UserLoaded && currentState.hasMore) {
      emit(UserLoadingMore(users: currentState.users));

      final nextPage = currentState.currentPage + 1;
      final result = await getUsersUseCase(page: nextPage);

      result.fold(
        (failure) => emit(UserLoaded(
          users: currentState.users,
          hasMore: false,
          currentPage: currentState.currentPage,
        )),
        (newUsers) {
          if (newUsers.isEmpty) {
            emit(UserLoaded(
              users: currentState.users,
              hasMore: false,
              currentPage: currentState.currentPage,
            ));
          } else {
            final updatedUsers = List<UserEntity>.from(currentState.users)
              ..addAll(newUsers);
            emit(UserLoaded(
              users: updatedUsers,
              hasMore: newUsers.length >= 6,
              currentPage: nextPage,
            ));
          }
        },
      );
    }
  }

  Future<void> _onRefreshUsers(
    RefreshUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await getUsersUseCase(page: 1, forceRefresh: true);
    result.fold(
      (failure) => emit(UserError(message: _mapFailureToMessage(failure))),
      (users) {
        if (users.isEmpty) {
          emit(UserEmpty());
        } else {
          emit(UserLoaded(
            users: users,
            hasMore: users.length >= 6,
            currentPage: 1,
          ));
        }
      },
    );
  }

  Future<void> _onSearchUsers(
    SearchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      await _onFetchUsers(const FetchUsersEvent(page: 1), emit);
      return;
    }

    emit(UserLoading());
    final result = await searchUsersUseCase(query);
    result.fold(
      (failure) => emit(UserError(message: _mapFailureToMessage(failure))),
      (users) {
        if (users.isEmpty) {
          emit(UserEmpty());
        } else {
          emit(UserLoaded(
            users: users,
            hasMore: false,
            currentPage: 1,
          ));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : AppStrings.defaultNetworkError;
    } else if (failure is TimeoutFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : AppStrings.defaultTimeoutError;
    } else if (failure is ServerFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : AppStrings.defaultServerError;
    } else if (failure is CacheFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : AppStrings.defaultCacheError;
    }
    return failure.message.isNotEmpty ? failure.message : AppStrings.defaultUnexpectedError;
  }
}

