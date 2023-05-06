import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

typedef FBoolType = Future<bool> Function();

class AuthRepositoryImpl implements AuthRepository {

  const AuthRepositoryImpl({
    required this.local,
    required this.sharedPreferences
  });

  final AuthLocalDataSource local;
  final SharedPreferences sharedPreferences;

  @override
  Future<Either<Failure, User>> getUser() async {
    try {
      int? id = sharedPreferences.getInt('currentUserId');
      final data = await local.getUser(id: id!);
      
      return Right(data);
    } on CustomException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> signIn({required String username, required String password}) async {
    try {
      final data = await local.signIn(username: username, password: password);
      await sharedPreferences.setInt('currentUserId', data);
      return const Right(true);
    } on CustomException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      await sharedPreferences.setInt('currentUserId', 0);
      return const Right(true);
    } catch (e) {
      return Left(SharedPreferencesFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> signUp({required String email, required String username, required String password}) async {
    try {
      final data = await local.signUp(email: email, username: username, password: password);
      await sharedPreferences.setInt('currentUserId', data);
      return const Right(true);
    } on CustomException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> validateEmail({required String email}) async {
    return await validate(() => local.validateEmail(email: email));
  }

  @override
  Future<Either<Failure, bool>> validateUsername({required String username}) async {
    return await validate(() => local.validateUsername(username: username));
  }

  Future<Either<Failure, bool>> validate(FBoolType call) async {
    try {
      final data = await call();
      return Right(data);
    } on CustomException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

}