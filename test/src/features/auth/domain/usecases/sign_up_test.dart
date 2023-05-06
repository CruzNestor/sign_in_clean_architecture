import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:signin_and_signup/src/core/errors/failures.dart';
import 'package:signin_and_signup/src/features/auth/data/models/user_model.dart';
import 'package:signin_and_signup/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:signin_and_signup/src/features/auth/domain/usecases/sign_up.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignUp usecase;
  late MockAuthRepository mockAuthRepository;
  late String tPassword;
  late UserModel tUserModel;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    usecase = SignUp(repository: mockAuthRepository);
    tPassword = '123';
    tUserModel = UserModel.fromJSON(
      json.decode(fixture('user.json'))
    );
  });

  group('Sign up use case', () {

    test('should return true', () async {
      when(() => mockAuthRepository.signUp(
        email: tUserModel.email,
        password: tPassword, 
        username: tUserModel.username
      )).thenAnswer((_) async => const Right(true));
      
      final result = await usecase(FormParams(
        email: tUserModel.email, 
        password: tPassword,
        username: tUserModel.username
      ));

      expect(result, const Right(true));
      verify(() => mockAuthRepository.signUp(
        email: tUserModel.email,
        password: tPassword, 
        username: tUserModel.username
      ));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('Should return failure', () async {
      when(() => mockAuthRepository.signUp(
        email: tUserModel.email,
        password: tPassword, 
        username: tUserModel.username
      )).thenAnswer((_) async => const Left(DatabaseFailure('error')));

      final result = await usecase(FormParams(
        email: tUserModel.email, 
        password: tPassword,
        username: tUserModel.username
      ));

      expect(result, const Left(DatabaseFailure('error')));
      verify(() => mockAuthRepository.signUp(
        email: tUserModel.email,
        password: tPassword, 
        username: tUserModel.username
      ));
      verifyNoMoreInteractions(mockAuthRepository);
    });

  });
} 