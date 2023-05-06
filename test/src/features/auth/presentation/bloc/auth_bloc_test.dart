import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:signin_and_signup/src/features/auth/data/models/user_model.dart';
import 'package:signin_and_signup/src/features/auth/domain/usecases/get_user.dart';
import 'package:signin_and_signup/src/features/auth/domain/usecases/sign_in.dart';
import 'package:signin_and_signup/src/features/auth/domain/usecases/sign_out.dart';
import 'package:signin_and_signup/src/features/auth/domain/usecases/sign_up.dart';
import 'package:signin_and_signup/src/features/auth/domain/usecases/validate_email.dart';
import 'package:signin_and_signup/src/features/auth/domain/usecases/validate_username.dart';
import 'package:signin_and_signup/src/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockGetUser extends Mock implements GetUser {}
class MockSignIn extends Mock implements SignIn {}
class MockSignOut extends Mock implements SignOut {}
class MockSignUp extends Mock implements SignUp {}
class MockValidateEmail extends Mock implements ValidateEmail {}
class MockValidateUsername extends Mock implements ValidateUsername {}

void main() {
  late MockGetUser mockGetUserUseCase;
  late MockSignIn mockSignInUseCase;
  late MockSignOut mockSignOutUseCase;
  late MockSignUp mockSignUpUseCase;
  late MockValidateEmail mockValidateEmailUseCase;
  late MockValidateUsername mockValidateUsernameUseCase;
  late AuthBloc tAuthBloc;
  late String tPassword;
  late UserModel tUserModel;

  setUpAll((){
    mockGetUserUseCase = MockGetUser();
    mockSignInUseCase = MockSignIn();
    mockSignOutUseCase = MockSignOut();
    mockSignUpUseCase = MockSignUp();
    mockValidateEmailUseCase = MockValidateEmail();
    mockValidateUsernameUseCase = MockValidateUsername();

    tAuthBloc = AuthBloc(
      getUserUseCase: mockGetUserUseCase,
      signInUseCase: mockSignInUseCase,
      signOutUseCase: mockSignOutUseCase,
      signUpUseCase: mockSignUpUseCase,
      validateEmailUseCase: mockValidateEmailUseCase,
      validateUsernameUseCase: mockValidateUsernameUseCase
    );

    tPassword = '123';
    tUserModel = UserModel.fromJSON(
      json.decode(fixture('user.json'))
    );

    registerFallbackValue(Credentials(
      password: tPassword, 
      username: tUserModel.username
    ));
    
    registerFallbackValue(FormParams(
      email: tUserModel.email, 
      password: tPassword, 
      username: tUserModel.username,
    ));

    registerFallbackValue(NoParams());

    registerFallbackValue(NoUserParams());
    
  });

  group('AuthBloc', () {
    
    test('the initial state should be AuthInitial', () => {
      expect(tAuthBloc.state, equals(AuthInitial()))
    });

    blocTest<AuthBloc, AuthState>(
      'GetUserEvent should emit loading state and user data state',
      build: () {
        when(() => mockGetUserUseCase(any<NoUserParams>()))
        .thenAnswer((_) async => Right(tUserModel));
        return tAuthBloc;
      },
      act: (bloc) => bloc.add(GetUserEvent()),
      expect: () => [isA<LoadingUser>(), isA<UserData>()],
    );

    blocTest<AuthBloc, AuthState>(
      'SignInEvent should emit authenticating state and authenticated state',
      build: () {
        when(() => mockSignInUseCase(any<Credentials>()))
        .thenAnswer((_) async => const Right(true));
        return tAuthBloc;
      },
      act: (bloc) => bloc.add(SignInEvent(password: tPassword, username: tUserModel.username)),
      expect: () => [isA<Authenticating>(), isA<Authenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'Sign out should emit authenticating state and unauthenticated state',
      build: () {
        when(() => mockSignOutUseCase.call(any<NoParams>()))
        .thenAnswer((_) async => const Right(true));
        return tAuthBloc; 
      },
      act: (bloc) => bloc.add(SignOutEvent()),
      expect: () => [isA<Authenticating>(), isA<Unauthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'sign up event should emit authenticating state and authenticated state',
      build: () {
        when(() => mockSignUpUseCase(any<FormParams>()))
        .thenAnswer((_) async => const Right(true));
        return tAuthBloc; 
      },
      act: (bloc) => bloc.add(SignUpEvent(
        email: tUserModel.email,
        password: tPassword,
        username: tUserModel.username
      )),
      expect: () => [isA<Authenticating>(), isA<Authenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit authenticating state and valid email state',
      build: () {
        when(() => mockValidateEmailUseCase(tUserModel.email))
        .thenAnswer((_) async => const Right(true));
        return tAuthBloc; 
      },
      act: (bloc) => bloc.add(ValidateEmailEvent(email: tUserModel.email)),
      expect: () => [isA<Authenticating>(), isA<ValidEmail>()],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit authenticating state and valid username state',
      build: () {
        when(() => mockValidateUsernameUseCase(tUserModel.username))
        .thenAnswer((_) async => const Right(true));
        return tAuthBloc; 
      },
      act: (bloc) => bloc.add(ValidateUsernameEvent(username: tUserModel.username)),
      expect: () => [isA<Authenticating>(), isA<ValidUsername>()],
    );

  });
}