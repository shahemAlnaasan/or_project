
import 'package:flutter/material.dart';


class LoadingDialog {
  static BuildContext? _context;

  static show(BuildContext context) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        LoadingDialog._context = context;
        return const AlertDialog(
          content: Row(
            spacing: 10,
            children: [
              CircularProgressIndicator(),
              Text("Loading..."),
            ],
          ),
        );
      },
    );
  }

  static close() {
    if (LoadingDialog._context != null) {
      if (_context!.mounted) {
        Navigator.of(LoadingDialog._context!).pop();
      }
    }
  }
}

