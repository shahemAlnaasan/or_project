import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/generated/assets.gen.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class NewsContainer extends StatelessWidget {
  const NewsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Assets.images.logo.companyLogo.image(width: 90, height: 90)),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.headlineMedium(
                      LocaleKeys.auth_change_password.tr(),
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w500,
                    ),
                    AppText.bodyMedium(
                      LocaleKeys.auth_change_password.tr(),
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(color: context.onPrimaryColor.withAlpha(50)),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: AppText.headlineMedium(
              LocaleKeys.auth_change_password.tr(),
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
