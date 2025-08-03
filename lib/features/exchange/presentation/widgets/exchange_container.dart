import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/features/exchange/data/models/get_preices_model.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locale_keys.g.dart';

class ExchangeContainer extends StatefulWidget {
  final GetPricesResponse? getPricesResponse;
  const ExchangeContainer({super.key, required this.getPricesResponse});

  @override
  State<ExchangeContainer> createState() => _ExchangeContainerState();
}

class _ExchangeContainerState extends State<ExchangeContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
        ...buildExchangeRows(context),
      ],
    );
  }

  String getImagePath(String? img) {
    if (img == null || img.isEmpty) {
      return Assets.images.flags.unitedStates.path;
    }
    return Assets.images.flags.unitedStates.path;
  }

  Currency? getCurrencyObject(String id) {
    final currency = widget.getPricesResponse?.curs.firstWhere(
      (cur) => cur.id == id,
      orElse: () => Currency(id: '', name: '', op: '', price: '', img: ''),
    );
    return currency;
  }

  List<Widget> buildExchangeRows(BuildContext context) {
    final prices = widget.getPricesResponse?.prices.values.toList() ?? [];

    final Map<String, Map<String, PriceValue>> grouped = {};

    for (final price in prices) {
      final ids = [price.curfrom, price.curto]..sort();
      final key = '${ids[0]}-${ids[1]}';

      grouped.putIfAbsent(key, () => {});
      grouped[key]![price.catagory] = price;
    }

    List<Widget> rows = [];

    for (var entry in grouped.entries) {
      final buy = entry.value['buy'];
      final sell = entry.value['sell'];

      final from = buy?.curfrom ?? sell?.curto ?? "";
      final to = buy?.curto ?? sell?.curfrom ?? "";

      final fromCurrency = getCurrencyObject(from);
      final toCurrency = getCurrencyObject(to);

      final label1 = toCurrency?.name ?? to;
      final label2 = fromCurrency?.name ?? from;

      final iconPath1 = getImagePath(toCurrency?.img);
      final iconPath2 = getImagePath(fromCurrency?.img);

      final value1 = double.tryParse(buy?.price ?? "")?.toStringAsFixed(4) ?? "0.0000";
      final value2 = double.tryParse(sell?.price ?? "")?.toStringAsFixed(4) ?? "0.0000";

      rows.add(
        buildExchangeRow(
          label1: label1,
          label2: label2,
          value1: value1,
          value2: value2,
          iconPath1: iconPath1,
          iconPath2: iconPath2,
          context: context,
        ),
      );
    }

    return rows;
  }

  Widget buildExchangeRow({
    required String label1,
    required String label2,
    required String value1,
    required String value2,
    required String iconPath1,
    required String iconPath2,
    required BuildContext context,
  }) {
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
                Image.asset(iconPath2, width: 24),
                const SizedBox(width: 4),
                Image.asset(iconPath1, width: 24),
                const SizedBox(width: 8),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(label1, style: const TextStyle(fontSize: 16)),
                Text(label2, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(value1, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(value2, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}
