import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/consts/app_keys.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/navigation_extensions.dart';
import 'package:golder_octopus/common/theme/app_theme.dart';
import 'package:golder_octopus/core/datasources/hive_helper.dart';
import 'package:golder_octopus/features/auth/presentation/pages/login_screen.dart';
import 'package:golder_octopus/features/main/presentation/bloc/main_bloc.dart';
import 'package:golder_octopus/generated/assets.gen.dart';

AppBar mainAppbar(BuildContext context, {void Function()? onTap}) {
  return AppBar(
    toolbarHeight: 50,
    backgroundColor: context.background,
    elevation: 0,
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(0),
      child: Container(color: context.onPrimaryColor, height: 1),
    ),
    surfaceTintColor: context.background,

    automaticallyImplyLeading: false,

    actionsPadding: EdgeInsets.only(left: 15),

    // title: const AppImage.asset(Assets.imagesOrangeAi, height: 24, width: 24),
    actions: [
      buildActionButton(
        icon: Assets.images.navbar.logout.path,
        onPressed: () {
          HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.hasLogin, value: false);
          HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.hasVerifyLogin, value: false);
          context.pushAndRemoveUntil(LoginScreen());
        },
        context: context,
      ),
      BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return buildActionButton(
            icon:
                state.theme == AppTheme.lightTheme
                    ? Assets.images.navbar.nightMode.path
                    : Assets.images.navbar.lightMode.path,
            onPressed: () {
              log("press moon");
              context.read<MainBloc>().add(SetThemeEvent());
            },
            context: context,
          );
        },
      ),
      buildActionButton(icon: Assets.images.navbar.exchange.path, onPressed: () {}, context: context),
      buildActionButton(icon: Assets.images.navbar.exchange.path, onPressed: () {}, context: context),
    ],
    leading: Padding(
      padding: EdgeInsets.only(right: 15),
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(Assets.images.navbar.option.path, scale: 4.5, color: context.onPrimaryColor),
      ),
    ),
  );
}

Widget buildActionButton({
  required String icon,
  double? scale,
  required void Function()? onPressed,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: Image.asset(icon, scale: scale ?? 8.4, color: context.onPrimaryColor),
    ),
  );
}

class ExpandableMenu extends StatefulWidget {
  const ExpandableMenu({super.key});

  @override
  State<ExpandableMenu> createState() => _ExpandableMenuState();
}

class _ExpandableMenuState extends State<ExpandableMenu> {
  bool _showMenu = false;
  bool _expandTools = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Expandable Menu'),
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  setState(() => _showMenu = !_showMenu);
                },
              ),
            ],
          ),
          body: Center(child: Text('Main content here')),
        ),
        if (_showMenu)
          Positioned(
            top: kToolbarHeight + 8,
            right: 10,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 220,
                padding: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('الاعتمادات'),
                      trailing: Icon(_expandTools ? Icons.expand_less : Icons.expand_more),
                      onTap: () {
                        setState(() => _expandTools = !_expandTools);
                      },
                    ),
                    if (_expandTools) ...[
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 32, right: 16),
                        title: Text('اعتماد واردة'),
                        onTap: () {},
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 32, right: 16),
                        title: Text('اعتماد صادرة'),
                        onTap: () {},
                      ),
                    ],
                    Divider(height: 1),
                    ListTile(title: Text('كشف حساب'), onTap: () {}),
                    ListTile(title: Text('إرسال حوالة'), onTap: () {}),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
