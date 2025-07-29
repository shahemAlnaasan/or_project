import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/size_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../widgets/forms/centers_posts_form.dart';
import '../../../../generated/locale_keys.g.dart';

class CentersPostsScreen extends StatelessWidget {
  const CentersPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 75),
          width: context.screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.displaySmall(
                LocaleKeys.posts_posts.tr(),
                textAlign: TextAlign.start,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              AppText.bodyLarge(
                LocaleKeys.posts_new_post.tr(),
                textAlign: TextAlign.start,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              CentersPostsForm(),
            ],
          ),
        ),
      ),
    );
  }
}
