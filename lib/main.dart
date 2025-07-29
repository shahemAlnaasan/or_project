import 'package:flutter/material.dart';
import 'app.dart';
import 'common/utils/init_main.dart';

void main() async {
  await Initialization.initMain();
  runApp(Initialization.initLocalization(const App()));
}
