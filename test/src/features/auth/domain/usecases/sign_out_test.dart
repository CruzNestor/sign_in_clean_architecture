import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:signin_and_signup/src/core/errors/failures.dart';
import 'package:signin_and_signup/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:signin_and_signup/src/features/auth/domain/usecases/sign_out.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignOut usecase;
  late MockAuthRepository mockAuthRepository;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    usecase = SignOut(repository: mockAuthRepository);
  });

  group('Sign out use case', () {
    
    test('should return true', () async {
      when(() => mockAuthRepository.signOut())
      .thenAnswer((_) async => const Right(true));

      final result = await usecase(NoParams());

      expect(result, const Right(true));
      verify(() => mockAuthRepository.signOut());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return failure', () async {
      when(() => mockAuthRepository.signOut())
      .thenAnswer((_) async => const Left(DatabaseFailure('error')));

      final result = await usecase(NoParams());

      expect(result, const Left(DatabaseFailure('error')));
      verify(() => mockAuthRepository.signOut());
      verifyNoMoreInteractions(mockAuthRepository);
    });

  });
} 