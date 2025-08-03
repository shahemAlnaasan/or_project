import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/features/transfer/presentation/widgets/forms/withdrawl_transfer_form.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class WithdrawlTransferScreen extends StatelessWidget {
  const WithdrawlTransferScreen({super.key});

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
                  LocaleKeys.transfer_withdrawl_transaction.tr(),
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 20),
                WithdrawlTransferForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
