import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/features/news/presentation/widgets/news_container.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/size_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../generated/locale_keys.g.dart';

class CompanyNewsScreen extends StatelessWidget {
  const CompanyNewsScreen({super.key});

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
                  LocaleKeys.posts_news.tr(),
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 20),
                NewsContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
