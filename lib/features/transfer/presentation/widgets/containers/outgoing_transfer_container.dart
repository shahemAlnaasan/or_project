import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/extentions/colors_extension.dart';
import '../../../../../common/widgets/app_text.dart';
import '../../../../../common/widgets/custom_action_button.dart';
import '../../../data/models/outgoing_transfer_response.dart';
import '../../../domain/use_cases/trans_details_usecase.dart';
import '../../bloc/transfer_bloc.dart';
import '../../../../../generated/assets.gen.dart';

class OutgoingTransferContainer extends StatelessWidget {
  final OutgoingTransfers outgoingTransfers;
  const OutgoingTransferContainer({super.key, required this.outgoingTransfers});

  void triggerEvent(BuildContext context, {required String transNum, bool isForDialog = true}) {
    TransDetailsParams params = TransDetailsParams(transNum: outgoingTransfers.transnum);
    context.read<TransferBloc>().add(GetTransDetailsEvent(params: params, isForDialog: isForDialog));
  }

  String? getIcon(String currencyName) {
    switch (currencyName) {
      case 'يورو':
        return Assets.images.flags.europe.path;
      case 'دولار':
        return Assets.images.flags.unitedStates.path;
      case 'ليرة تركية':
        return Assets.images.flags.turkey.path;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => triggerEvent(context, transNum: outgoingTransfers.transnum),
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
                      getIcon(outgoingTransfers.currencyName) != null
                          ? Image.asset(
                            getIcon(outgoingTransfers.currencyName)!,
                            scale: 5,
                            alignment: Alignment.bottomCenter,
                          )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.bodySmall(outgoingTransfers.tax, textAlign: TextAlign.start, fontWeight: FontWeight.bold),
                      const SizedBox(height: 5),
                      AppText.bodySmall(
                        outgoingTransfers.currencyName,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      getIcon(outgoingTransfers.currencyName) != null
                          ? Image.asset(
                            getIcon(outgoingTransfers.currencyName)!,
                            scale: 5,
                            alignment: Alignment.bottomCenter,
                          )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.bodySmall(
                        outgoingTransfers.benename,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      AppText.bodySmall(
                        outgoingTransfers.benephone,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
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
                  child: CustomActionButton(
                    onPressed: () => triggerEvent(context, transNum: outgoingTransfers.transnum, isForDialog: false),
                    text: "اشعار",
                    backgroundColor: context.primaryContainer,
                  ),
                ),

                Expanded(
                  child: CustomActionButton(
                    onPressed: () => triggerEvent(context, transNum: outgoingTransfers.transnum),
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
