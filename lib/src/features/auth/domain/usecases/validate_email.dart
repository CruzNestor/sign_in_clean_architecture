import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';


class ValidateEmail implements UseCase<bool, String> {
  const ValidateEmail({required this.repository});
  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(String email) async {
    return await repository.validateEmail(email: email);
  }
}