import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_text_field.dart';
import 'package:golder_octopus/core/di/injection.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/incoming_credit_usecase.dart';
import 'package:golder_octopus/features/credit/presentation/bloc/credit_bloc.dart';
import 'package:golder_octopus/features/credit/presentation/widgets/incoming_credit_container.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class IncomingCreditScreen extends StatefulWidget {
  const IncomingCreditScreen({super.key});

  @override
  State<IncomingCreditScreen> createState() => _OutgoingTransferScreenState();
}

class _OutgoingTransferScreenState extends State<IncomingCreditScreen> {
  final TextEditingController searchController = TextEditingController();
  late IncomingCreditParams params;
  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  @override
  void initState() {
    super.initState();
    params = IncomingCreditParams(startDate: _formatDateTime(DateTime(2000, 1, 2)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<CreditBloc>()..add(GetIncomingCreditsEvent(params: params)),
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
                  LocaleKeys.home_incoming_credits.tr(),
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

                Container(
                  decoration: BoxDecoration(color: context.primaryContainer, borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "sfafs",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            LocaleKeys.credits_credit_source.tr(),
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          LocaleKeys.credits_amount.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                BlocBuilder<CreditBloc, CreditState>(
                  builder: (context, state) {
                    if (state.status == CreditStatus.success) {
                      if (state.incomingCredits == null || state.incomingCredits!.isEmpty) {
                        return Center(child: AppText.bodyMedium("لا يوجد اعتمادات واردة"));
                      }
                    }
                    return Column(
                      children: List.generate(
                        state.incomingCredits!.length,
                        (index) => IncomingCreditContainer(incomingCredit: state.incomingCredits![index], index: index),
                      ),
                    );
                  },
                ),
              ],
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
