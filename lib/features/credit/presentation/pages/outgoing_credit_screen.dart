import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/size_extension.dart';
import '../../../../common/state_managment/bloc_state.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../common/widgets/custom_progress_indecator.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../common/widgets/date_dropdown_field.dart';
import '../../../../common/widgets/large_button.dart';
import '../../../../common/widgets/sort_header.dart';
import '../../../../common/widgets/toast_dialog.dart';
import '../../../../core/di/injection.dart';
import '../../data/models/outgoing_credits_response.dart';
import '../../domain/use_cases/outgoing_credit_usecase.dart';
import '../bloc/credit_bloc.dart';
import '../widgets/dialog/outgoing_credit_details_dialog.dart';
import '../widgets/outgoing_credit_container.dart';
import '../../../transfer/data/models/trans_details_response.dart';
import '../../../../generated/locale_keys.g.dart';
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

  void _sortTransfers(int index, SortDirection direction) {
    if (direction == SortDirection.none || direction == SortDirection.nothing) return;

    Comparator<OutgoingCreditResponse> comparator;

    switch (index) {
      case 0:
        comparator = (a, b) => a.target.compareTo(b.target);
        break;
      case 1:
        comparator = (a, b) => a.amount.compareTo(b.amount);
        break;
      default:
        return;
    }

    setState(() {
      allCredits.sort(direction == SortDirection.ascending ? comparator : (a, b) => comparator(b, a));
      visibleCredits = allCredits.take(_itemsPerPage).toList();
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }

  void _showDetailsDialog(BuildContext context, {required TransDetailsResponse transDetailsResponse}) {
    showDialog(
      context: context,
      builder: (context) {
        return OutgoingCreditDetailsDialog(transDetailsResponse: transDetailsResponse);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<CreditBloc>()
                ..add(GetOutgoingCreditsEvent(params: OutgoingCreditParams(startDate: "", endDate: ""))),
      child: BlocListener<CreditBloc, CreditState>(
        listener: (context, state) {
          if (state.getOutgoingCreditsStatus == Status.failure) {
            ToastificationDialog.showToast(msg: state.errorMessage!, context: context, type: ToastificationType.error);
          }
          if (state.outgoingCreditDetailsStatus == Status.loading) {
            ToastificationDialog.showLoading(context: context);
          }
          if (state.outgoingCreditDetailsStatus == Status.success && state.creditDetailsResponse != null) {
            ToastificationDialog.dismiss();
            _showDetailsDialog(context, transDetailsResponse: state.creditDetailsResponse!);
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
                                state.getOutgoingCreditsStatus == Status.loading
                                    ? () {}
                                    : () {
                                      final params = OutgoingCreditParams(
                                        startDate: _formatDateTime(fromDate!),
                                        endDate: _formatDateTime(toDate!),
                                      );
                                      allCredits.clear();
                                      visibleCredits.clear();
                                      context.read<CreditBloc>().add(GetOutgoingCreditsEvent(params: params));
                                    },
                            text: LocaleKeys.transfer_search.tr(),
                            backgroundColor: context.primaryContainer,
                            textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            circularRadius: 12,
                            child: state.getOutgoingCreditsStatus == Status.loading ? CustomProgressIndecator() : null,
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
                  SortHeader(
                    columns: [
                      SortColumn(label: "وجهة الاعتماد", onSort: (direction) => _sortTransfers(0, direction)),
                      SortColumn(label: "المبلغ", onSort: (direction) => _sortTransfers(1, direction)),
                    ],
                  ),

                  SizedBox(height: 10),
                  BlocBuilder<CreditBloc, CreditState>(
                    builder: (context, state) {
                      if (state.getOutgoingCreditsStatus == Status.success) {
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
