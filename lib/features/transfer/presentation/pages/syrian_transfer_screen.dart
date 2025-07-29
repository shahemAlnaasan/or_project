import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/size_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../widgets/exchange_table.dart';
import '../widgets/forms/syrian_transfer_form.dart';
import '../../../../generated/locale_keys.g.dart';

class SyrianTransferScreen extends StatelessWidget {
  const SyrianTransferScreen({super.key});

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
                LocaleKeys.home_syrian_transfer.tr(),
                textAlign: TextAlign.start,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              SyrianTransferForm(),
              ExchangeTable(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
