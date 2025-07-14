import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_action_button.dart';
import 'package:golder_octopus/features/transfer/data/models/outgoing_transfer_response.dart';
import 'package:golder_octopus/features/transfer/presentation/widgets/transfer_details_dialog.dart';
import 'package:golder_octopus/generated/assets.gen.dart';

class OutgoingTransferContainer extends StatelessWidget {
  final OutgoingTransfers outgoingTransfers;
  const OutgoingTransferContainer({super.key, required this.outgoingTransfers});

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return TransferDetailsDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsDialog(context),
      child: Container(
        decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.bodySmall(
                        outgoingTransfers.amount,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      AppText.bodySmall(outgoingTransfers.currencyName, fontWeight: FontWeight.bold),
                      const SizedBox(height: 5),
                      Image.asset(Assets.images.flags.unitedStates.path, scale: 5, alignment: Alignment.bottomCenter),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.bodySmall(
                        outgoingTransfers.amount,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      AppText.bodySmall(
                        outgoingTransfers.currencyName,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      Image.asset(Assets.images.flags.unitedStates.path, scale: 5, alignment: Alignment.bottomCenter),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.bodySmall(
                        outgoingTransfers.target,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 8,
              children: [
                Expanded(
                  child: CustomActionButton(onPressed: () {}, text: "اشعار", backgroundColor: context.primaryContainer),
                ),

                Expanded(
                  child: CustomActionButton(
                    onPressed: () => _showDetailsDialog(context),
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
