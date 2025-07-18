import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/features/transfer/presentation/widgets/forms/reserved_transfer_form.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class ReserevedTransferScreen extends StatelessWidget {
  const ReserevedTransferScreen({super.key});

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
                LocaleKeys.transfer_reserved_transfer.tr(),
                textAlign: TextAlign.start,
                fontWeight: FontWeight.bold,
                color: context.onPrimaryColor,
              ),
              AppText.bodyMedium(
                LocaleKeys.transfer_please_contact_center.tr(),
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              ReservedTransferForm(),
            ],
          ),
        ),
      ),
    );
  }
}
