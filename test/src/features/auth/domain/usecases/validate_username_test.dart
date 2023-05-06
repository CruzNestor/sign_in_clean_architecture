import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:signin_and_signup/src/core/errors/failures.dart';
import 'package:signin_and_signup/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:signin_and_signup/src/features/auth/domain/usecases/validate_username.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ValidateUsername usecase;
  late MockAuthRepository mockAuthRepository;
  late String tUsername;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    usecase = ValidateUsername(repository: mockAuthRepository);
    tUsername = 'pepito84';
  });

  group('Validate email use case', () {
    
    test('should return true', () async {
      when(() => mockAuthRepository.validateUsername(username: tUsername))
      .thenAnswer((_) async => const Right(true));

      final result = await usecase(tUsername);

      expect(result, const Right(true));
      verify(() => mockAuthRepository.validateUsername(username: tUsername));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return failure', () async {
      when(() => mockAuthRepository.validateUsername(username: tUsername))
      .thenAnswer((_) async => const Left(DatabaseFailure('error')));

      final result = await usecase(tUsername);

      expect(result, const Left(DatabaseFailure('error')));
      verify(() => mockAuthRepository.validateUsername(username: tUsername));
      verifyNoMoreInteractions(mockAuthRepository);
    });

  });
  
} 