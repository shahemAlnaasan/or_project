import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:flutter/material.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/size_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../widgets/reports/incoming_transfer_report.dart';
import '../widgets/reports/outgoing_transfers_report.dart';
import '../../../../generated/locale_keys.g.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final headers = [
    LocaleKeys.reports_center_name.tr(),
    LocaleKeys.reports_outgoing_movments_count.tr(),
    LocaleKeys.reports_incoming_movments_count.tr(),
  ];
  final headerColumnWidths = {0: FixedColumnWidth(1), 1: FixedColumnWidth(1), 2: FixedColumnWidth(1)};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 75),
          width: context.screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.displaySmall(
                LocaleKeys.reports_reports.tr(),
                textAlign: TextAlign.start,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              Table(
                // columnWidths: headerColumnWidths,
                border: TableBorder.symmetric(
                  inside: BorderSide(color: context.onPrimaryColor, width: 0.5),
                  outside: BorderSide(color: context.onPrimaryColor, width: 0.5),
                ),
                children: [
                  TableRow(
                    children:
                        headers
                            .map(
                              (header) => buildCellText(lable: header, isHeader: true, color: Colors.black, height: 65),
                            )
                            .toList(),
                  ),
                  TableRow(
                    children:
                        headers
                            .map((header) => buildCellText(lable: header, color: context.onPrimaryColor, height: 60))
                            .toList(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              OutgoingTransfersReport(),
              SizedBox(height: 20),
              IncomingTransferReport(),
            ],
          ),
        ),
      ),
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
