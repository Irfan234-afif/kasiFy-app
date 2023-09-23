part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoggedInState extends AuthState {}

class AuthLogOutState extends AuthState {}

class AuthErrorState extends AuthState {
  final String msg;

  AuthErrorState(this.msg);
}
