import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/extentions/colors_extension.dart';
import '../../../../../common/extentions/navigation_extensions.dart';
import '../../../../../common/state_managment/bloc_state.dart';
import '../../../../../common/widgets/custom_progress_indecator.dart';
import '../../../../../common/widgets/custom_text_field.dart';
import '../../../../../common/widgets/large_button.dart';
import '../../../../../common/widgets/toast_dialog.dart';
import '../../../../../core/di/injection.dart';
import '../../../domain/use_cases/login_usecase.dart';
import '../../bloc/auth_bloc.dart';
import '../../pages/verify_login_screen.dart';
import '../../../../../generated/locale_keys.g.dart';
import 'package:toastification/toastification.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _NewTransferFormState();
}

class _NewTransferFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode usernameNode = FocusNode();
  final FocusNode passwardNode = FocusNode();
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == Status.failure) {
            ToastificationDialog.showToast(msg: state.errorMessage!, context: context, type: ToastificationType.error);
          }
          if (state.status == Status.success) {
            context.push(BlocProvider.value(value: context.read<AuthBloc>(), child: VerifyLoginScreen()));
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              buildTextField(
                hint: LocaleKeys.auth_username.tr(),
                preIcon: Icon(Icons.person_outline_outlined, color: context.onPrimaryColor.withAlpha(170)),
                controller: usernameController,
                focusNode: usernameNode,
                focusOn: passwardNode,
              ),

              SizedBox(height: 5),
              buildTextField(
                hint: LocaleKeys.auth_password.tr(),
                preIcon: Icon(Icons.lock_outline, color: context.onPrimaryColor.withAlpha(170)),
                obSecure: true,
                controller: passwordController,
                focusNode: passwardNode,
              ),
              SizedBox(height: 10),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: LargeButton(
                          onPressed:
                              state.status == Status.loading
                                  ? () {}
                                  : () {
                                    if (_formKey.currentState!.validate()) {
                                      final LoginParams params = LoginParams(
                                        username: usernameController.text,
                                        password: passwordController.text,
                                        ipInfo: "",
                                        deviceInfo: "",
                                      );

                                      context.read<AuthBloc>().add(LoginEvent(params: params));
                                    }
                                  },
                          text: LocaleKeys.auth_login.tr(),
                          backgroundColor: context.primaryContainer,
                          circularRadius: 12,
                          child: state.status == Status.loading ? CustomProgressIndecator() : null,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
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
