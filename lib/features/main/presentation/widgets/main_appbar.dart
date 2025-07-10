import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/consts/app_keys.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/theme/app_theme.dart';
import 'package:golder_octopus/core/datasources/hive_helper.dart';
import 'package:golder_octopus/features/main/presentation/bloc/main_bloc.dart';
import 'package:golder_octopus/generated/assets.gen.dart';

AppBar mainAppbar(BuildContext context) {
  return AppBar(
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
    leading: Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: GestureDetector(
            onTap: () {},
            child: Image.asset(Assets.images.navbar.option.path, scale: 4, color: context.onPrimaryColor),
          ),
        ),
      ],
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
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Image.asset(icon, scale: scale ?? 8, color: context.onPrimaryColor),
    ),
  );
}
