import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;

  Future<void> _authenticate() async {
    try {
      print('Bắt đầu kiểm tra sinh trắc học...');
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      print('canCheckBiometrics: $canCheckBiometrics');
      bool isBiometricSupported = await auth.isDeviceSupported();
      print('isBiometricSupported: $isBiometricSupported');

      if (!canCheckBiometrics || !isBiometricSupported) {
        print('Thiết bị không hỗ trợ sinh trắc học');
        setState(() {
          _isAuthenticated = false;
        });
        return;
      }

      List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
      print('availableBiometrics: $availableBiometrics');

      if (availableBiometrics.contains(BiometricType.fingerprint) || availableBiometrics.contains(BiometricType.strong)) {
        print('Bắt đầu xác thực vân tay...');
        bool isAuthenticated = await auth.authenticate(
          localizedReason: 'Xác thực vân tay để mở ứng dụng',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
        print('isAuthenticated: $isAuthenticated');
        setState(() {
          _isAuthenticated = isAuthenticated;
        });
      } else {
        print('Thiết bị không hỗ trợ vân tay');
        setState(() {
          _isAuthenticated = false;
        });
      }
    } catch (e) {
      print('Lỗi xác thực: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác thực vân tay'),
      ),
      body: Center(
        child: _isAuthenticated
            ? const Text('Xác thực thành công!')
            : const Text('Xác thực thất bại!'),
      ),
    );
  }
}
