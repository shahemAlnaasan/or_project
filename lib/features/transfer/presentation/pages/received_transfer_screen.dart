import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_text_field.dart';
import 'package:golder_octopus/common/widgets/date_dropdown_field.dart';
import 'package:golder_octopus/common/widgets/large_button.dart';
import 'package:golder_octopus/common/widgets/sort_header.dart';
import 'package:golder_octopus/features/transfer/presentation/widgets/received_transfer_container.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class ReceivedTransferScreen extends StatefulWidget {
  const ReceivedTransferScreen({super.key});

  @override
  State<ReceivedTransferScreen> createState() => _OutgoingTransferScreenState();
}

class _OutgoingTransferScreenState extends State<ReceivedTransferScreen> {
  final TextEditingController searchController = TextEditingController();

  DateTime? fromDate = DateTime.now().subtract(Duration(days: 5));
  DateTime? toDate;
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
                LocaleKeys.home_recived_transfer.tr(),
                textAlign: TextAlign.start,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.bodyMedium(LocaleKeys.transfer_from_date.tr()),
                  DateDropdownField(selectedDate: fromDate, onChanged: (picked) => setState(() => fromDate = picked)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.bodyMedium(LocaleKeys.transfer_to_date.tr()),
                  DateDropdownField(selectedDate: toDate, onChanged: (picked) => setState(() => toDate = picked)),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.bodyMedium(""),
                  LargeButton(
                    width: 100,
                    onPressed: () {},
                    text: LocaleKeys.transfer_search.tr(),
                    backgroundColor: context.primaryContainer,
                    textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),

                    circularRadius: 12,
                  ),
                ],
              ),
              SizedBox(height: 15),
              Divider(color: context.onPrimaryColor),
              SizedBox(height: 20),
              buildTextField(
                hint: LocaleKeys.transfer_search.tr(),
                sufIcon: Icon(Icons.search),
                controller: searchController,
              ),
              SizedBox(height: 10),
              SortHeader(
                columns: [
                  LocaleKeys.credits_destination.tr(),
                  LocaleKeys.credits_money_amount.tr(),
                  LocaleKeys.credits_transfer_date.tr(),
                ],
              ),
              SizedBox(height: 10),
              ReceivedTransferContainer(),
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
