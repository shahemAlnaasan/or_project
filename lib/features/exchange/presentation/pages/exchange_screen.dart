import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/core/di/injection.dart';
import 'package:golder_octopus/features/exchange/data/models/get_preices_model.dart';
import 'package:golder_octopus/features/exchange/presentation/bloc/exchange_bloc.dart';
import '../../../../common/extentions/size_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../widgets/exchange_container.dart';
import '../../../../generated/locale_keys.g.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});

  @override
  State<ExchangeScreen> createState() => _OutgoingTransferScreenState();
}

class _OutgoingTransferScreenState extends State<ExchangeScreen> {
  GetPricesResponse? getPricesResponse;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ExchangeBloc>()..add(GetPricesEvent()),
      child: BlocListener<ExchangeBloc, ExchangeState>(
        listener: (context, state) async {
          if (state.getPricesStatus == Status.success && state.getPricesResponse != null) {
            if (!mounted) return;
            setState(() {
              getPricesResponse = state.getPricesResponse;
            });

            await Future.delayed(const Duration(seconds: 2));

            if (!mounted) return;
            // context.read<ExchangeBloc>().add(GetPricesEvent());
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 75),
            width: context.screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.displaySmall(
                  LocaleKeys.exchange_exchange.tr(),
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 20),
                ExchangeContainer(getPricesResponse: getPricesResponse),
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
