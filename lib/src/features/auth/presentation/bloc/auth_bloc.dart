import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/validate_email.dart';
import '../../domain/usecases/validate_username.dart';

part 'auth_event.dart';
part 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetUser getUserUseCase;
  final SignIn signInUseCase;
  final SignOut signOutUseCase;
  final SignUp signUpUseCase;
  final ValidateEmail validateEmailUseCase;
  final ValidateUsername validateUsernameUseCase;

  AuthBloc({
    required this.getUserUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.signUpUseCase,
    required this.validateEmailUseCase,
    required this.validateUsernameUseCase
  }) : super(AuthInitial()) {

    on<GetUserEvent>((event, emit) async {
      emit(LoadingUser());
      final result = await getUserUseCase(NoUserParams());
      result.fold(
        (failure) => emit(Unauthenticated()),
        (data) => emit(UserData(user: data))
      );
    });

    on<SignInEvent>((event, emit) async {
      emit(Authenticating());
      final result = await signInUseCase(
        Credentials(
          password: event.password,
          username: event.username 
        )
      );
      result.fold(
        (failure) => emit(AuthenticationFailure(failure.message)),
        (data) => emit(Authenticated())
      );
    });

    on<SignOutEvent>((event, emit) async {
      emit(Authenticating());
      final result = await signOutUseCase(NoParams());
      result.fold(
        (failure) => emit(AuthenticationFailure(failure.message)),
        (data) => emit(Unauthenticated())
      );
    });

    on<SignUpEvent>((event, emit) async {
      emit(Authenticating());
      final result = await signUpUseCase(
        FormParams(
          email: event.email, 
          username: event.username, 
          password: event.password
        )
      );
      result.fold(
        (failure) => emit(AuthenticationFailure(failure.message)),
        (data) => emit(Authenticated())
      );
    });

    on<ValidateEmailEvent>((event, emit) async {
      emit(Authenticating());
      final result = await validateEmailUseCase(event.email);
      result.fold(
        (failure) => emit(AuthenticationFailure(failure.message)),
        (data) => emit(ValidEmail())
      );
    });

    on<ValidateUsernameEvent>((event, emit) async {
      emit(Authenticating());
      final result = await validateUsernameUseCase(event.username);
      result.fold(
        (failure) => emit(AuthenticationFailure(failure.message)),
        (data) => emit(ValidUsername())
      );
    });
  }
}
