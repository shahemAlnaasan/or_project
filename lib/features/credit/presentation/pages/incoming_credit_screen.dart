import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/navigation_extensions.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_progress_indecator.dart';
import 'package:golder_octopus/common/widgets/custom_text_field.dart';
import 'package:golder_octopus/common/widgets/toast_dialog.dart';
import 'package:golder_octopus/core/di/injection.dart';
import 'package:golder_octopus/features/credit/data/models/incoming_credits_response.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/incoming_credit_usecase.dart';
import 'package:golder_octopus/features/credit/presentation/bloc/credit_bloc.dart';
import 'package:golder_octopus/features/credit/presentation/pages/receive_credit_screen.dart';
import 'package:golder_octopus/features/credit/presentation/widgets/incoming_credit_container.dart';
import 'package:golder_octopus/features/credit/presentation/widgets/dialog/incoming_credit_details_dialog.dart';
import 'package:golder_octopus/features/transfer/data/models/trans_details_response.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';
import 'package:toastification/toastification.dart';

class IncomingCreditScreen extends StatefulWidget {
  const IncomingCreditScreen({super.key});

  @override
  State<IncomingCreditScreen> createState() => _IncomingCreditScreenState();
}

class _IncomingCreditScreenState extends State<IncomingCreditScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late IncomingCreditParams params;
  final int _itemsPerPage = 10;
  List<IncomingCreditsResponse> allCredits = [];
  List<IncomingCreditsResponse> visibleCredits = [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    params = IncomingCreditParams(startDate: _formatDateTime(DateTime(2000, 1, 2)));

    _scrollController.addListener(_onScroll);
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        // Reset pagination
        visibleCredits = allCredits.take(_itemsPerPage).toList();
      } else {
        // Filter all credits by source (case-insensitive)
        visibleCredits = allCredits.where((credit) => credit.source.toLowerCase().contains(query)).toList();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoadingMore) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    if (visibleCredits.length >= allCredits.length) return;

    setState(() => _isLoadingMore = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      final nextItems = allCredits.skip(visibleCredits.length).take(_itemsPerPage).toList();
      setState(() {
        visibleCredits.addAll(nextItems);
        _isLoadingMore = false;
      });
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  void _showDetailsDialog(BuildContext context, {required TransDetailsResponse transDetailsResponse}) {
    showDialog(
      context: context,
      builder: (context) {
        return IncomingCreditDetailsDialog(transDetailsResponse: transDetailsResponse);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<CreditBloc>()..add(GetIncomingCreditsEvent(params: params)),
      child: BlocListener<CreditBloc, CreditState>(
        listener: (context, state) {
          if (state.getIncomingCreditsStatus == Status.failure) {
            ToastificationDialog.showToast(msg: state.errorMessage!, context: context, type: ToastificationType.error);
          }
          if (state.incomingCreditDetailsStatus == Status.loading) {
            ToastificationDialog.showLoading(context: context);
          }
          if (state.incomingCreditDetailsStatus == Status.success && state.creditDetailsResponse != null) {
            if (state.isForDialog) {
              ToastificationDialog.dismiss();
              _showDetailsDialog(context, transDetailsResponse: state.creditDetailsResponse!);
            } else {
              ToastificationDialog.dismiss();
              context.push(ReceiveCreditScreen(transDetailsResponse: state.creditDetailsResponse!));
            }
          }
        },
        child: Scaffold(
          backgroundColor: context.background,
          body: Builder(
            builder: (context) {
              return RefreshIndicator(
                backgroundColor: context.primaryColor,
                color: context.onPrimaryColor,
                onRefresh: () async {
                  context.read<CreditBloc>().add(GetIncomingCreditsEvent(params: params));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 75),
                      width: context.screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.displaySmall(
                            LocaleKeys.home_incoming_credits.tr(),
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 20),
                          buildTextField(
                            hint: LocaleKeys.transfer_search.tr(),
                            sufIcon: Icon(Icons.search),
                            controller: searchController,
                          ),
                          SizedBox(height: 10),

                          Container(
                            decoration: BoxDecoration(
                              color: context.primaryContainer,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.credits_credit_source.tr(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    LocaleKeys.credits_amount.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          BlocBuilder<CreditBloc, CreditState>(
                            builder: (context, state) {
                              if (state.getIncomingCreditsStatus == Status.loading) {
                                return Center(child: CustomProgressIndecator(color: context.onPrimaryColor));
                              }

                              if (state.getIncomingCreditsStatus == Status.success) {
                                if (state.incomingCredits == null || state.incomingCredits!.isEmpty) {
                                  return Center(child: AppText.bodyMedium("لا يوجد اعتمادات واردة"));
                                }

                                if (allCredits.isEmpty) {
                                  allCredits = state.incomingCredits!;
                                  visibleCredits = allCredits.take(_itemsPerPage).toList();
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: visibleCredits.length + (_isLoadingMore ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index < visibleCredits.length) {
                                      return Column(
                                        children: [
                                          IncomingCreditContainer(incomingCredit: visibleCredits[index], index: index),
                                          SizedBox(height: 10),
                                        ],
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: CustomProgressIndecator(color: context.onPrimaryColor)),
                                      );
                                    }
                                  },
                                );
                              }

                              return Center(
                                child: AppText.bodyMedium("لا يوجد اعتمادات واردة", color: context.onPrimaryColor),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
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
  bool? readOnly,
  dynamic Function()? onTap,
  bool needValidation = true,
}) {
  return CustomTextField(
    onTap: onTap,
    readOnly: readOnly,
    mxLine: mxLine,
    controller: controller,
    hint: hint,
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
