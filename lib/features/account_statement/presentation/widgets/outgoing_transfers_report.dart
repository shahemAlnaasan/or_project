import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../generated/locale_keys.g.dart';

class OutgoingTransfersReport extends StatefulWidget {
  const OutgoingTransfersReport({super.key});

  @override
  State<OutgoingTransfersReport> createState() => _OutgoingTransfersReportState();
}

class _OutgoingTransfersReportState extends State<OutgoingTransfersReport> {
  final months = [
    'كانون الثاني', // Jan
    'شباط', // Feb
    'آذار', // Mar
    'نيسان', // Apr
    'أيار', // May
    'حزيران', // Jun
    'تموز', // Jul
    'آب', // Aug
    'أيلول', // Sep
    'تشرين الأول', // Oct
    'تشرين الثاني', // Nov
    'كانون الأول', // Dec
  ];
  final headerColumnWidths = {
    0: FixedColumnWidth(40),
    1: FixedColumnWidth(40),
    2: FixedColumnWidth(40),
    3: FixedColumnWidth(40),
    4: FixedColumnWidth(40),
    5: FixedColumnWidth(40),
    6: FixedColumnWidth(40),
    7: FixedColumnWidth(40),
    8: FixedColumnWidth(40),
    9: FixedColumnWidth(40),
    10: FixedColumnWidth(40),
    11: FixedColumnWidth(40),
  };

  final values = List.generate(12, (index) => 0.0);
  final headers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];

  // dummy 0 values
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodyLarge(
          "${LocaleKeys.reports_outgoing_transfers_count.tr()} ${LocaleKeys.reports_depend_on_year_monthes.tr()}",
          textAlign: TextAlign.start,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 20),
        Center(
          child: AspectRatio(
            aspectRatio: 1.6,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.pinkAccent,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(show: true, color: Colors.pinkAccent.withOpacity(0.3)),
                    spots: List.generate(values.length, (index) => FlSpot(index.toDouble(), values[index])),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, _) {
                        final index = value.toInt();
                        if (index < 0 || index >= months.length) return const SizedBox.shrink();
                        return Transform.rotate(
                          angle: -0.4,
                          child: Text(months[index], style: const TextStyle(fontSize: 10)),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                minY: 0,
                maxY: (values.reduce((a, b) => a > b ? a : b)) + 1,
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            columnWidths: headerColumnWidths,
            border: TableBorder.symmetric(
              inside: BorderSide(color: context.onPrimaryColor, width: 0.5),
              outside: BorderSide(color: context.onPrimaryColor, width: 0.5),
            ),
            children: [
              TableRow(
                children:
                    headers
                        .map((header) => buildCellText(lable: header, isHeader: true, color: Colors.black, height: 40))
                        .toList(),
              ),
              TableRow(
                children:
                    headers
                        .map((header) => buildCellText(lable: header, color: context.onPrimaryColor, height: 40))
                        .toList(),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        AppText.bodyLarge(
          "${LocaleKeys.reports_outgoing_transfers_count.tr()} ${LocaleKeys.reports_this_month.tr()}",
          textAlign: TextAlign.start,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 20),
        AspectRatio(
          aspectRatio: 1.6,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: Colors.pinkAccent,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: true, color: Colors.pinkAccent.withOpacity(0.3)),
                  spots: List.generate(values.length, (index) => FlSpot(index.toDouble(), values[index])),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < 0 || index >= months.length) return const SizedBox.shrink();
                      return Transform.rotate(
                        angle: -0.4,
                        child: Text(months[index], style: const TextStyle(fontSize: 10)),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              minY: 0,
              maxY: (values.reduce((a, b) => a > b ? a : b)) + 1,
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCellText({
    required String lable,
    Color? color,
    double? height,
    bool isHeader = false,
    TextDirection? textDirection,
  }) {
    return Container(
      height: height ?? 70,
      color: isHeader ? context.primaryContainer : null,
      padding: EdgeInsets.only(right: 5, bottom: isHeader ? 10 : 0),
      alignment: isHeader ? Alignment.bottomRight : Alignment.centerRight,

      child: Text(
        lable,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: color ?? context.onPrimaryColor, fontWeight: FontWeight.bold, fontSize: 15),
        textAlign: TextAlign.right,
        textDirection: textDirection ?? TextDirection.rtl,
      ),
    );
  }
}
