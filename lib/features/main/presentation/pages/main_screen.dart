import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/size_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../core/di/injection.dart';
import '../../../account_statement/presentation/pages/account_statement_screen.dart';
import '../../../account_statement/presentation/pages/centers_posts_screen.dart';
import '../../../account_statement/presentation/pages/reports_screen.dart';
import '../../../auth/presentation/pages/change_password_screen.dart';
import '../../../credit/presentation/pages/incoming_credit_screen.dart';
import '../../../credit/presentation/pages/outgoing_credit_screen.dart';
import '../../../exchange/presentation/pages/exchange_screen.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../widgets/main_appbar.dart';
import '../widgets/side_actions/scan_qr_action.dart';
import '../widgets/side_actions/side_action_placeholder.dart';
import '../widgets/side_actions/user_info_action.dart';
import '../../../transfer/presentation/pages/incoming_transfer_screen.dart';
import '../../../transfer/presentation/pages/new_transfer_screen.dart';
import '../../../transfer/presentation/pages/outgoing_transfer_screen.dart';
import '../../../transfer/presentation/pages/received_transfer_screen.dart';
import '../../../transfer/presentation/pages/resereved_transfer_screen.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locale_keys.g.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2;
  final List<int> _tabHistory = [2]; // Start with home

  int sideIconShowed = 25;
  bool _showUserInfo = false;
  bool _showMovements = false;
  bool _showScanQR = false;
  bool _showMenu = false;
  String? _expandedMenu;

  void _toggleUserInfo() {
    setState(() {
      _showUserInfo = !_showUserInfo;
      _showMovements = false;
      _showScanQR = false;
    });
  }

  // ignore: unused_element
  void _toggleMovements() {
    setState(() {
      _showMovements = !_showMovements;
      _showUserInfo = false;
      _showScanQR = false;
    });
  }

  void _toggleScanQR() {
    setState(() {
      _showScanQR = !_showScanQR;
      _showUserInfo = false;
      _showMovements = false;
    });
  }

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

  void _pushInCurrentTab(Widget screen) {
    _navigatorKeys[_selectedIndex]!.currentState!.push(MaterialPageRoute(builder: (_) => screen));
    setState(() => _showMenu = false);
  }

  void _onTabTapped(int index) {
    if (_selectedIndex == index) {
      final navigator = _navigatorKeys[index]!.currentState!;
      navigator.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _tabHistory.remove(index);
        _tabHistory.add(index);
        _selectedIndex = index;
      });
    }
    setState(() {
      _showMenu = false;
    });
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        final currentNavigator = _navigatorKeys[_selectedIndex]!.currentState!;
        if (didPop) return;

        if (currentNavigator.canPop()) {
          currentNavigator.pop();
        } else if (_tabHistory.length > 1) {
          setState(() {
            _tabHistory.removeLast();
            _selectedIndex = _tabHistory.last;
          });
        } else {
          SystemNavigator.pop();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: mainAppbar(context, onTap: () => setState(() => _showMenu = !_showMenu)),
            extendBody: true,
            backgroundColor: context.background,
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  _showUserInfo = false;
                  _showMovements = false;
                  _showScanQR = false;
                  _showMenu = false;
                });
              },
              child: Stack(
                children: [
                  IndexedStack(
                    index: _selectedIndex,
                    children: List.generate(_rootScreens.length, (i) => _buildTabNavigator(i)),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    top: 100,
                    left: _showUserInfo ? -20 : -(context.screenWidth / 1.2) - sideIconShowed,
                    child: _buildSideAction(
                      icon: Assets.images.sideActions.user.path,
                      actionWidget: UserInfoAction(),
                      onTap: _toggleUserInfo,
                    ),
                  ),
                  // AnimatedPositioned(
                  //   duration: const Duration(milliseconds: 500),
                  //   curve: Curves.easeInOut,
                  //   top: 180,
                  //   left: _showMovements ? -20 : -(context.screenWidth / 1.2) - 20,
                  //   child: _buildSideAction(
                  //     icon: Assets.images.sideActions.user.path,
                  //     actionWidget: MovementsAction(),
                  //     onTap: _toggleMovements,
                  //   ),
                  // ),
                  if (_showScanQR)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      top: 180,
                      left: -20,
                      child: _buildSideAction(
                        icon: Assets.images.sideActions.qr.path,
                        actionWidget: ScanQrAction(),
                        onTap: _toggleScanQR,
                      ),
                    )
                  else
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      top: 180,
                      left: -(context.screenWidth / 1.2) - sideIconShowed,
                      child: _buildSideAction(
                        icon: Assets.images.sideActions.qr.path,
                        actionWidget: _showScanQR ? ScanQrAction() : SideActionPlaceholder(),
                        onTap: _toggleScanQR,
                      ),
                    ),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomBar(),
          ),
          if (_showMenu)
            Positioned(
              top: kToolbarHeight + 20,
              right: 10,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 250,
                  padding: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMenuItem(
                        label: "الصفحة الرئيسية",
                        icon: Assets.images.navbar.home.path,
                        expandable: false,
                        onTap: () {
                          final navigator = _navigatorKeys[2]!.currentState!;
                          navigator.popUntil((route) => route.isFirst);
                          setState(() {
                            _tabHistory.remove(2);
                            _tabHistory.add(2);
                            _selectedIndex = 2;
                            _showMenu = false;
                          });
                        },
                      ),
                      _buildMenuItem(
                        label: "الصادر",
                        icon: Assets.images.sideActions.outgoing.path,
                        children: [
                          _buildMenuItem(
                            label: "الحوالات الصادرة",
                            icon: Icons.arrow_back_rounded,
                            expandable: false,
                            isSubItem: true,
                            onTap: () => _pushInCurrentTab(OutgoingTransferScreen()),
                          ),
                          _buildMenuItem(
                            label: "حوالة محجوزة لحين التنفيذ",
                            icon: Assets.images.block.path,
                            expandable: false,
                            isSubItem: true,
                            onTap: () => _pushInCurrentTab(ReserevedTransferScreen()),
                          ),
                        ],
                      ),
                      _buildMenuItem(
                        label: "الوارد",
                        icon: Assets.images.sideActions.incoming.path,
                        children: [
                          _buildMenuItem(
                            label: "الحوالات الواردة",
                            icon: Icons.arrow_forward_outlined,
                            expandable: false,
                            isSubItem: true,
                            onTap: () => _pushInCurrentTab(IncomingTransferScreen()),
                          ),
                          _buildMenuItem(
                            label: "الحوالات المستلمة",
                            icon: Assets.images.check.path,
                            expandable: false,
                            isSubItem: true,
                            onTap: () => _pushInCurrentTab(ReceivedTransferScreen()),
                          ),
                        ],
                      ),
                      _buildMenuItem(
                        label: "الاعتمادات",
                        icon: Assets.images.sideActions.incoming.path,
                        children: [
                          _buildMenuItem(
                            label: "اعتمادات صادرة",
                            icon: Icons.arrow_upward_outlined,
                            expandable: false,
                            isSubItem: true,
                            onTap: () => _pushInCurrentTab(OutgoingCreditScreen()),
                          ),
                          _buildMenuItem(
                            label: "اعتمادات واردة",
                            icon: Icons.arrow_downward_outlined,
                            expandable: false,
                            isSubItem: true,
                            onTap: () => _pushInCurrentTab(IncomingCreditScreen()),
                          ),
                        ],
                      ),
                      _buildMenuItem(
                        label: "الحسابات",
                        icon: Assets.images.sideActions.user.path,
                        children: [
                          _buildMenuItem(
                            label: "كشف حساب",
                            icon: Assets.images.sideActions.accounts.path,
                            expandable: false,
                            isSubItem: true,
                            onTap: () => _pushInCurrentTab(AccountStatementScreen()),
                          ),
                          _buildMenuItem(
                            label: "صندوق الارباح",
                            icon: Assets.images.heart.path,
                            expandable: false,
                            isSubItem: true,
                            onTap: () => _pushInCurrentTab(OutgoingTransferScreen()),
                          ),
                        ],
                      ),
                      _buildMenuItem(
                        label: "المنشورات",
                        icon: Assets.images.sideActions.twitter.path,
                        children: [
                          _buildMenuItem(
                            label: "اخبار الشركة",
                            icon: Icons.message_outlined,
                            expandable: false,
                            isSubItem: true,
                            onTap: () => _pushInCurrentTab(OutgoingTransferScreen()),
                          ),
                          _buildMenuItem(
                            label: "منشورات المراكز",
                            icon: Assets.images.sideActions.twitter.path,
                            expandable: false,
                            isSubItem: true,
                            onTap: () => _pushInCurrentTab(CentersPostsScreen()),
                          ),
                        ],
                      ),
                      _buildMenuItem(
                        label: "أدوات",
                        icon: Assets.images.sideActions.settings.path,
                        children: [
                          _buildMenuItem(
                            label: "ادارة الوكلاء",
                            icon: Icons.person_add_alt,
                            expandable: false,
                            isSubItem: true,
                            onTap: () => _pushInCurrentTab(OutgoingTransferScreen()),
                          ),
                          _buildMenuItem(
                            label: "التقارير",
                            icon: Assets.images.dataAnalytics.path,
                            expandable: false,
                            isSubItem: true,
                            onTap: () => _pushInCurrentTab(ReportsScreen()),
                          ),
                          _buildMenuItem(
                            label: "تغيير كلمة المرور",
                            icon: Icons.lock_open,
                            expandable: false,
                            isSubItem: true,
                            onTap: () => _pushInCurrentTab(ChangePasswordScreen()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: context.onPrimaryColor))),
      child: BottomAppBar(
        notchMargin: 16,
        padding: const EdgeInsets.only(bottom: 2, top: 6),
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
            Image.asset(icon, scale: 5.5, color: context.secondary),
            const SizedBox(height: 1),
            AppText.bodyMedium(
              [
                LocaleKeys.navbar_new_transfer.tr(),
                LocaleKeys.navbar_outgoing_transfers.tr(),
                LocaleKeys.navbar_home.tr(),
                LocaleKeys.navbar_incoming_transfers.tr(),
                LocaleKeys.navbar_exchange.tr(),
              ][index],
              style: context.textTheme.labelMedium!.copyWith(
                color: context.secondary,
                fontWeight: FontWeight.w900,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 5,
              height: 5,
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

  Widget _buildSideAction({required String icon, required void Function()? onTap, required Widget actionWidget}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border.all(color: Colors.transparent),
              boxShadow: [
                BoxShadow(color: context.onPrimaryColor.withAlpha(120), blurRadius: 3, blurStyle: BlurStyle.solid),
              ],
            ),
            padding: EdgeInsets.all(8),
            child: Image.asset(icon, color: context.primaryColor, scale: 4),
          ),
          actionWidget,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String label,
    required icon,
    void Function()? onTap,
    bool isSubItem = false,
    bool expandable = true,
    List<Widget> children = const [],
  }) {
    final isExpanded = _expandedMenu == label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: isSubItem ? 10 : 0),
          child: ListTile(
            textColor: context.onPrimaryColor,

            title: Text(label, style: const TextStyle(fontSize: 15)),
            leading:
                icon is String
                    ? Image.asset(icon, scale: 7.3, color: context.onPrimaryColor)
                    : Icon(icon, size: 20, color: context.onPrimaryColor),
            trailing:
                expandable
                    ? Icon(
                      isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      size: 22,
                      color: context.onPrimaryColor,
                    )
                    : null,
            onTap:
                expandable
                    ? () {
                      setState(() {
                        _expandedMenu = isExpanded ? null : label;
                      });
                    }
                    : onTap,
          ),
        ),
        AnimatedCrossFade(
          firstChild: SizedBox.shrink(),
          secondChild: Column(children: children),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
