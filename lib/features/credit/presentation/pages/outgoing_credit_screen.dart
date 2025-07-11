import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_progress_indecator.dart';
import 'package:golder_octopus/common/widgets/custom_text_field.dart';
import 'package:golder_octopus/common/widgets/date_dropdown_field.dart';
import 'package:golder_octopus/common/widgets/large_button.dart';
import 'package:golder_octopus/common/widgets/sort_header.dart';
import 'package:golder_octopus/common/widgets/toast_dialog.dart';
import 'package:golder_octopus/core/di/injection.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/outgoing_credit_usecase.dart';
import 'package:golder_octopus/features/credit/presentation/bloc/credit_bloc.dart';
import 'package:golder_octopus/features/credit/presentation/widgets/outgoing_credit_container.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';
import 'package:toastification/toastification.dart';

class OutgoingCreditScreen extends StatefulWidget {
  const OutgoingCreditScreen({super.key});

  @override
  State<OutgoingCreditScreen> createState() => _OutgoingTransferScreenState();
}

class _OutgoingTransferScreenState extends State<OutgoingCreditScreen> {
  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  final TextEditingController searchController = TextEditingController();

  DateTime? fromDate = DateTime.now().subtract(Duration(days: 5));
  DateTime? toDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreditBloc>(),
      child: BlocListener<CreditBloc, CreditState>(
        listener: (context, state) {
          if (state.status == CreditStatus.failure) {
            ToastificationDialog.showToast(msg: state.errorMessage!, context: context, type: ToastificationType.error);
          }
        },
        child: Scaffold(
          backgroundColor: context.background,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 75),
              width: context.screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.displaySmall(
                    LocaleKeys.credits_outgoing_credits.tr(),
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.bodyMedium(LocaleKeys.transfer_from_date.tr()),
                      DateDropdownField(
                        selectedDate: fromDate,
                        onChanged: (picked) => setState(() => fromDate = picked),
                      ),
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
                      BlocBuilder<CreditBloc, CreditState>(
                        builder: (context, state) {
                          return LargeButton(
                            width: 100,
                            onPressed:
                                state.status == CreditStatus.loading
                                    ? () {}
                                    : () {
                                      OutgoingCreditParams params = OutgoingCreditParams(
                                        startDate: _formatDateTime(
                                          fromDate ?? DateTime.now().subtract(Duration(days: 5)),
                                        ),
                                        endDate: _formatDateTime(toDate ?? DateTime.now()),
                                      );
                                      context.read<CreditBloc>().add(GetOutgoingCreditsEvent(params: params));
                                    },
                            text: LocaleKeys.transfer_search.tr(),
                            backgroundColor: context.primaryContainer,
                            textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            circularRadius: 12,
                            child: state.status == CreditStatus.loading ? CustomProgressIndecator() : null,
                          );
                        },
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
                  SortHeader(columns: ['وجهة الاعتماد', 'المبلغ'], mainAxisAlignment: MainAxisAlignment.spaceAround),
                  SizedBox(height: 10),
                  BlocBuilder<CreditBloc, CreditState>(
                    builder: (context, state) {
                      if (state.status == CreditStatus.success) {
                        if (state.outgoingCredits == null || state.outgoingCredits!.isEmpty) {
                          return Center(child: AppText.bodyMedium("لا يوجد اعتمادات صادرة"));
                        }
                        return Column(
                          spacing: 15,
                          children: List.generate(
                            state.outgoingCredits!.length,
                            (index) => OutgoingCreditContainer(outgoingCreditsResponse: state.outgoingCredits![index]),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
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
