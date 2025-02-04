import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:saving_trackings_flutter/feature/authentication/data/data_source/firebase_auth_data_source.dart';
import 'package:saving_trackings_flutter/feature/authentication/data/repository/authentication_repository_impl.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_in_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_up_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/presentation/cubit/cubit/authentication_cubit.dart';

final s1 = GetIt.instance;

Future<void> init() async {
  //Firebase
  s1.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  //Data source
  s1.registerLazySingleton<FirebaseAuthDataSource>(
      () => FirebaseAuthDataSourceImpl(s1())
  );

  //Repository
  s1.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(s1())
  );

  //use case
  s1.registerLazySingleton(() => SignInUseCase(s1()));
  s1.registerLazySingleton(() => SignUpUseCase(s1()));

  //cubit
  s1.registerFactory(() => AuthenticationCubit(signIn: s1(), signUp: s1()));
}