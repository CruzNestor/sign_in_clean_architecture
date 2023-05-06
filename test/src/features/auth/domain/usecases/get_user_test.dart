import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:signin_and_signup/src/core/errors/failures.dart';
import 'package:signin_and_signup/src/features/auth/data/models/user_model.dart';
import 'package:signin_and_signup/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:signin_and_signup/src/features/auth/domain/usecases/get_user.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetUser usecase;
  late MockAuthRepository mockAuthRepository;
  late UserModel tUserModel;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    usecase = GetUser(repository: mockAuthRepository);
    tUserModel = UserModel.fromJSON(
      json.decode(fixture('user.json'))
    );
  });

  group('Get user use case', () {
    
    test('should return a model', () async {
      when(() => mockAuthRepository.getUser())
      .thenAnswer((_) async => Right(tUserModel));

      final result = await usecase(NoUserParams());

      expect(result, Right(tUserModel));
      verify(() => mockAuthRepository.getUser());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return failure', () async {
      when(() => mockAuthRepository.getUser())
      .thenAnswer((_) async => const Left(DatabaseFailure('error')));

      final result = await usecase(NoUserParams());

      expect(result, const Left(DatabaseFailure('error')));
      verify(() => mockAuthRepository.getUser());
      verifyNoMoreInteractions(mockAuthRepository);
    });

  });
}