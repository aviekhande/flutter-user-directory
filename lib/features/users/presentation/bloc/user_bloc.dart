import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_users.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;

  UserBloc({required this.getUsers}) : super(UserInitial()) {
    on<GetUsersEvent>((event, emit) async {
      // Logic will be added later
    });
  }
}
