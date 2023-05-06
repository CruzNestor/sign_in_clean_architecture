part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class GetUserEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  const SignInEvent({required this.password, required this.username});
  final String password;
  final String username;
}

class SignOutEvent extends AuthEvent {}

class SignUpEvent extends AuthEvent {
  const SignUpEvent({
    required this.email,
    required this.password,
    required this.username 
  });
  final String email;
  final String password;
  final String username;
}

class ValidateEmailEvent extends AuthEvent {
  const ValidateEmailEvent({required this.email});
  final String email;
}

class ValidateUsernameEvent extends AuthEvent {
  const ValidateUsernameEvent({required this.username});
  final String username;
}