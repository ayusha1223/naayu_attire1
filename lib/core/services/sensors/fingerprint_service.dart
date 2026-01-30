import 'package:local_auth/local_auth.dart';

class FingerprintService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final isAvailable = await _auth.canCheckBiometrics;
      if (!isAvailable) return false;

      return await _auth.authenticate(
        localizedReason: 'Verify fingerprint to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
