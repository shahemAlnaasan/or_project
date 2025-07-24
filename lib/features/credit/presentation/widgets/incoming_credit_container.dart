import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_action_button.dart';
import 'package:golder_octopus/features/credit/data/models/incoming_credits_response.dart';
import 'package:golder_octopus/features/credit/presentation/bloc/credit_bloc.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/trans_details_usecase.dart';
import 'package:golder_octopus/generated/assets.gen.dart';

class IncomingCreditContainer extends StatelessWidget {
  final IncomingCreditsResponse incomingCredit;
  final int index;
  const IncomingCreditContainer({super.key, required this.incomingCredit, required this.index});

  void triggerEvent(BuildContext context, {required String transNum, bool isForDialog = true}) {
    TransDetailsParams params = TransDetailsParams(transNum: transNum);
    context.read<CreditBloc>().add(GetIncomingCreditDetailsEvent(params: params, isForDialog: isForDialog));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => triggerEvent(context, transNum: incomingCredit.transnum),
      child: Container(
        decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    spacing: 10,
                    children: [
                      AppText.bodyMedium("${index + 1}", textAlign: TextAlign.center, fontWeight: FontWeight.bold),
                      GestureDetector(
                        onTap: () => triggerEvent(context, transNum: incomingCredit.transnum, isForDialog: false),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: context.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text("استلام", style: TextStyle(color: Colors.black, fontSize: 13)),
                        ),
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
                      AppText.bodyMedium(
                        incomingCredit.amount,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      AppText.bodyMedium(
                        incomingCredit.currencyName,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      Image.asset(Assets.images.flags.unitedStates.path, scale: 5, alignment: Alignment.bottomCenter),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            CustomActionButton(
              onPressed: () => triggerEvent(context, transNum: incomingCredit.transnum),
              text: "تفاصيل",
              backgroundColor: context.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}
