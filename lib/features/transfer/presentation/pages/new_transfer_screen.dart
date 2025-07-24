import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/core/di/injection.dart';
import 'package:golder_octopus/features/transfer/presentation/bloc/transfer_bloc.dart';
import 'package:golder_octopus/features/transfer/presentation/widgets/forms/new_transfer_form.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class NewTransferScreen extends StatefulWidget {
  const NewTransferScreen({super.key});

  @override
  State<NewTransferScreen> createState() => _NewTransferScreenState();
}

class _NewTransferScreenState extends State<NewTransferScreen> {
  final GlobalKey<NewTransferFormState> _formKey = GlobalKey();

  Future<void> _onRefresh(BuildContext context) async {
    _formKey.currentState?.resetForm();
    context.read<TransferBloc>().add(GetTransTargetsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TransferBloc>()..add(GetTransTargetsEvent()),
      child: Scaffold(
        backgroundColor: context.background,
        body: Builder(
          builder: (context) {
            return RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              backgroundColor: context.primaryColor,
              color: context.onPrimaryColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 75),
                  width: context.screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.displaySmall(
                        LocaleKeys.transfer_new_transfer.tr(),
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 20),
                      NewTransferForm(key: _formKey),
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
