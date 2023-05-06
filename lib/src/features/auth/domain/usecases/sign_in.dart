import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';


class SignIn implements UseCase<bool, Credentials> {
  SignIn({required this.repository});
  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(Credentials credentials) async {
    return await repository.signIn(
      password: credentials.password,
      username: credentials.username
    );
  }
}

class Credentials {
  const Credentials({required this.password, required this.username});
  final String password;
  final String username;
}