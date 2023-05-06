import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';


class SignUp implements UseCase<bool, FormParams> {
  const SignUp({required this.repository});
  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(FormParams form) async {
    return await repository.signUp(
      email: form.email,
      password: form.password,
      username: form.username
    );
  }
}

class FormParams {
  const FormParams({
    required this.email,
    required this.password,
    required this.username
  });
  final String email;
  final String password;
  final String username;
}