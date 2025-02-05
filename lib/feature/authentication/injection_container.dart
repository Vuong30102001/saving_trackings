import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:saving_trackings_flutter/feature/authentication/data/data_source/firebase_auth_data_source.dart';
import 'package:saving_trackings_flutter/feature/authentication/data/repository/authentication_repository_impl.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_in_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_up_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/presentation/cubit/cubit/authentication_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  //Data source
  sl.registerLazySingleton<FirebaseAuthDataSource>(
      () => FirebaseAuthDataSourceImpl(sl())
  );

  //Repository
  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(sl())
  );

  //use case
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));

  //cubit
  sl.registerFactory(() => AuthenticationCubit(signIn: sl(), signUp: sl()));
}