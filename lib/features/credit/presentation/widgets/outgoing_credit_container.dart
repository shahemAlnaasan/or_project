import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_action_button.dart';
import 'package:golder_octopus/features/credit/data/models/outgoing_credits_response.dart';
import 'package:golder_octopus/features/credit/presentation/widgets/outgoing_credit_details_dialog.dart';
import 'package:golder_octopus/generated/assets.gen.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class OutgoingCreditContainer extends StatelessWidget {
  final OutgoingCreditResponse outgoingCreditsResponse;
  const OutgoingCreditContainer({super.key, required this.outgoingCreditsResponse});

  void _showDetailsDialog(BuildContext context, {required OutgoingCreditResponse outgoingCreditsResponse}) {
    showDialog(
      context: context,
      builder: (context) {
        return OutgoingCreditDetailsDialog(outgoingCreditsResponse: outgoingCreditsResponse);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsDialog(context, outgoingCreditsResponse: outgoingCreditsResponse),
      child: Container(
        decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          spacing: 20,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: AppText.bodyMedium(
                      "ادلب - ابراهيم كللي",
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.bold,
                      color: context.onPrimaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      AppText.bodyMedium("7", textAlign: TextAlign.center, fontWeight: FontWeight.bold),
                      const SizedBox(height: 3),
                      AppText.bodyMedium(
                        LocaleKeys.home_dolar.tr(),
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      Image.asset(Assets.images.flags.unitedStates.path, scale: 5, alignment: Alignment.bottomCenter),
                    ],
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 8,
              children: [
                Expanded(
                  child: CustomActionButton(onPressed: () {}, text: "اشعار", backgroundColor: context.primaryContainer),
                ),

                Expanded(
                  child: CustomActionButton(
                    onPressed: () => _showDetailsDialog(context, outgoingCreditsResponse: outgoingCreditsResponse),
                    text: "تفاصيل",
                    backgroundColor: context.primaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
