// File: pdf_generator.dart

import 'package:flutter/services.dart';
import 'package:golder_octopus/features/account_statement/data/models/account_statement_response.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGenerator {
  static Future<void> generateStatementPdf({
    required AccountStatementResponse accountStatement,
    required List<Statment> statments,
    required String fromDate,
    required String toDate,
    required String balanceInWords,
  }) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.cairoRegular();
    final boldFont = await PdfGoogleFonts.cairoBold();
    final img = await rootBundle.load('assets/images/logo/company_logo.png');
    final imageBytes = img.buffer.asUint8List();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(26),
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        textDirection: pw.TextDirection.rtl,
        build:
            (context) => [
              pw.Container(
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(12),
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                padding: pw.EdgeInsets.all(10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Center(child: pw.Image(pw.MemoryImage(imageBytes), width: 70, height: 70)),
                    pw.SizedBox(height: 10),
                    _buildInfoGrid(
                      centerName: accountStatement.centerName,
                      reportType: "كشف حساب اعتبارا من تاريخ $fromDate",
                      fromDate: fromDate,
                      toDate: toDate,
                      currentAccount: 'حساب ${accountStatement.currencyName}',
                      accountName: accountStatement.centerName,
                      fundNumber: accountStatement.centerBox,
                      totalIncoming: accountStatement.inNum.toString(),
                      totalOutgoing: accountStatement.outNum.toString(),
                      totalTrans: "${accountStatement.inNum + accountStatement.outNum}",
                      totalForUs: accountStatement.outTotal.toString(),
                      totalOnUs: accountStatement.inTotal.toString(),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Container(
                      height: 30,
                      decoration: pw.BoxDecoration(
                        borderRadius: pw.BorderRadius.circular(3),
                        border: pw.Border.all(color: PdfColors.blue100),
                      ),
                    ),
                    pw.SizedBox(height: 25),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              _buildCustomTable(statments: statments),
              _buildSummaryRow(
                totalIn: accountStatement.inTotal.toString(),
                totalOut: accountStatement.outTotal.toString(),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(3),
                  border: pw.Border.all(color: PdfColors.blue100),
                ),
                padding: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'الرصيد كتابة $balanceInWords',
                  style: pw.TextStyle(fontSize: 15),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text("الرصيد السابق ", style: pw.TextStyle(fontSize: 15)),
                    pw.Text(
                      " ${accountStatement.lastAccount}",
                      style: pw.TextStyle(fontSize: 15),
                      textDirection: pw.TextDirection.ltr,
                    ),
                  ],
                ),
              ),
            ],
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static pw.Widget _buildInfoGrid({
    required String centerName,
    required String reportType,
    required String fromDate,
    required String toDate,
    required String currentAccount,
    required String accountName,
    required String fundNumber,
    required String totalTrans,
    required String totalOutgoing,
    required String totalIncoming,
    required String totalOnUs,
    required String totalForUs,
  }) {
    final entries = [
      ['اسم المركز', centerName, PdfColors.grey800, PdfColors.grey800],
      ['نوع الكشف', reportType, PdfColors.grey800, PdfColors.grey800],

      ['الحساب', accountName, PdfColors.grey800, PdfColors.grey800],
      ['الحساب الحالي', currentAccount, PdfColors.grey800, PdfColors.grey800],

      ['من تاريخ', fromDate, PdfColors.grey800, PdfColors.grey800],
      ['الى تاريخ', toDate, PdfColors.grey800, PdfColors.grey800],

      ['عدد جميع الحوالات', totalTrans, PdfColors.grey800, PdfColors.grey800],
      ['رقم الصندوق', fundNumber, PdfColors.grey800, PdfColors.grey800],

      ['عدد الحركات الصادرة', totalOutgoing, PdfColors.red, PdfColors.red],
      ['عدد الحركات الواردة', totalIncoming, PdfColors.blue, PdfColors.blue],

      ['اجمالي الدائن - علينا', totalOnUs, PdfColors.red, PdfColors.red],
      ['اجمالي المدين - لنا', totalForUs, PdfColors.blue, PdfColors.blue],
    ];

    return pw.Column(
      children: [
        for (int i = 0; i < entries.length; i += 2)
          pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _coloredPair(entries[i], 1), // first label-value pair
                  if (i + 1 < entries.length) _coloredPair(entries[i + 1], 1), // second pair (if exists)
                ],
              ),
              pw.Divider(color: PdfColors.grey400),
            ],
          ),
      ],
    );
  }

  static pw.Widget _coloredPair(List entry, int flex) {
    final String label = entry[0];
    final String value = entry[1];
    final PdfColor labelColor = entry[2];
    final PdfColor valueColor = entry[3];

    return pw.Expanded(
      flex: flex,
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal, color: labelColor),
            ),
          ),
          pw.Expanded(child: pw.Text(value, style: pw.TextStyle(fontSize: 10, color: valueColor))),
        ],
      ),
    );
  }

  static pw.Widget _buildCustomTable({required List<Statment> statments}) {
    final headers = ['الرصيد', 'مدين لنا', 'دائن علينا', 'ملاحظات', 'رقم الحركة', 'نوع الحركة', 'التاريخ', ''];

    final headerColumnWidths = {
      0: pw.FixedColumnWidth(80),
      1: pw.FixedColumnWidth(60),
      2: pw.FixedColumnWidth(60),
      3: pw.FixedColumnWidth(220),
      4: pw.FixedColumnWidth(150),
      5: pw.FixedColumnWidth(120),
      6: pw.FixedColumnWidth(180),
      7: pw.FixedColumnWidth(30),
      // 8: FixedColumnWidth(80),
    };

    String formatDateTime(DateTime dateTime) {
      return dateTime.toString().split('.').first;
    }

    PdfColor getTypeColor(String type) {
      switch (type) {
        case "قيد-و":
          return PdfColors.blue;
        default:
          return PdfColors.red;
      }
    }

    return pw.Table(
      columnWidths: headerColumnWidths,
      border: pw.TableBorder.symmetric(
        inside: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
        outside: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
      ),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        // Header row
        pw.TableRow(
          children:
              headers
                  .map(
                    (header) => pw.Container(
                      height: 40,
                      padding: const pw.EdgeInsets.only(right: 5, bottom: 5),
                      alignment: pw.Alignment.bottomRight,
                      child: pw.Text(
                        header,
                        style: pw.TextStyle(color: PdfColors.grey800, fontWeight: pw.FontWeight.bold, fontSize: 10),
                        textAlign: pw.TextAlign.start,
                      ),
                    ),
                  )
                  .toList(),
        ),

        // Data rows
        ...statments.asMap().entries.map((entry) {
          final index = entry.key;
          final e = entry.value;

          return pw.TableRow(
            children: [
              _cell(e.account.toStringAsFixed(1), fontSize: 8),
              _cell(e.statmentClass == "0" ? e.amount.toStringAsFixed(1) : '', fontSize: 8),
              _cell(e.statmentClass == "1" ? e.amount.toStringAsFixed(1) : '', fontSize: 8),
              _cell(e.notes ?? '', fontSize: 8),
              _cell(e.transnum.toString(), fontSize: 8, color: PdfColors.blue),
              _cell(e.type.toString(), fontSize: 8, color: getTypeColor(e.type.toString())),
              _cell(formatDateTime(e.date), fontSize: 8),
              _cell('${index + 1}', fontSize: 8, alignment: pw.Alignment.center), // index
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildSummaryRow({required String totalOut, required String totalIn}) {
    final subHeaderColumnWidths = {
      0: pw.FixedColumnWidth(140),
      1: pw.FixedColumnWidth(280),
      2: pw.FixedColumnWidth(270),
      3: pw.FixedColumnWidth(180),
      4: pw.FixedColumnWidth(30),
      // 5: FixedColumnWidth(80),
    };

    return pw.Table(
      columnWidths: subHeaderColumnWidths,
      border: pw.TableBorder.symmetric(
        inside: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
        outside: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
      ),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        pw.TableRow(
          children: [
            for (int i = 0; i < 1; i++) _cell(''),
            pw.Container(
              padding: const pw.EdgeInsets.only(right: 5, bottom: 5),
              alignment: pw.Alignment.centerRight,
              height: 30,
              child: pw.Text(
                'مجموع المدين - لنا',
                style: pw.TextStyle(color: PdfColors.blue, fontSize: 8, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.only(right: 5, bottom: 5),
              alignment: pw.Alignment.centerRight,
              height: 30,
              child: pw.Text(
                'مجموع الدائن - علينا',
                style: pw.TextStyle(color: PdfColors.red, fontSize: 8, fontWeight: pw.FontWeight.bold),
              ),
            ),
            for (int i = 0; i < 2; i++) _cell(''),
          ],
        ),
        pw.TableRow(
          children: [
            for (int i = 0; i < 1; i++) _cell(''),
            _cell(totalOut, color: PdfColors.blue, fontSize: 8),
            _cell(totalIn, color: PdfColors.red, fontSize: 8),
            for (int i = 0; i < 2; i++) _cell(''),
          ],
        ),
      ],
    );
  }

  static pw.Widget _cell(String? value, {PdfColor? color, double fontSize = 10, pw.Alignment? alignment}) {
    return pw.Container(
      padding: pw.EdgeInsets.only(right: 5),
      alignment: alignment ?? pw.Alignment.centerRight,
      height: 30,
      child: pw.Text(
        value ?? '',
        textAlign: pw.TextAlign.right,
        maxLines: 2,
        style: pw.TextStyle(color: color ?? PdfColors.black, fontSize: fontSize),
      ),
    );
  }
}
