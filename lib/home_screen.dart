import 'package:flutter/material.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/screen/wallet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const WalletScreen()
    );
  }
}
