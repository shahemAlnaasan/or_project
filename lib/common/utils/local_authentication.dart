import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

@injectable
class BiometricHelper {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticateWithBiometrics() async {
    try {
      bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      log("PlatformException: $e");
      return false;
    }
  }
}
