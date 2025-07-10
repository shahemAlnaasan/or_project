import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/features/home/data/models/account_info_response.dart';
import 'package:golder_octopus/features/home/presentation/bloc/home_bloc.dart';
import 'package:golder_octopus/features/home/presentation/widgets/currency_balance_container.dart';
import 'package:golder_octopus/features/home/presentation/widgets/news_slider.dart';
import 'package:golder_octopus/features/home/presentation/widgets/quick_actions_grid.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 75.0),
          child: Column(
            spacing: 3,
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state.status == Status.loading || state.status == Status.initial) {
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
                  if (state.status == Status.success) {
                    return Column(
                      children: List.generate(
                        state.accountInfo!.accs.length,
                        (index) => CurrencyBalanceContainer(acc: state.accountInfo!.accs[index]),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              QuickActionsGrid(),
              SizedBox(height: 1),
              NewsSlider(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
