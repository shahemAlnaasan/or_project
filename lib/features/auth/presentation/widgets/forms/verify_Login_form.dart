import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../../common/extentions/colors_extension.dart';
import '../../../../../common/extentions/navigation_extensions.dart';
import '../../../../../common/state_managment/bloc_state.dart';
import '../../../../../common/utils/local_authentication.dart';
import '../../../../../common/utils/url_launche_helper.dart';
import '../../../../../common/widgets/app_text.dart';
import '../../../../../common/widgets/custom_progress_indecator.dart';
import '../../../../../common/widgets/custom_text_field.dart';
import '../../../../../common/widgets/large_button.dart';
import '../../../../../common/widgets/toast_dialog.dart';
import '../../../../../core/di/injection.dart';
import '../../bloc/auth_bloc.dart';
import '../add_fingreprint.dart';
import '../../../../main/presentation/pages/main_screen.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/locale_keys.g.dart';
import 'package:toastification/toastification.dart';

class VerifyLoginForm extends StatefulWidget {
  const VerifyLoginForm({super.key});

  @override
  State<VerifyLoginForm> createState() => _NewTransferFormState();
}

class _NewTransferFormState extends State<VerifyLoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == Status.failure) {
          ToastificationDialog.showToast(msg: state.errorMessage!, context: context, type: ToastificationType.error);
        }
        if (state.status == Status.success) {
          context.pushAndRemoveUntil(MainScreen());
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.trust == "true") {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  AddFingreprint(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: AppText.labelMedium("او", textAlign: TextAlign.center, fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Divider(color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppText.headlineSmall(
                      LocaleKeys.auth_to_download_google_authenticator.tr(),
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => UrlLaucncheHelper.openStorePage(isAndroid: true),
                        child: Image.asset(Assets.images.logo.googlePlayLogo.path, scale: 15),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => UrlLaucncheHelper.openStorePage(isAndroid: false),
                        child: Image.asset(Assets.images.logo.appStoreLogo.path, scale: 15),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  QrImageView(
                    data: state.key ?? "",
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  SizedBox(height: 10),

                  buildRowText(lable: LocaleKeys.auth_account_name.tr(), value: state.name ?? ""),
                  buildRowText(
                    lable: LocaleKeys.auth_key.tr(),
                    value: state.key == null ? "" : state.key!,
                    needCopy: true,
                  ),
                  SizedBox(height: 10),
                  buildTextField(
                    hint: LocaleKeys.auth_verify_code.tr(),
                    preIcon: Image.asset(
                      Assets.images.google.path,
                      color: context.onPrimaryColor.withAlpha(170),
                      scale: 7,
                    ),
                    keyboardType: TextInputType.number,
                    controller: codeController,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: LargeButton(
                          onPressed:
                              state.status == Status.loading
                                  ? () {}
                                  : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(VerifyLoginEvent(code: codeController.text));
                                    }
                                  },
                          text: LocaleKeys.auth_login.tr(),
                          backgroundColor: context.primaryContainer,
                          circularRadius: 12,
                          child: state.status == Status.loading ? CustomProgressIndecator() : null,
                        ),
                      ),
                    ],
                  ),
                  // LargeButton(
                  //   onPressed: () {
                  //     HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.hasLogin, value: false);
                  //     HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.hasVerifyLogin, value: false);
                  //   },
                  //   text: LocaleKeys.auth_login.tr(),
                  //   backgroundColor: context.primaryContainer,
                  //   circularRadius: 12,
                  // ),
                ],
              ),
            );
          } else {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  buildTextField(
                    hint: LocaleKeys.auth_verify_code.tr(),
                    preIcon: Image.asset(
                      Assets.images.google.path,
                      color: context.onPrimaryColor.withAlpha(170),
                      scale: 7,
                    ),
                    keyboardType: TextInputType.number,
                    controller: codeController,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: LargeButton(
                          onPressed:
                              state.status == Status.loading
                                  ? () {}
                                  : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(VerifyLoginEvent(code: codeController.text));
                                    }
                                  },
                          text: LocaleKeys.auth_login.tr(),
                          backgroundColor: context.primaryContainer,
                          circularRadius: 12,
                          child: state.status == Status.loading ? CustomProgressIndecator() : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        final BiometricHelper biometricHelper = getIt<BiometricHelper>();
                        await biometricHelper.authenticateWithBiometrics();
                      },
                      child: Icon(Icons.fingerprint_outlined, size: 60),
                    ),
                  ),
                  // LargeButton(
                  //   onPressed: () {
                  //     HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.hasLogin, value: false);
                  //     HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.hasVerifyLogin, value: false);
                  //   },
                  //   text: LocaleKeys.auth_login.tr(),
                  //   backgroundColor: context.primaryContainer,
                  //   circularRadius: 12,
                  // ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildRowText({required String lable, required String value, bool needCopy = false}) {
    return Row(
      children: [
        Expanded(child: AppText.bodyMedium(lable, textAlign: TextAlign.start, fontWeight: FontWeight.w500)),
        Expanded(flex: 2, child: AppText.bodyMedium(value, textAlign: TextAlign.start, fontWeight: FontWeight.w500)),
        if (needCopy)
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              ToastificationDialog.showToast(msg: "تم النسخ", context: context, type: ToastificationType.success);
            },
            child: Icon(Icons.copy, size: 18),
          ),
      ],
    );
  }
}

Widget buildTextField({
  required String hint,
  required TextEditingController controller,
  String validatorTitle = "",
  int mxLine = 1,
  Widget? sufIcon,
  Widget? preIcon,
  bool? readOnly,
  dynamic Function()? onTap,
  bool needValidation = true,
  bool obSecure = false,
  FocusNode? focusNode,
  FocusNode? focusOn,
  TextInputType? keyboardType,
}) {
  return CustomTextField(
    obSecure: obSecure,
    preIcon: preIcon,
    onTap: onTap,
    readOnly: readOnly,
    mxLine: mxLine,
    controller: controller,
    hint: hint,
    focusNode: focusNode,
    focusOn: focusOn,
    keyboardType: keyboardType,
    validator:
        needValidation
            ? (value) {
              if (value == null || value.isEmpty) {
                return validatorTitle.isNotEmpty ? validatorTitle : LocaleKeys.transfer_this_field_cant_be_empty.tr();
              }
              return null;
            }
            : null,
    sufIcon: sufIcon,
  );
}
