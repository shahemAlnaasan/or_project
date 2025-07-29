import 'package:flutter/material.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/widgets/app_text.dart';

class ExchangeTable extends StatefulWidget {
  const ExchangeTable({super.key});
  @override
  State<ExchangeTable> createState() => _ExchangeTableState();
}

class _ExchangeTableState extends State<ExchangeTable> {
  final List<Map<String, String>> data = [
    {'destination': 'حلب يد فوق ال 300 الف - (ليرة سورية)', 'usd': '10,000', 'euro': '0', 'try': '0'},
    {'destination': 'حوالات دولية - (ليرة سورية)', 'usd': '66', 'euro': '0', 'try': '0'},
    {'destination': 'دمشق فوق ال ٣٠٠ الف - (ليرة سورية)', 'usd': '10,200', 'euro': '0', 'try': '0'},
    {'destination': 'فودافون كاش - (جنيه مصري)', 'usd': '50', 'euro': '0', 'try': '0'},
    {'destination': 'محمد كفر سوسة LL - (ليرة سورية)', 'usd': '9,323', 'euro': '0', 'try': '0'},
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(children: [_buildHeaderRow(), ...data.map(_buildDataRow)]),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      color: Colors.green[800],
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'الجهة',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
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

  Widget _buildDataRow(Map<String, String> row) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.onPrimaryColor))),
      // padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(row['destination']!, style: TextStyle(fontSize: 14))),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCurrencyCell(row['usd']!, Colors.red, "دولار"),
                _buildCurrencyCell(row['euro']!, Colors.blue, "يورو"),
                _buildCurrencyCell(row['try']!, Colors.blue, "تركي"),
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
          padding: EdgeInsets.symmetric(vertical: 10),
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
