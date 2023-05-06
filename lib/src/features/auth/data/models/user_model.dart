import 'package:signin_and_signup/src/features/auth/domain/entities/user.dart';


class UserModel extends User {
  const UserModel({
    required String email,
    required int id, 
    required String username
  }): super(email: email, id: id, username: username);

  factory UserModel.fromJSON(dynamic json) {
    return UserModel(
      email: json['email'],
      id: json['id'],
      username: json['username'],
    );
  }
}