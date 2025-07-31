import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../common/extentions/colors_extension.dart';
import '../../../../../common/widgets/app_text.dart';
import '../../../../../common/widgets/custom_action_button.dart';
import '../../../data/models/received_transfer_response.dart';
import '../dialogs/received_transfer_details_dialog.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/locale_keys.g.dart';

class ReceivedTransferContainer extends StatelessWidget {
  final ReceivedTransfers receivedTransfers;
  const ReceivedTransferContainer({super.key, required this.receivedTransfers});

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ReceivedTransferDetailsDialog(receivedTransfers: receivedTransfers);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsDialog(context),
      child: Container(
        decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.bodySmall(
                        LocaleKeys.transfer_outgoing_transfers.tr(),
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      AppText.bodySmall("0965292417", textAlign: TextAlign.start, fontWeight: FontWeight.bold),
                      const SizedBox(height: 5),
                      AppText.bodySmall("ادلب - ابراهيم كللي", textAlign: TextAlign.start, fontWeight: FontWeight.bold),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText.bodySmall("7", textAlign: TextAlign.start, fontWeight: FontWeight.bold),
                      const SizedBox(height: 5),
                      AppText.bodySmall(
                        LocaleKeys.home_dolar.tr(),
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      Image.asset(Assets.images.flags.unitedStates.path, scale: 5, alignment: Alignment.bottomCenter),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(color: context.primaryContainer, borderRadius: BorderRadius.circular(8)),
                    alignment: Alignment.center,
                    child: Text("وصل", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            CustomActionButton(
              onPressed: () => _showDetailsDialog(context),
              text: "تفاصيل",
              backgroundColor: context.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}
