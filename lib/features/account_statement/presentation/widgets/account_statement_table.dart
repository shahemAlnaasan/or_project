import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/features/account_statement/data/models/account_statement_response.dart';
import 'package:golder_octopus/features/account_statement/presentation/widgets/account_statement_form.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class AccountStatementTable extends StatefulWidget {
  final List<Statment> statments;
  final double outTotal;
  final double inTotal;
  final TextEditingController searchController;

  const AccountStatementTable({
    super.key,
    required this.statments,
    required this.outTotal,
    required this.inTotal,
    required this.searchController,
  });

  @override
  State<AccountStatementTable> createState() => _NewAccountStatementTableState();
}

class _NewAccountStatementTableState extends State<AccountStatementTable> {
  int _currentPage = 0;
  final int _itemsPerPage = 15;

  int get totalPages => (filteredList.length / _itemsPerPage).ceil();

  List<Statment> get paginatedList {
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return filteredList.sublist(startIndex, endIndex > filteredList.length ? filteredList.length : endIndex);
  }

  final headers = ['الرصيد', 'مدين لنا', 'دائن علينا', 'ملاحظات', 'رقم الحركة', 'نوع الحركة', 'التاريخ', ''].reversed;
  String _formatDateTime(DateTime dateTime) {
    return dateTime.toString().split('.').first;
  }

  Color getTypeColor(String type) {
    if (type == "قيد-و") {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  } // removes the milliseconds

  final subHeaderColumnWidths = {
    0: FixedColumnWidth(40),
    1: FixedColumnWidth(200),
    2: FixedColumnWidth(270),
    3: FixedColumnWidth(260),
    4: FixedColumnWidth(140),
    // 5: FixedColumnWidth(80),
  };

  final headerColumnWidths = {
    0: FixedColumnWidth(40),
    1: FixedColumnWidth(200),
    2: FixedColumnWidth(120),
    3: FixedColumnWidth(150),
    4: FixedColumnWidth(200),
    5: FixedColumnWidth(60),
    6: FixedColumnWidth(60),
    7: FixedColumnWidth(80),
    // 8: FixedColumnWidth(80),
  };
  late final TextEditingController searchController;
  String _searchQuery = "";
  late List<Statment> filteredList;
  late List<Statment> fullList;

  @override
  void initState() {
    searchController = widget.searchController;
    fullList = widget.statments;
    filteredList = fullList;
    searchController.addListener(listener);
    super.initState();
  }

  void listener() {
    setState(() {
      _searchQuery = searchController.text.trim().toLowerCase();
      _currentPage = 0;
      if (_searchQuery.isEmpty) {
        filteredList = fullList;
      } else {
        filteredList =
            fullList.where((item) {
              final note = item.notes?.toLowerCase();

              final contains = note?.contains(_searchQuery) ?? false;

              return contains;
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTextField(
          hint: LocaleKeys.transfer_search.tr(),
          sufIcon: Icon(Icons.search),
          controller: searchController,
        ),
        SizedBox(height: 20),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Table(
                columnWidths: headerColumnWidths,
                border: TableBorder.symmetric(
                  inside: BorderSide(color: context.onPrimaryColor, width: 0.5),
                  outside: BorderSide(color: context.onPrimaryColor, width: 0.5),
                ),
                children: [
                  TableRow(
                    children:
                        headers
                            .map((header) => buildCellText(lable: header, isHeader: true, color: Colors.black))
                            .toList(),
                  ),
                ],
              ),
              Table(
                columnWidths: subHeaderColumnWidths,
                border: TableBorder.symmetric(
                  inside: BorderSide(color: context.onPrimaryColor, width: 0.5),
                  outside: BorderSide(color: context.onPrimaryColor, width: 0.5),
                ),
                children: [
                  TableRow(
                    children: [
                      buildCellText(lable: "", height: 50),
                      buildCellText(lable: "", height: 50),
                      buildCellText(lable: "مجموع الدائن - علينا", height: 50, color: Colors.red),
                      buildCellText(lable: "مجموع المدين - لنا", height: 50, color: Colors.blue),
                      buildCellText(lable: "", height: 50),
                      // buildCellText(lable: "", height: 50),
                    ],
                  ),
                  TableRow(
                    children: [
                      buildCellText(lable: "", height: 50),
                      buildCellText(lable: "", height: 50),
                      buildCellText(lable: "${widget.inTotal}", height: 50, color: Colors.red),
                      buildCellText(lable: "${widget.outTotal}", height: 50, color: Colors.blue),
                      buildCellText(lable: "", height: 50),
                      // buildCellText(lable: "", height: 50),
                    ],
                  ),
                ],
              ),
              Table(
                columnWidths: headerColumnWidths,
                border: TableBorder.symmetric(
                  inside: BorderSide(color: context.onPrimaryColor, width: 0.5),
                  outside: BorderSide(color: context.onPrimaryColor, width: 0.5),
                ),
                children: List.generate(paginatedList.length, (index) {
                  final e = paginatedList[index];
                  return TableRow(
                    children: [
                      buildCellText(lable: "${_currentPage * _itemsPerPage + index + 1}", height: 50),

                      buildCellText(lable: _formatDateTime(e.date), height: 50, textDirection: TextDirection.ltr),
                      buildCellText(lable: e.type.toString(), height: 50, color: getTypeColor(e.type.toString())),
                      buildCellText(lable: e.transnum.toString(), height: 50, color: Colors.blue),
                      buildCellText(lable: e.notes ?? "", height: 50),
                      buildCellText(
                        lable: e.statmentClass == "1" ? e.amount.toStringAsFixed(1) : "",
                        height: 50,
                        textDirection: TextDirection.ltr,
                      ),
                      buildCellText(
                        lable: e.statmentClass == "0" ? e.amount.toStringAsFixed(1) : "",
                        height: 50,
                        textDirection: TextDirection.ltr,
                      ),
                      buildCellText(lable: e.account.toStringAsFixed(1), height: 50, textDirection: TextDirection.ltr),
                    ],
                  );
                }),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("الصفحة ${_currentPage + 1} من $totalPages", style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: _currentPage < totalPages - 1 ? () => setState(() => _currentPage++) : null,
                      ),
                    ],
                  ),
                ],
              ),
            ],
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
