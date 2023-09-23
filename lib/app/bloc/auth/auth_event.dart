part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthSignUpEvent extends AuthEvent {
  final String name, email, password, shopName;

  AuthSignUpEvent({
    required this.name,
    required this.shopName,
    required this.email,
    required this.password,
  });
}

class AuthSignInEvent extends AuthEvent {
  final String email, password;

  AuthSignInEvent({
    required this.email,
    required this.password,
  });
}

class AuthSignOutEvent extends AuthEvent {
  final String token;

  AuthSignOutEvent({required this.token});
}
