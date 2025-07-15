import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_action_button.dart';
import 'package:golder_octopus/features/credit/data/models/outgoing_credits_response.dart';
import 'package:golder_octopus/features/credit/presentation/widgets/outgoing_credit_details_dialog.dart';
import 'package:golder_octopus/generated/assets.gen.dart';

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

  String? getIcon(String currencyName) {
    switch (currencyName) {
      case 'يورو':
        return Assets.images.flags.europe.path;
      case 'دولار':
        return Assets.images.flags.unitedStates.path;
      case 'ليرة تركية':
        return Assets.images.flags.turkey.path;
      case 'رصيد مقوم':
        return Assets.images.flags.balanceScale.path;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsDialog(context, outgoingCreditsResponse: outgoingCreditsResponse),
      child: Container(
        decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                      outgoingCreditsResponse.target,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.bold,
                      color: context.onPrimaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.bodyMedium(
                          outgoingCreditsResponse.amount,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 3),
                        AppText.bodyMedium(
                          outgoingCreditsResponse.currencyName,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 5),
                        getIcon(outgoingCreditsResponse.currencyName) != null
                            ? Image.asset(
                              getIcon(outgoingCreditsResponse.currencyName)!,
                              scale: 5,
                              alignment: Alignment.bottomCenter,
                            )
                            : SizedBox.shrink(),
                      ],
                    ),
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
