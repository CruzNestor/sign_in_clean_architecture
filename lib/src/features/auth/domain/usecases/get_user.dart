import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';


class GetUser implements UseCase<User, NoUserParams> {
  GetUser({required this.repository});
  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> call(NoUserParams noParams) async {
    return await repository.getUser();
  }
}

class NoUserParams {}