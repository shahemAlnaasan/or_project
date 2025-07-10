import 'package:flutter/material.dart';
import 'package:golder_octopus/app.dart';
import 'package:golder_octopus/common/utils/init_main.dart';

void main() async {
  await Initialization.initMain();
  runApp(Initialization.initLocalization(const App()));
}
