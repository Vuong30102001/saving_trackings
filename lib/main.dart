import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saving_trackings_flutter/core/app_router.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_up_use_case.dart';
import 'feature/authentication/domain/use_case/sign_in_use_case.dart';
import 'feature/authentication/injection_container.dart' as di;
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
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
      )
    );
  }
}
