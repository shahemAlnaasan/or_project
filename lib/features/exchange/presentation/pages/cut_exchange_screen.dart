import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/core/di/injection.dart';
import 'package:golder_octopus/features/exchange/data/models/get_preices_model.dart';
import 'package:golder_octopus/features/exchange/presentation/bloc/exchange_bloc.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/size_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../widgets/exchange_container.dart';
import '../widgets/cut_exchange_form.dart';
import '../../../../generated/locale_keys.g.dart';

class CutExchangeScreen extends StatefulWidget {
  const CutExchangeScreen({super.key});

  @override
  State<CutExchangeScreen> createState() => _CutExchangeScreenState();
}

class _CutExchangeScreenState extends State<CutExchangeScreen> {
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
                    LocaleKeys.home_shear_bond.tr(),
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 20),
                  CutExchangeForm(getPricesResponse: getPricesResponse),
                  SizedBox(height: 10),
                  AppText.titleLarge(
                    LocaleKeys.exchange_exchange_prices.tr(),
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.bold,
                  ),
                  AppText.bodyLarge(
                    "${LocaleKeys.exchange_last_update.tr()} ${getPricesResponse?.time ?? "00:00:00"}",
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 10),

                  ExchangeContainer(getPricesResponse: getPricesResponse),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
