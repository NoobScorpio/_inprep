import 'package:InPrep/models/user.dart';
import 'package:InPrep/user_bloc/userState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitialState(MyUser()));


  Future<MyUser> update(MyUser user) async {
    try {
      emit(UserLoadingState());
      if (user != null) {
        emit(UserLoadedState(user: user));
        return user;
      } else
        return null;
    } on Exception {
      emit(UserErrorState(message: "Could not get user"));
      return null;
    }
  }
  Future<bool> loginUser(MyUser user) async {
    try {
      emit(UserLoadingState());

      if (user == null)
        return false;
      else {
        emit(UserLoadedState(user: user));
        return true;
      }
    } on Exception {
      emit(UserErrorState(message: "Could not get user"));
      return false;
    }
  }

  logOut() {
    try {
      emit(UserLoadingState());
      emit(UserLoadedState(user: null));
    } on Exception {
      emit(UserErrorState(message: "Could not get user"));
    }
  }
}
