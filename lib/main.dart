import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:saving_trackings_flutter/core/app_router.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_up_use_case.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/use_case/add_transaction_use_case.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/use_case/get_balance_use_case.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/use_case/get_transaction_use_case.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/cubit/cubit/wallet_cubit.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/screen/wallet_screen.dart';
import 'feature/authentication/domain/use_case/sign_in_use_case.dart';
import 'core/injection_container.dart' as di;
import 'feature/authentication/presentation/cubit/cubit/authentication_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init(); // Đảm bảo `di.init()` khởi tạo đầy đủ các dependencies.

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child){
        return MultiProvider(
            providers: [

              Provider<SignInUseCase>(
                create: (_) => di.sl<SignInUseCase>(), // Lấy từ Service Locator
              ),
              Provider<SignUpUseCase>(
                create: (_) => di.sl<SignUpUseCase>(), // Lấy từ Service Locator
              ),
              Provider<AuthenticationCubit>(
                create: (context) => AuthenticationCubit(signIn: context.read<SignInUseCase>(), signUp: context.read<SignUpUseCase>()),
              ),


              Provider<AddTransactionUseCase>(
                create: (_) => di.sl<AddTransactionUseCase>(),
              ),
              Provider<GetTransactionUseCase>(
                create: (_) => di.sl<GetTransactionUseCase>(),
              ),
              Provider<GetBalanceUseCase>(
                create: (_) => di.sl<GetBalanceUseCase>(),
              ),
              BlocProvider<WalletCubit>(
                create: (context) => WalletCubit(
                    addTransactionUseCase: context.read<AddTransactionUseCase>(),
                    getTransactionUseCase: context.read<GetTransactionUseCase>(),
                    getBalanceUseCase: context.read<GetBalanceUseCase>()
                ),
                child: WalletScreen(),
              )
            ],
            child: MaterialApp.router(
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Colors.blue,
              ),
            )
        );
      },
    );
  }
}
