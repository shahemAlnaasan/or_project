import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/size_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../widgets/login_form.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locale_keys.g.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.images.logo.companyLogo.path, scale: 6),
                SizedBox(height: 20),
                AppText.headlineMedium(
                  LocaleKeys.auth_welcome_to_golden_octopus.tr(),
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 20),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
