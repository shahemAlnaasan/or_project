import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';

class SideActionPlaceholder extends StatefulWidget {
  const SideActionPlaceholder({super.key});

  @override
  State<SideActionPlaceholder> createState() => _SideActionPlaceholderState();
}

class _SideActionPlaceholderState extends State<SideActionPlaceholder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth / 1.2,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(0), bottomRight: Radius.circular(12)),
        border: Border.all(color: Colors.transparent),
        boxShadow: [BoxShadow(color: context.onPrimaryColor.withAlpha(100))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ],
      ),
    );
  }
}
