import 'package:go_router/go_router.dart';
import 'package:saving_trackings_flutter/feature/authentication/presentation/screen/sign_in_screen.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/screen/add_transaction_screen.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/screen/wallet_screen.dart';

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
    ),
    GoRoute(
      path: '/addTransactionScreen',
      builder: (context, state) => const AddTransactionScreen()
    ),
    GoRoute(
        path: '/walletScreen',
        builder: (context, state) => const WalletScreen()
    ),
  ]
);