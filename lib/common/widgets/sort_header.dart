import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';

enum SortDirection { none, ascending, descending, nothing }

class SortHeader extends StatefulWidget {
  final List<String> columns;
  final MainAxisAlignment? mainAxisAlignment;

  const SortHeader({super.key, this.columns = const ['المستفيد', 'المبلغ', 'العمولة'], this.mainAxisAlignment});

  @override
  State<SortHeader> createState() => _SortHeaderState();
}

class _SortHeaderState extends State<SortHeader> {
  late Map<String, SortDirection> _sortState;

  @override
  void initState() {
    super.initState();

    _sortState = {for (var col in widget.columns) col: col.trim().isEmpty ? SortDirection.nothing : SortDirection.none};
  }

  void _toggleSort(String column) {
    setState(() {
      _sortState.updateAll((key, value) => SortDirection.none);
      _sortState[column] =
          _sortState[column] == SortDirection.ascending ? SortDirection.descending : SortDirection.ascending;
    });
  }

  Widget _getSortIcon(SortDirection direction) {
    switch (direction) {
      case SortDirection.ascending:
        return Icon(Icons.arrow_drop_up, color: Colors.black, size: 20);
      case SortDirection.descending:
        return Icon(Icons.arrow_drop_down, color: Colors.black, size: 20);
      case SortDirection.none:
        return Icon(Icons.unfold_more, color: Colors.black, size: 20);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.primaryContainer, borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:
            widget.columns.map((column) {
              final direction = _sortState[column]!;
              return Expanded(
                child: GestureDetector(
                  onTap: column.trim().isEmpty ? null : () => _toggleSort(column),
                  child: Row(
                    mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
                    children: [
                      Text(column, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      _getSortIcon(direction),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
