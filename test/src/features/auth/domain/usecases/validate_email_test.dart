import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:signin_and_signup/src/core/errors/failures.dart';
import 'package:signin_and_signup/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:signin_and_signup/src/features/auth/domain/usecases/validate_email.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ValidateEmail usecase;
  late MockAuthRepository mockAuthRepository;
  late String tEmail;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    usecase = ValidateEmail(repository: mockAuthRepository);
    tEmail = 'example@example.com';
  });

  group('Validate email use case', () {
    
    test('should return true', () async {
      when(() => mockAuthRepository.validateEmail(email: tEmail))
      .thenAnswer((_) async => const Right(true));

      final result = await usecase(tEmail);

      expect(result, const Right(true));
      verify(() => mockAuthRepository.validateEmail(email: tEmail));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return failure', () async {
      when(() => mockAuthRepository.validateEmail(email: tEmail))
      .thenAnswer((_) async => const Left(DatabaseFailure('error')));

      final result = await usecase(tEmail);

      expect(result, const Left(DatabaseFailure('error')));
      verify(() => mockAuthRepository.validateEmail(email: tEmail));
      verifyNoMoreInteractions(mockAuthRepository);
    });

  });

} 