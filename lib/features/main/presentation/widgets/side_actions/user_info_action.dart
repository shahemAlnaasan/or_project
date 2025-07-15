import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';

class UserInfoAction extends StatefulWidget {
  const UserInfoAction({super.key});

  @override
  State<UserInfoAction> createState() => _UserInfoActionState();
}

class _UserInfoActionState extends State<UserInfoAction> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth / 1.2,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(12),
          topRight: Radius.circular(0),
        ),
        border: Border.all(color: const Color.fromARGB(0, 0, 0, 0)),

        boxShadow: [BoxShadow(color: context.onPrimaryColor.withAlpha(120), blurRadius: 3, blurStyle: BlurStyle.solid)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          AppText.bodyLarge("ياسر", color: context.primaryColor),
          SizedBox(height: 10),
          _buildRowData(icon: Icons.arrow_upward_outlined, lable: "رقم الصندوق", value: "0"),
          _buildRowData(icon: Icons.arrow_upward_outlined, lable: "الحوالات الصادرة", value: "0"),
          _buildRowData(icon: Icons.arrow_upward_outlined, lable: "الحوالات المسلمة", value: "0"),
          _buildRowData(icon: Icons.arrow_upward_outlined, lable: "حوالات بانتظار التسليم", value: "0"),
          _buildRowData(icon: Icons.arrow_upward_outlined, lable: "الحوالات المحذوفة", value: "0"),
        ],
      ),
    );
  }

  Widget _buildRowData({required IconData icon, required String lable, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: context.primaryColor),
        AppText.bodyMedium("$lable : ", color: context.primaryColor),
        AppText.bodyMedium(value, color: context.primaryColor),
      ],
    );
  }
}
