import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_text_field.dart';
import 'package:golder_octopus/common/widgets/sort_header.dart';
import 'package:golder_octopus/features/credit/presentation/widgets/incoming_credit_container.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class IncomingTransferScreen extends StatefulWidget {
  const IncomingTransferScreen({super.key});

  @override
  State<IncomingTransferScreen> createState() => _OutgoingTransferScreenState();
}

class _OutgoingTransferScreenState extends State<IncomingTransferScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 75),
          width: context.screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.displaySmall(
                LocaleKeys.transfer_incoming_transfers.tr(),
                textAlign: TextAlign.start,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              buildTextField(
                hint: LocaleKeys.transfer_search.tr(),
                sufIcon: Icon(Icons.search),
                controller: searchController,
              ),
              SizedBox(height: 10),
              SortHeader(
                columns: [
                  LocaleKeys.credits_credit_source.tr(),
                  LocaleKeys.credits_money_amount.tr(),
                  LocaleKeys.credits_notes.tr(),
                ],
              ),
              SizedBox(height: 10),
              IncomingCreditContainer(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildTextField({
  required String hint,
  required TextEditingController controller,
  String validatorTitle = "",
  int mxLine = 1,
  Widget? sufIcon,
  bool? readOnly,
  dynamic Function()? onTap,
  bool needValidation = true,
}) {
  return CustomTextField(
    onTap: onTap,
    readOnly: readOnly,
    mxLine: mxLine,
    controller: controller,
    hint: hint,
    validator:
        needValidation
            ? (value) {
              if (value == null || value.isEmpty) {
                return validatorTitle.isNotEmpty ? validatorTitle : LocaleKeys.transfer_this_field_cant_be_empty.tr();
              }
              return null;
            }
            : null,
    sufIcon: sufIcon,
  );
}
