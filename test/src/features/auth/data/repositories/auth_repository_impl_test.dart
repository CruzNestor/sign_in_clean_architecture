import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:signin_and_signup/src/core/errors/exceptions.dart';
import 'package:signin_and_signup/src/core/errors/failures.dart';
import 'package:signin_and_signup/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:signin_and_signup/src/features/auth/data/models/user_model.dart';
import 'package:signin_and_signup/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:signin_and_signup/src/features/auth/domain/entities/user.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthRepositoryImpl tRepository;
  late MockAuthLocalDataSource mockLocal;
  late MockSharedPreferences mockShared;
  late UserModel tUserModel;
  late String tPassword;

  setUp((){
    mockLocal = MockAuthLocalDataSource();
    mockShared = MockSharedPreferences();
    tRepository = AuthRepositoryImpl(
      local: mockLocal, 
      sharedPreferences: mockShared
    );
    tPassword = '123';
    tUserModel = UserModel.fromJSON(
      json.decode(fixture('user.json'))
    );
  });

  group('Get user', () {
    const tUserId = 1;

    test('should return a model when id is correct', () async {
      when(() => mockShared.getInt('currentUserId'))
      .thenAnswer((_) => tUserId);
      
      when(() => mockLocal.getUser(id: tUserId))
      .thenAnswer((_) async => tUserModel);

      final result = await tRepository.getUser();

      verify(() => mockShared.getInt('currentUserId'));
      verify(() => mockLocal.getUser(id: tUserId));
      expect(result, equals(Right(tUserModel)));
    });

    test('should throw exception when get user is incorrect', () async {
      when(() => mockShared.getInt('currentUserId'))
      .thenThrow(const CustomException(message: 'error'));

      final result = await tRepository.getUser();

      verify(() => mockShared.getInt('currentUserId'));
      expect(result, isA<Left<Failure, User>>());
    });
  });

  group('Sign in', () {
    test('should return true when log in is successfully', () async {
      when(() => mockLocal.signIn(password: tPassword, username: tUserModel.username))
      .thenAnswer((_) async => 1);

      when(() => mockShared.setInt('currentUserId', 1))
      .thenAnswer((_) async => true);

      final result = await tRepository.signIn(password: tPassword, username: tUserModel.username);

      verify(() => mockLocal.signIn(password: tPassword, username: tUserModel.username));
      verify(() => mockShared.setInt('currentUserId', 1));
      expect(result, equals(const Right(true)));
    });

    test('should throw exception when login is unsuccessful', () async {
      when(() => mockLocal.signIn(password: tPassword, username: tUserModel.username))
      .thenThrow(const CustomException(message: 'error'));

      final result = await tRepository.signIn(password: tPassword, username: tUserModel.username);

      verify(() => mockLocal.signIn(password: tPassword, username: tUserModel.username));
      expect(result, isA<Left<Failure, bool>>());
    });
  });

  group('Sign out', () {
    test('should return true when sign out is successfully', () async {
      when(() => mockShared.setBool('isLogged', false))
      .thenAnswer((_) async => true);

      when(() => mockShared.setBool('isLogged', true))
      .thenAnswer((_) async => true);

      final result = await tRepository.signOut();

      verify(() => mockShared.setBool('isLogged', false));
      expect(result, const Right(true));
    });
  });

  group('Sign up', () {
    test('should return true when the register is successfully', () async {
      when(() => mockLocal.signUp(
        email: tUserModel.email,
        password: tPassword, 
        username: tUserModel.username
      )).thenAnswer((_) async => 1);

      when(() => mockShared.setInt('currentUserId', 1))
      .thenAnswer((_) async => true);

      final result = await tRepository.signUp(
        email: tUserModel.email,
        password: tPassword, 
        username: tUserModel.username
      );

      verify(() => mockLocal.signUp(
        email: tUserModel.email,
        password: tPassword, 
        username: tUserModel.username
      ));
      verify(() => mockShared.setInt('currentUserId', 1));
      expect(result, equals(const Right(true)));
    });

    test('should throw exception when the register is unsuccessful', () async {
      when(() => mockLocal.signUp(
        email: tUserModel.email,
        password: tPassword, 
        username: tUserModel.username
      )).thenThrow(const CustomException(message: 'error'));

      final result = await tRepository.signUp(
        email: tUserModel.email,
        password: tPassword, 
        username: tUserModel.username
      );

      verify(() => mockLocal.signUp(
        email: tUserModel.email,
        password: tPassword, 
        username: tUserModel.username
      ));
      expect(result, isA<Left<Failure, bool>>());
    });
  });

  group('ValidateEmail', () {
    test('should return true when the validation is successfully', () async {
      when(() => mockLocal.validateEmail(email: tUserModel.email))
      .thenAnswer((_) async => true);

       final result = await tRepository.validateEmail(email: tUserModel.email);

       verify(() => mockLocal.validateEmail(email: tUserModel.email));
       expect(result, const Right(true));
    });

    test('should throw exception when the validation is unsuccessfully', () async {
      when(() => mockLocal.validateEmail(email: tUserModel.email))
      .thenThrow(const CustomException(message: 'error'));

       final result = await tRepository.validateEmail(email: tUserModel.email);

       verify(() => mockLocal.validateEmail(email: tUserModel.email));
       expect(result, isA<Left<Failure, bool>>());
    });

  });

  group('ValidateUsername', () {
    test('should return true when the validation is successfully', () async {
      when(() => mockLocal.validateUsername(username: tUserModel.email))
      .thenAnswer((_) async => true);

       final result = await tRepository.validateUsername(username: tUserModel.email);

       verify(() => mockLocal.validateUsername(username: tUserModel.email));
       expect(result, const Right(true));
    });

    test('should throw exception when the validation is unsuccessfully', () async {
      when(() => mockLocal.validateUsername(username: tUserModel.email))
      .thenThrow(const CustomException(message: 'error'));

       final result = await tRepository.validateUsername(username: tUserModel.email);

       verify(() => mockLocal.validateUsername(username: tUserModel.email));
       expect(result, isA<Left<Failure, bool>>());
    });

  });
  
}