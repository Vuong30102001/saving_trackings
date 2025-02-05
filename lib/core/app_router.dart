import 'package:go_router/go_router.dart';
import 'package:saving_trackings_flutter/feature/authentication/presentation/screen/sign_in_screen.dart';

import '../home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/signIn',
  routes: [
    GoRoute(
      path: '/signIn',
      builder: (context, state) => const SignInScreen()
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    )
  ]
);