import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/features/credit/data/models/incoming_credits_response.dart';
import 'package:golder_octopus/features/credit/presentation/widgets/incoming_credit_details_dialog.dart';
import 'package:golder_octopus/generated/assets.gen.dart';

class IncomingCreditContainer extends StatelessWidget {
  final IncomingCreditsResponse incomingCredit;
  final int index;
  const IncomingCreditContainer({super.key, required this.incomingCredit, required this.index});

  void _showDetailsDialog(BuildContext context, {required IncomingCreditsResponse incomingCreditsResponse}) {
    showDialog(
      context: context,
      builder: (context) {
        return IncomingCreditDetailsDialog(incomingCreditsResponse: incomingCreditsResponse);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsDialog(context, incomingCreditsResponse: incomingCredit),
      child: Container(
        decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                spacing: 10,
                children: [
                  AppText.bodyMedium("${index + 1}", textAlign: TextAlign.center, fontWeight: FontWeight.bold),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(color: context.primaryContainer, borderRadius: BorderRadius.circular(8)),
                    child: Text("استلام"),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: AppText.bodyMedium(
                  incomingCredit.source,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppText.bodyMedium(incomingCredit.amount, textAlign: TextAlign.start, fontWeight: FontWeight.bold),
                  const SizedBox(height: 5),
                  AppText.bodyMedium(
                    incomingCredit.currencyName,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 10),
                  Image.asset(Assets.images.flags.unitedStates.path, scale: 5, alignment: Alignment.bottomCenter),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
