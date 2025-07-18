import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/consts/model_usage.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/common/widgets/toast_dialog.dart';
import 'package:golder_octopus/features/account_statement/data/models/currencies_response.dart';
import 'package:golder_octopus/features/home/data/models/account_info_response.dart';
import 'package:golder_octopus/features/home/presentation/bloc/home_bloc.dart';
import 'package:golder_octopus/features/home/presentation/widgets/currency_balance_container.dart';
import 'package:golder_octopus/features/home/presentation/widgets/news_slider.dart';
import 'package:golder_octopus/features/home/presentation/widgets/quick_actions_grid.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CurrenciesResponse? currenciesResponse;

  @override
  void initState() {
    context.read<HomeBloc>().add(GetCurrenciesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.homeStatus == Status.failure) {
          ToastificationDialog.showToast(msg: state.errorMessage!, context: context, type: ToastificationType.error);
        }
        if (state.currenciesStatus == Status.success) {
          setState(() {
            currenciesResponse = state.currencies;
          });
        }
      },
      child: Scaffold(
        backgroundColor: context.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 75.0),
            child: Column(
              spacing: 3,
              children: [
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state.homeStatus == Status.loading || state.homeStatus == Status.initial) {
                      return Column(
                        children: List.generate(
                          4,
                          (index) => Skeletonizer(
                            enabled: true,
                            containersColor: context.primaryColor,
                            enableSwitchAnimation: true,
                            child: CurrencyBalanceContainer(
                              acc: Acc(
                                amount: 10,
                                currency: "currency",
                                currencyName: "currencyName",
                                currencyImg: "currencyImg",
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    if (state.homeStatus == Status.success) {
                      return Column(
                        children: List.generate(
                          state.accountInfo!.accs.length,
                          (index) => CurrencyBalanceContainer(acc: state.accountInfo!.accs[index]),
                        ),
                      );
                    }
                    return Column(
                      children: List.generate(
                        ModelUsage().acc.length,
                        (index) => CurrencyBalanceContainer(acc: ModelUsage().acc[index]),
                      ),
                    );
                  },
                ),
                QuickActionsGrid(currenciesResponse: currenciesResponse),
                SizedBox(height: 3),
                NewsSlider(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
