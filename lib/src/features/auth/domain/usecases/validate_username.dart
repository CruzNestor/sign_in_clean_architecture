import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';


class ValidateUsername implements UseCase<bool, String> {
  const ValidateUsername({required this.repository});
  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(String username) async {
    return await repository.validateUsername(username: username);
  }
}