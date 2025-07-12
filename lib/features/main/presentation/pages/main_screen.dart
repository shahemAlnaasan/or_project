import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/core/di/injection.dart';
import 'package:golder_octopus/features/exchange/presentation/pages/exchange_screen.dart';
import 'package:golder_octopus/features/home/presentation/bloc/home_bloc.dart';
import 'package:golder_octopus/features/home/presentation/pages/home_screen.dart';
import 'package:golder_octopus/features/main/presentation/widgets/main_appbar.dart';
import 'package:golder_octopus/features/transfer/presentation/pages/incoming_transfer_screen.dart';
import 'package:golder_octopus/features/transfer/presentation/pages/new_transfer_screen.dart';
import 'package:golder_octopus/features/transfer/presentation/pages/outgoing_transfer_screen.dart';
import 'package:golder_octopus/generated/assets.gen.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2;

  final _navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
    4: GlobalKey<NavigatorState>(),
  };

  final List<Widget> _rootScreens = [
    const NewTransferScreen(),
    const OutgoingTransferScreen(),
    BlocProvider(
      lazy: false,
      create: (context) => getIt<HomeBloc>()..add(GetAccountInfoEvent()),
      child: const HomeScreen(),
    ),
    const IncomingTransferScreen(),
    const ExchangeScreen(),
  ];

  void _onTabTapped(int index) {
    if (_selectedIndex == index) {
      final currentNavigator = _navigatorKeys[index]!.currentState!;
      if (currentNavigator.canPop()) {
        currentNavigator.popUntil((route) => route.isFirst);
      } else {
        final widget = _rootScreens[index];
        currentNavigator.pushReplacement(MaterialPageRoute(builder: (BuildContext context) => widget));
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildTabNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (_) => _rootScreens[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppbar(context),
      extendBody: true,
      backgroundColor: context.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: List.generate(_rootScreens.length, (i) => _buildTabNavigator(i)),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: context.onPrimaryColor))),
      child: BottomAppBar(
        notchMargin: 16,
        padding: const EdgeInsets.only(bottom: 5, top: 6),
        height: 75,
        color: context.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final icons = [
              Assets.images.navbar.send.path,
              Assets.images.navbar.arrowUp.path,
              Assets.images.navbar.home.path,
              Assets.images.navbar.arrowDown.path,
              Assets.images.navbar.exchange.path,
            ];
            return Expanded(child: _buildNavItem(icon: icons[index], index: index));
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem({required String icon, required int index}) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => _onTabTapped(index),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(icon, scale: 5, color: context.secondary),
            const SizedBox(height: 1),
            AppText.bodyMedium(
              [
                LocaleKeys.navbar_new_transfer.tr(),
                LocaleKeys.navbar_outgoing_transfers.tr(),
                LocaleKeys.navbar_home.tr(),
                LocaleKeys.navbar_incoming_transfers.tr(),
                LocaleKeys.navbar_exchange.tr(),
              ][index],
              style: context.textTheme.labelMedium!.copyWith(color: context.secondary, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isSelected ? context.secondary : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
