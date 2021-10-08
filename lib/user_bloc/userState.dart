import 'package:InPrep/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {}

class UserInitialState extends UserState {
  final MyUser user;
  UserInitialState(this.user);
  @override
  List<Object> get props => [];
}

class UserLoadingState extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoadedState extends UserState {
  final MyUser user;

  UserLoadedState({this.user});

  @override
  List<Object> get props => [user];
}

class UserErrorState extends UserState {
  final String message;

  UserErrorState({this.message});

  @override
  List<Object> get props => [message];
}
