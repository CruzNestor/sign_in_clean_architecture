import 'package:equatable/equatable.dart';

class User extends Equatable{
  const User({
    required this.email,
    required this.id,
    required this.username,
  });
  final String email;
  final int id;
  final String username;
  
  @override
  List<Object?> get props => [email, id, username];
}