import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/features/exchange/presentation/widgets/exchange_container.dart';
import 'package:golder_octopus/features/home/presentation/widgets/shear_bond_form.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class ShearBondScreen extends StatelessWidget {
  const ShearBondScreen({super.key});

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
                LocaleKeys.home_shear_bond.tr(),
                textAlign: TextAlign.start,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              ShearBondForm(),
              SizedBox(height: 20),
              AppText.displaySmall(
                LocaleKeys.home_shear_bond.tr(),
                textAlign: TextAlign.start,
                fontWeight: FontWeight.bold,
              ),

              ExchangeContainer(),
            ],
          ),
        ),
      ),
    );
  }
}
