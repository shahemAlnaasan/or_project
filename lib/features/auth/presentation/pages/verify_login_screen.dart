import 'package:flutter/material.dart';
import 'package:golder_octopus/core/config/app_config.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/size_extension.dart';
import '../widgets/forms/verify_Login_form.dart';

class VerifyLoginScreen extends StatelessWidget {
  const VerifyLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: SizedBox(
        height: context.screenHeight,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: context.screenHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      AppConfig.logoUrl,
                      width: 110,
                      height: 110,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 20),
                    const VerifyLoginForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
