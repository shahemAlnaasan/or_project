import 'package:flutter/material.dart';
import 'package:golder_octopus/features/transfer/data/models/get_sy_prices_response.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/widgets/app_text.dart';

class ExchangeTable extends StatefulWidget {
  final GetSyPricesResponse? getSyPricesResponse;
  const ExchangeTable({super.key, required this.getSyPricesResponse});

  @override
  State<ExchangeTable> createState() => _ExchangeTableState();
}

class _ExchangeTableState extends State<ExchangeTable> {
  @override
  Widget build(BuildContext context) {
    final pricesMap = widget.getSyPricesResponse?.prices ?? {};

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          _buildHeaderRow(),
          ...pricesMap.entries.map((entry) {
            return _buildDataRow(entry.value);
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      color: Colors.green[800],
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            flex: 1,
            child: Text(
              'الجهة',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(
            child: Text(
              'العملات',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(Price price) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.onPrimaryColor))),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(price.name, style: const TextStyle(fontSize: 14))),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCurrencyCell(price.priceUsd, Colors.red, "دولار"),
                _buildCurrencyCell(price.priceEur, Colors.blue, "يورو"),
                _buildCurrencyCell(price.priceTl, Colors.blue, "تركي"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyCell(String value, Color color, String label) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(border: Border(right: BorderSide(color: context.onPrimaryColor))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText.bodyMedium(label, style: TextStyle(color: color, fontSize: 12), height: 1),
              AppText.labelLarge(
                value,
                textAlign: TextAlign.start,
                style: TextStyle(color: context.onPrimaryColor, fontWeight: FontWeight.w900),
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
