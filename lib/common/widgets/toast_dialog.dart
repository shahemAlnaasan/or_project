import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastificationDialog {
  static bool _isShowing = false;

  static showToast({required String msg, required BuildContext context, required ToastificationType type}) {
    if (_isShowing) return;

    _isShowing = true;

    toastification.show(
      context: context,
      callbacks: ToastificationCallbacks(
        onDismissed: (_) {
          // Reset after it's dismissed
          _isShowing = false;
        },
        onAutoCompleteCompleted: (_) {
          // Reset after it's dismissed
          _isShowing = false;
        },
        onCloseButtonTap: (_) {
          // Reset after it's dismissed
          _isShowing = false;
        },
      ),
      title: Text(msg, maxLines: 3, textAlign: TextAlign.center),
      autoCloseDuration: const Duration(milliseconds: 3000),
      animationDuration: const Duration(milliseconds: 150),
      applyBlurEffect: true,
      pauseOnHover: true,
      type: type,
      closeButton: ToastCloseButton(
        buttonBuilder: (context, onClose) {
          return SizedBox();
        },
      ),
      borderSide: const BorderSide(width: 0),
      margin: const EdgeInsets.all(14),
      showProgressBar: false,
      alignment: Alignment.center,
      showIcon: false,
      style: ToastificationStyle.flat,
    );
  }
}
