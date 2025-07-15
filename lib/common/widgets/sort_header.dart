import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';

enum SortDirection { none, ascending, descending, nothing }

class SortHeader extends StatefulWidget {
  final List<SortColumn> columns;
  final MainAxisAlignment? mainAxisAlignment;

  const SortHeader({super.key, required this.columns, this.mainAxisAlignment});

  @override
  State<SortHeader> createState() => _SortHeaderState();
}

class _SortHeaderState extends State<SortHeader> {
  late Map<String, SortDirection> _sortState;

  @override
  void initState() {
    super.initState();
    _sortState = {
      for (var col in widget.columns) col.label: col.label.trim().isEmpty ? SortDirection.nothing : SortDirection.none,
    };
  }

  void _toggleSort(SortColumn column) {
    final label = column.label;
    final currentDirection = _sortState[label] ?? SortDirection.none;

    final newDirection =
        currentDirection == SortDirection.ascending ? SortDirection.descending : SortDirection.ascending;

    setState(() {
      _sortState.updateAll((key, value) => SortDirection.none);

      _sortState[label] = newDirection;

      column.onSort?.call(newDirection);
    });
  }

  Widget _getSortIcon(SortDirection direction) {
    switch (direction) {
      case SortDirection.ascending:
        return Icon(Icons.keyboard_arrow_up_outlined, color: Colors.black, size: 20);
      case SortDirection.descending:
        return Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black, size: 20);
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:
            widget.columns.map((column) {
              final direction = _sortState[column.label]!;
              return Expanded(
                child: GestureDetector(
                  onTap: column.label.trim().isEmpty ? null : () => _toggleSort(column),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(column.label, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 2),
                        _getSortIcon(direction),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class SortColumn {
  final String label;
  final void Function(SortDirection direction)? onSort;

  SortColumn({required this.label, this.onSort});
}
