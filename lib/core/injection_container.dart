import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:saving_trackings_flutter/feature/authentication/data/data_source/firebase_auth_data_source.dart';
import 'package:saving_trackings_flutter/feature/authentication/data/repository/authentication_repository_impl.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_in_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_in_with_facebook_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_in_with_google_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_up_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/presentation/cubit/cubit/authentication_cubit.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/data%20source/balance_data_source.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/data%20source/debt_data_source.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/repository/transaction_repository_impl.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/repository/transaction_repository.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/use_case/add_cateogry_use_case.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/use_case/add_transaction_use_case.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/use_case/get_balance_use_case.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/use_case/get_categories_use_case.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/use_case/get_transaction_use_case.dart';

import '../feature/wallet/data/data source/transaction_data_source.dart';
import '../feature/wallet/data/isar_service.dart';
import '../feature/wallet/data/repository/balance_repository_impl.dart';
import '../feature/wallet/data/repository/debt_repository_impl.dart';
import '../feature/wallet/domain/repository/balance_repository.dart';
import '../feature/wallet/domain/repository/debt_repository.dart';

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
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithFacebookUseCase(sl()));

  //cubit
  sl.registerFactory(() => AuthenticationCubit(
      signIn: sl(),
      signUp: sl(),
      signInWithGoogleUseCase: sl(),
      signInWithFacebookUseCase: sl(),
  ));


  //Isar Service
  sl.registerLazySingleton<IsarService>(() => IsarService());

  //Wallet DataSource
  sl.registerLazySingleton<TransactionDataSource>(
        () => TransactionDataSourceImpl(sl<IsarService>(), sl<BalanceDataSource>()),
  );

  sl.registerLazySingleton<BalanceDataSource>(
          () => BalanceDataSourceImpl(sl())
  );
  sl.registerLazySingleton<DebtDataSource>(
          () => DebtDataSourceImpl(sl())
  );

  //Wallet Repository
  sl.registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(sl())
  );
  sl.registerLazySingleton<BalanceRepository>(
          () => BalanceRepositoryImpl(sl()));
  sl.registerLazySingleton<DebtRepository>(
          () => DebtRepositoryImpl(sl()));

  //Wallet use case
  sl.registerLazySingleton(() => AddTransactionUseCase(
      transactionRepository: sl(),
      balanceRepository: sl(),
      debtRepository: sl()
  ));
  sl.registerLazySingleton(() => GetTransactionUseCase(
      transactionRepository: sl(),
  ));
  sl.registerLazySingleton(() => GetBalanceUseCase(
      balanceRepository: sl(),
  ));
  sl.registerLazySingleton(() => AddCategoryUseCase(
    transactionRepository: sl()
  ));
  sl.registerLazySingleton(() => GetCategoriesUseCase(
      transactionRepository: sl(),
  ));
}