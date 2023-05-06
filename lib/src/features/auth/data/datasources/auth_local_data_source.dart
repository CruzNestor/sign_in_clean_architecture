import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

import 'auth_database.dart';


abstract class AuthLocalDataSource {
  Future<UserModel> getUser({required int id});
  Future<int> signIn({
    required String username, 
    required String password
  });
  Future<int> signUp({
    required String email, 
    required String username, 
    required String password
  });
  Future<bool> validateEmail({required String email});
  Future<bool> validateUsername({required String username});
}


class AuthLocalDataSourceImpl implements AuthLocalDataSource {

  const AuthLocalDataSourceImpl({required this.database});
  final AuthDatabase database;

  @override
  Future<UserModel> getUser({required int id}) async {
    final response = await database.getUser(id: id);
    if (response['status'] == 'success') {
      return UserModel.fromJSON(response['data']);
    }
    throw CustomException(message: response['detail']);
  }

  @override
  Future<int> signIn({required String username, required String password}) async {
    final response = await database.signIn(
      data: {'username': username, 'password': password}
    );
    if (response['status'] == 'success') {
      return response['user_id'];
    }
    throw CustomException(message: response['detail']);
  }
  
  @override
  Future<int> signUp({required String email, required String username, required String password}) async {
    final response = await database.signUp(
      data: {'email': email, 'username': username, 'password': password}
    );
    if (response['status'] == 'success') {
      return response['inserted_id'];
    }
    throw CustomException(message: response['detail']);
  }
  
  @override
  Future<bool> validateEmail({required String email}) async {
    final response = await database.validateEmail(data: {'email': email});
    if (response['status'] == 'success') {
      return true;
    }
    throw CustomException(message: response['detail']);
  }
  
  @override
  Future<bool> validateUsername({required String username}) async {
    final response = await database.validateUsername(
      data: {'username': username}
    );
    if (response['status'] == 'success') {
      return true;
    }
    throw CustomException(message: response['detail']);
  }
  
}