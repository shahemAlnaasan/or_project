import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/features/exchange/data/models/exchange_model.dart';
import 'package:golder_octopus/features/transfer/presentation/widgets/transfer_details_dialog.dart';
import 'package:golder_octopus/generated/assets.gen.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

enum ExchangeType { euroDolar, goldDolar, silverDolar }

class ExchangeContainer extends StatelessWidget {
  ExchangeContainer({super.key});

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return TransferDetailsDialog();
      },
    );
  }

  final List<ExchangeModel> exchangeList = [
    ExchangeModel(
      label: "يورو",
      subLabel: "دولار",
      value1: "0.0",
      value2: "1.1688",
      iconPath1: Assets.images.flags.unitedStates.path,
      iconPath2: Assets.images.flags.europe.path,
    ),
    ExchangeModel(
      label: "أونصة ذهب",
      subLabel: "دولار",
      value1: "3,324.3",
      value2: "3,324.7",
      iconPath1: Assets.images.flags.unitedStates.path,
      iconPath2: Assets.images.flags.gold.path,
    ),
    ExchangeModel(
      label: "أونصة فضة",
      subLabel: "دولار",
      value1: "0",
      value2: "0",
      iconPath1: Assets.images.flags.unitedStates.path,
      iconPath2: Assets.images.flags.silver.path,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsDialog(context),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: context.primaryContainer,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AppText.bodyMedium(LocaleKeys.exchange_sell.tr(), fontWeight: FontWeight.bold),
                    AppText.bodyMedium(LocaleKeys.exchange_buy.tr(), fontWeight: FontWeight.bold),
                  ],
                ),
              ),
            ),
          ),

          ...exchangeList.map((e) => buildExchangeRow(e, context)),
        ],
      ),
    );
  }

  Widget buildExchangeRow(ExchangeModel exchange, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: context.primaryColor,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(exchange.iconPath2, width: 24),
                const SizedBox(width: 4),
                Image.asset(exchange.iconPath1, width: 24),
                const SizedBox(width: 8),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(exchange.label, style: const TextStyle(fontSize: 16)),
                Text(exchange.subLabel, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(exchange.value1, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(exchange.value2, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}
