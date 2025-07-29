import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/size_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../core/di/injection.dart';
import '../bloc/credit_bloc.dart';
import '../widgets/send_credit_form.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locale_keys.g.dart';

class SendCreditScreen extends StatefulWidget {
  const SendCreditScreen({super.key});

  @override
  State<SendCreditScreen> createState() => _SendCreditScreenState();
}

class _SendCreditScreenState extends State<SendCreditScreen> {
  final GlobalKey<SendCreditFormState> _formKey = GlobalKey();

  Future<void> _onRefresh(BuildContext context) async {
    _formKey.currentState?.resetForm();
    context.read<CreditBloc>()
      ..add(GetCompaniesEvent())
      ..add(GetCurrenciesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create:
          (context) =>
              getIt<CreditBloc>()
                ..add(GetCompaniesEvent())
                ..add(GetCurrenciesEvent()),
      child: Scaffold(
        backgroundColor: context.background,
        body: Builder(
          builder: (context) {
            return RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              backgroundColor: context.primaryColor,
              color: context.onPrimaryColor,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 75),
                  width: context.screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.displaySmall(
                        LocaleKeys.credits_send_credit.tr(),
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 20),
                      Center(child: Image.asset(Assets.images.logo.companyLogo.path, scale: 11)),
                      SizedBox(height: 20),
                      SendCreditForm(key: _formKey),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
