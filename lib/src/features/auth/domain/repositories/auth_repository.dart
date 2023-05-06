import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';


abstract class AuthRepository {
  Future<Either<Failure, User>> getUser();

  Future<Either<Failure, bool>> signIn({
    required String password,
    required String username 
  });

  Future<Either<Failure, bool>> signOut();

  Future<Either<Failure, bool>> signUp({
    required String email, 
    required String password,
    required String username 
  });

  Future<Either<Failure, bool>> validateEmail({required String email});

  Future<Either<Failure, bool>> validateUsername({required String username});
}