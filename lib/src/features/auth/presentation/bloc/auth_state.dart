part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();  

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticating extends AuthState {}

class Authenticated extends AuthState {}

class AuthenticationFailure extends AuthState {
  const AuthenticationFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

class LoadingUser extends AuthState {}

class Unauthenticated extends AuthState {}

class UserData extends AuthState {
  const UserData({required this.user});
  final User user;
}

class ValidEmail extends AuthState {}

class ValidUsername extends AuthState {}
