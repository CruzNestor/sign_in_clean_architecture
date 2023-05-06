import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:signin_and_signup/src/core/errors/failures.dart';
import 'package:signin_and_signup/src/features/auth/data/models/user_model.dart';
import 'package:signin_and_signup/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:signin_and_signup/src/features/auth/domain/usecases/sign_in.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignIn usecase;
  late MockAuthRepository mockAuthRepository;
  late String tPassword;
  late UserModel tUserModel;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    usecase = SignIn(repository: mockAuthRepository);
    tPassword = '123';
    tUserModel = UserModel.fromJSON(
      json.decode(fixture('user.json'))
    );
  });

  group('Sign in use case', () {
    
    test('should return true', () async {
      when(() => mockAuthRepository.signIn(password: tPassword, username: tUserModel.email))
      .thenAnswer((_) async => const Right(true));

      final result = await usecase(Credentials(
        password: tPassword,
        username: tUserModel.email
      ));

      expect(result, const Right(true));
      verify(() => mockAuthRepository.signIn(password: tPassword, username: tUserModel.email));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return failure', () async {
      when(() => mockAuthRepository.signIn(password: tPassword, username: tUserModel.email))
      .thenAnswer((_) async => const Left(DatabaseFailure('error')));

      final result = await usecase(Credentials(
        password: tPassword,
        username: tUserModel.email
      ));

      expect(result, const Left(DatabaseFailure('error')));
      verify(() => mockAuthRepository.signIn(password: tPassword, username: tUserModel.email));
      verifyNoMoreInteractions(mockAuthRepository);
    });

  });
}