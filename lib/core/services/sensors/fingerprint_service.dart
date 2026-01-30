import 'package:local_auth/local_auth.dart';

class FingerprintService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      if (!canCheck) return false;

      return await _auth.authenticate(
        localizedReason: 'Authenticate using fingerprint',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
