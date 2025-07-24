import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_action_button.dart';
import 'package:golder_octopus/features/transfer/data/models/incoming_transfer_response.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/trans_details_usecase.dart';
import 'package:golder_octopus/features/transfer/presentation/bloc/transfer_bloc.dart';
import 'package:golder_octopus/generated/assets.gen.dart';

class IncomingTransferContainer extends StatelessWidget {
  final IncomingTransfers incomingTransfers;
  const IncomingTransferContainer({super.key, required this.incomingTransfers});
  void triggerEvent(BuildContext context, {required String transNum, bool isForDialog = true}) {
    TransDetailsParams params = TransDetailsParams(transNum: transNum);
    context.read<TransferBloc>().add(GetIncomingTransDetailsEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => triggerEvent(context, transNum: incomingTransfers.transnum),
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
                        incomingTransfers.amount,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      AppText.bodySmall(incomingTransfers.currencyName, fontWeight: FontWeight.bold),
                      const SizedBox(height: 5),
                      Image.asset(Assets.images.flags.unitedStates.path, scale: 5, alignment: Alignment.bottomCenter),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.bodySmall(incomingTransfers.tax, textAlign: TextAlign.start, fontWeight: FontWeight.bold),
                      const SizedBox(height: 5),
                      AppText.bodySmall(
                        incomingTransfers.currencyName,
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
                        incomingTransfers.benename,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      AppText.bodySmall(
                        incomingTransfers.benephone,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      AppText.bodySmall(
                        incomingTransfers.source,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            CustomActionButton(
              onPressed: () => triggerEvent(context, transNum: incomingTransfers.transnum),
              text: "تفاصيل",
              backgroundColor: context.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}
