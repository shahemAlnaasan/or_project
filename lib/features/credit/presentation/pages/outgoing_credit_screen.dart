import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_progress_indecator.dart';
import 'package:golder_octopus/common/widgets/custom_text_field.dart';
import 'package:golder_octopus/common/widgets/date_dropdown_field.dart';
import 'package:golder_octopus/common/widgets/large_button.dart';
import 'package:golder_octopus/common/widgets/sort_header.dart';
import 'package:golder_octopus/common/widgets/toast_dialog.dart';
import 'package:golder_octopus/core/di/injection.dart';
import 'package:golder_octopus/features/credit/data/models/outgoing_credits_response.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/outgoing_credit_usecase.dart';
import 'package:golder_octopus/features/credit/presentation/bloc/credit_bloc.dart';
import 'package:golder_octopus/features/credit/presentation/widgets/outgoing_credit_container.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';
import 'package:toastification/toastification.dart';

class OutgoingCreditScreen extends StatefulWidget {
  const OutgoingCreditScreen({super.key});

  @override
  State<OutgoingCreditScreen> createState() => _OutgoingCreditScreenState();
}

class _OutgoingCreditScreenState extends State<OutgoingCreditScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  DateTime? fromDate = DateTime.now().subtract(Duration(days: 5));
  DateTime? toDate = DateTime.now();

  final int _itemsPerPage = 10;
  List<OutgoingCreditResponse> allCredits = [];
  List<OutgoingCreditResponse> visibleCredits = [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
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
        visibleCredits = allCredits.take(_itemsPerPage).toList();
      } else {
        visibleCredits = allCredits.where((credit) => credit.target.toLowerCase().contains(query)).toList();
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
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreditBloc>(),
      child: BlocListener<CreditBloc, CreditState>(
        listener: (context, state) {
          if (state.status == CreditStatus.failure) {
            ToastificationDialog.showToast(msg: state.errorMessage!, context: context, type: ToastificationType.error);
          }
        },
        child: Scaffold(
          backgroundColor: context.background,
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 75),
              width: context.screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.displaySmall(
                    LocaleKeys.credits_outgoing_credits.tr(),
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.bodyMedium(LocaleKeys.transfer_from_date.tr()),
                      DateDropdownField(
                        selectedDate: fromDate,
                        onChanged: (picked) => setState(() => fromDate = picked),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.bodyMedium(LocaleKeys.transfer_to_date.tr()),
                      DateDropdownField(selectedDate: toDate, onChanged: (picked) => setState(() => toDate = picked)),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.bodyMedium(""),
                      BlocBuilder<CreditBloc, CreditState>(
                        builder: (context, state) {
                          return LargeButton(
                            width: 100,
                            onPressed:
                                state.status == CreditStatus.loading
                                    ? () {}
                                    : () {
                                      final params = OutgoingCreditParams(
                                        startDate: _formatDateTime(fromDate!),
                                        endDate: _formatDateTime(toDate!),
                                      );
                                      allCredits.clear(); // Reset old data
                                      visibleCredits.clear();
                                      context.read<CreditBloc>().add(GetOutgoingCreditsEvent(params: params));
                                    },
                            text: LocaleKeys.transfer_search.tr(),
                            backgroundColor: context.primaryContainer,
                            textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            circularRadius: 12,
                            child: state.status == CreditStatus.loading ? CustomProgressIndecator() : null,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Divider(color: context.onPrimaryColor),
                  SizedBox(height: 20),
                  buildTextField(
                    hint: LocaleKeys.transfer_search.tr(),
                    sufIcon: Icon(Icons.search),
                    controller: searchController,
                  ),
                  SizedBox(height: 10),
                  SortHeader(columns: ['وجهة الاعتماد', 'المبلغ']),
                  SizedBox(height: 10),
                  BlocBuilder<CreditBloc, CreditState>(
                    builder: (context, state) {
                      if (state.status == CreditStatus.success) {
                        if (state.outgoingCredits == null || state.outgoingCredits!.isEmpty) {
                          return Center(child: AppText.bodyMedium("لا يوجد اعتمادات صادرة"));
                        }

                        if (allCredits.isEmpty) {
                          allCredits = state.outgoingCredits!;
                          visibleCredits = allCredits.take(_itemsPerPage).toList();
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: visibleCredits.length + (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < visibleCredits.length) {
                              return Column(
                                children: [
                                  OutgoingCreditContainer(outgoingCreditsResponse: visibleCredits[index]),
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

                      return SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
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
