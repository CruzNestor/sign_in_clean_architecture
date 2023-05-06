import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/core/datasources/app_database.dart';
import 'src/features/auth/data/datasources/auth_database.dart';
import 'src/features/auth/data/datasources/auth_local_data_source.dart';
import 'src/features/auth/data/repositories/auth_repository_impl.dart';
import 'src/features/auth/domain/repositories/auth_repository.dart';
import 'src/features/auth/domain/usecases/get_user.dart';
import 'src/features/auth/domain/usecases/sign_in.dart';
import 'src/features/auth/domain/usecases/sign_out.dart';
import 'src/features/auth/domain/usecases/sign_up.dart';
import 'src/features/auth/domain/usecases/validate_email.dart';
import 'src/features/auth/domain/usecases/validate_username.dart';
import 'src/features/auth/presentation/bloc/auth_bloc.dart';


final GetIt sl = GetIt.instance;

Future<void> init() async {
  initExternal();
  initCore();
  initAuthFeature();
}

void initExternal() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(
    () => sharedPreferences
  );
}

void initCore() async {
  sl.registerLazySingleton(() => AppDatabase());
}

void initAuthFeature(){
  //* Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      getUserUseCase: sl(),
      signInUseCase: sl(),
      signOutUseCase: sl(),
      signUpUseCase: sl(),
      validateEmailUseCase: sl(),
      validateUsernameUseCase: sl(),
    )
  );

  // Use cases
  sl.registerLazySingleton(
    () => GetUser(repository: sl())
  );
  sl.registerLazySingleton(
    () => SignIn(repository: sl())
  );
  sl.registerLazySingleton(
    () => SignOut(repository: sl())
  );
  sl.registerLazySingleton(
    () => SignUp(repository: sl())
  );
  sl.registerLazySingleton(
    () => ValidateEmail(repository: sl())
  );
  sl.registerLazySingleton(
    () => ValidateUsername(repository: sl())
  );

  // Respository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      local: sl(),
      sharedPreferences: sl()
    )
  );

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(database: sl())
  );
  
  sl.registerLazySingleton<AuthDatabase>(
    () => AuthDatabaseImpl()
  );
}