import 'package:flutter/material.dart';

import 'package:toastification/toastification.dart';

class ToastificationDialog {
  static showToast({required String msg, required BuildContext context, required ToastificationType type}) {
    toastification.show(
      context: context,
      title: Text(msg, maxLines: 3, textAlign: TextAlign.center),
      autoCloseDuration: const Duration(milliseconds: 3000),
      animationDuration: const Duration(milliseconds: 150),
      applyBlurEffect: true,
      pauseOnHover: true,
      type: type,
      borderSide: const BorderSide(width: 0),
      margin: const EdgeInsets.all(14),
      showProgressBar: false,
      alignment: Alignment.center,
      showIcon: false,
      // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      style: ToastificationStyle.flat,
    );
  }
}
