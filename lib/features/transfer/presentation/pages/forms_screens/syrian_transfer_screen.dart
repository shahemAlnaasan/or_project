import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/core/di/injection.dart';
import 'package:golder_octopus/features/transfer/data/models/get_sy_prices_response.dart';
import 'package:golder_octopus/features/transfer/presentation/bloc/transfer_bloc.dart';
import '../../../../../common/extentions/colors_extension.dart';
import '../../../../../common/extentions/size_extension.dart';
import '../../../../../common/widgets/app_text.dart';
import '../../widgets/exchange_table.dart';
import '../../widgets/forms/syrian_transfer_form.dart';
import '../../../../../generated/locale_keys.g.dart';

class SyrianTransferScreen extends StatefulWidget {
  const SyrianTransferScreen({super.key});

  @override
  State<SyrianTransferScreen> createState() => _SyrianTransferScreenState();
}

class _SyrianTransferScreenState extends State<SyrianTransferScreen> {
  final GlobalKey<SyrianTransferFormState> _formKey = GlobalKey();

  GetSyPricesResponse? getSyPricesResponse;

  Future<void> _onRefresh(BuildContext context) async {
    _formKey.currentState?.resetForm(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create:
          (context) =>
              getIt<TransferBloc>()
                ..add(GetSyTargetsEvent())
                ..add(GetSyPricesEvent())
                ..add(GetCurrenciesEvent()),
      child: BlocListener<TransferBloc, TransferState>(
        listener: (context, state) {
          if (state.getSyPricesStatus == Status.success && state.getSyPricesResponse != null) {
            setState(() {
              getSyPricesResponse = state.getSyPricesResponse;
            });
          }
        },
        child: Scaffold(
          backgroundColor: context.background,
          body: Builder(
            builder: (context) {
              return RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                backgroundColor: context.primaryColor,
                color: context.onPrimaryColor,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 75),
                    width: context.screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.displaySmall("حوالة USDT", textAlign: TextAlign.start, fontWeight: FontWeight.bold),
                        SizedBox(height: 20),
                        SyrianTransferForm(key: _formKey),
                        SizedBox(height: 20),
                        ExchangeTable(getSyPricesResponse: getSyPricesResponse),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
