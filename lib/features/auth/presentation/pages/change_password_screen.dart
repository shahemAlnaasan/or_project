import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/size_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../widgets/change_password_form.dart';
import '../../../../generated/locale_keys.g.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.screenHeight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.headlineMedium(
                  LocaleKeys.auth_change_password.tr(),
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 20),
                ChangePasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
