import 'package:flutter/material.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/size_extension.dart';
import '../widgets/verify_Login_form.dart';
import '../../../../generated/assets.gen.dart';

class VerifyLoginScreen extends StatelessWidget {
  const VerifyLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.screenHeight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.images.logo.companyLogo.path, scale: 6),
                SizedBox(height: 20),
                VerifyLoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
