import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/consts/app_keys.dart';
import '../../../../core/datasources/hive_helper.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_screen.dart';
import '../../../auth/presentation/pages/verify_login_screen.dart';
import 'main_screen.dart';

Future<Widget> splashScreen(BuildContext context) async {
  final bool hasLogin = await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.hasLogin) ?? false;
  final bool hasVerifyLogin =
      await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.hasVerifyLogin) ?? false;
  log("hasLogin $hasLogin");
  log("hasVerifyLogin $hasVerifyLogin");
  if (hasLogin) {
    if (hasVerifyLogin) {
      return MainScreen();
    } else {
      return BlocProvider(
        create: (context) => getIt<AuthBloc>()..add(InitVerifyInfoEvent()),
        child: VerifyLoginScreen(),
      );
    }
  }
  return LoginScreen();
}

class HomeDecider extends StatefulWidget {
  const HomeDecider({super.key});

  @override
  State<HomeDecider> createState() => _HomeDeciderState();
}

class _HomeDeciderState extends State<HomeDecider> {
  late Future<Widget> _splashFuture;

  @override
  void initState() {
    super.initState();
    _splashFuture = splashScreen(context); // Called only once
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _splashFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: SizedBox.shrink());
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else if (snapshot.hasData) {
          return snapshot.data!;
        }
        return const Scaffold(body: Center(child: Text('Something went wrong')));
      },
    );
  }
}
