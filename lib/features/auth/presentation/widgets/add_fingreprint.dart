import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/utils/local_authentication.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/core/di/injection.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class AddFingreprint extends StatelessWidget {
  const AddFingreprint({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final BiometricHelper biometricHelper = getIt<BiometricHelper>();
        await biometricHelper.authenticateWithBiometrics();
      },
      child: Container(
        width: 150,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(color: context.primaryContainer, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fingerprint_rounded, color: Colors.black, size: 30),
              AppText.bodySmall(
                LocaleKeys.auth_add_fingerprint.tr(),
                textAlign: TextAlign.center,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
