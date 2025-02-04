import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saving_trackings_flutter/feature/authentication/presentation/screen/sign_in_screen.dart';
import 'feature/authentication/injection_container.dart' as di;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInScreen(),
    );
  }
}
