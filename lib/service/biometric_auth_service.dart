import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> hasBiometrics() async {
    final isAvailable = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  Future<bool> authenticate() async {
    final isAuthAvailable = await hasBiometrics();
    if (!isAuthAvailable) return false;
    try {
      return await _auth.authenticate(
          localizedReason: 'Touch your finger on the sensor to login');
    } catch (e) {
      return false;
    }
  }

}
