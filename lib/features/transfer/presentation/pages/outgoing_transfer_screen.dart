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
import '../../data/models/outgoing_transfer_response.dart';
import '../../data/models/trans_details_response.dart';
import '../../domain/use_cases/outgoing_transfers_usecase.dart';
import '../bloc/transfer_bloc.dart';
import 'outgoing_transfer_receipt_screen.dart';
import '../widgets/dialogs/outgoing_transfer_details_dialog.dart';
import '../widgets/outgoing_transfer_container.dart';
import '../../../../generated/locale_keys.g.dart';

class OutgoingTransferScreen extends StatefulWidget {
  const OutgoingTransferScreen({super.key});

  @override
  State<OutgoingTransferScreen> createState() => _OutgoingTransferScreenState();
}

class _OutgoingTransferScreenState extends State<OutgoingTransferScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final int _itemsPerPage = 10;

  List<OutgoingTransfers> allTransfers = [];
  List<OutgoingTransfers> visibleTransfers = [];
  bool _isLoadingMore = false;

  DateTime? fromDate = DateTime.now().subtract(Duration(days: 5));
  DateTime? toDate = DateTime.now();

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        visibleTransfers = allTransfers.take(_itemsPerPage).toList();
      } else {
        visibleTransfers =
            allTransfers.where((transfer) {
              final target = transfer.target.toLowerCase();
              final benename = transfer.benename.toLowerCase();
              final benephone = transfer.benephone.toLowerCase();
              final amount = transfer.amount.toString().toLowerCase();
              final tax = transfer.tax.toString().toLowerCase();
              final currencyName = transfer.currencyName.toString().toLowerCase();
              return target.contains(query) ||
                  amount.contains(query) ||
                  currencyName.contains(query) ||
                  benename.contains(query) ||
                  benephone.contains(query) ||
                  tax.contains(query);
            }).toList();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoadingMore) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    if (visibleTransfers.length >= allTransfers.length) return;

    setState(() => _isLoadingMore = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      final nextItems = allTransfers.skip(visibleTransfers.length).take(_itemsPerPage).toList();
      setState(() {
        visibleTransfers.addAll(nextItems);
        _isLoadingMore = false;
      });
    });
  }

  void _sortTransfers(String field, SortDirection direction) {
    if (direction == SortDirection.none || direction == SortDirection.nothing) return;

    Comparator<OutgoingTransfers> comparator;

    switch (field) {
      case 'المبلغ':
        comparator = (a, b) => a.amount.compareTo(b.amount);
        break;
      case 'العمولة':
        comparator = (a, b) => a.tax.compareTo(b.tax);
        break;
      case 'المستفيد':
        comparator = (a, b) => a.benename.compareTo(b.benename);
        break;
      default:
        return;
    }

    setState(() {
      allTransfers.sort(direction == SortDirection.ascending ? comparator : (a, b) => comparator(b, a));
      visibleTransfers = allTransfers.take(_itemsPerPage).toList();
    });
  }

  void _showDetailsDialog(BuildContext context, {required TransDetailsResponse transDetailsResponse}) {
    showDialog(
      context: context,
      builder: (context) {
        return OutgoingTransferDetailsDialog(transDetailsResponse: transDetailsResponse);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create:
          (context) =>
              getIt<TransferBloc>()..add(
                GetOutgoingTransfersEvent(
                  params: OutgoingTransferParams(
                    startDate: _formatDateTime(fromDate!),
                    endDate: _formatDateTime(toDate!),
                  ),
                ),
              ),
      child: BlocListener<TransferBloc, TransferState>(
        listener: (context, state) {
          if (state.transDetailsStatus == Status.loading) {
            ToastificationDialog.showLoading(context: context);
          }
          if (state.transDetailsStatus == Status.success && state.transDetailsResponse != null) {
            ToastificationDialog.dismiss();
            if (state.isForDialog) {
              _showDetailsDialog(context, transDetailsResponse: state.transDetailsResponse!);
            } else {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  fullscreenDialog: false,
                  builder:
                      (context) => OutgoingTransferReceiptScreen(transDetailsResponse: state.transDetailsResponse!),
                ),
              );
            }
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
                    LocaleKeys.transfer_outgoing_transfers.tr(),
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
                      BlocBuilder<TransferBloc, TransferState>(
                        builder: (context, state) {
                          return LargeButton(
                            width: 100,
                            onPressed:
                                state.outgoingTransferStatus == Status.loading
                                    ? () {}
                                    : () {
                                      final params = OutgoingTransferParams(
                                        startDate: _formatDateTime(fromDate!),
                                        endDate: _formatDateTime(toDate!),
                                      );
                                      allTransfers.clear();
                                      visibleTransfers.clear();
                                      context.read<TransferBloc>().add(GetOutgoingTransfersEvent(params: params));
                                    },
                            text: LocaleKeys.transfer_search.tr(),
                            backgroundColor: context.primaryContainer,
                            textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            circularRadius: 12,
                            child: state.outgoingTransferStatus == Status.loading ? CustomProgressIndecator() : null,
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
                      SortColumn(label: 'المبلغ', onSort: (direction) => _sortTransfers('المبلغ', direction)),
                      SortColumn(label: 'العمولة', onSort: (direction) => _sortTransfers('العمولة', direction)),
                      SortColumn(label: 'المستفيد', onSort: (direction) => _sortTransfers('المستفيد', direction)),
                    ],
                  ),
                  SizedBox(height: 10),
                  BlocBuilder<TransferBloc, TransferState>(
                    builder: (context, state) {
                      if (state.outgoingTransferStatus == Status.success) {
                        if (state.outgoingTransferResponse == null || state.outgoingTransferResponse!.data.isEmpty) {
                          return Center(child: AppText.bodyMedium("لا يوجد حوالات صادرة"));
                        }

                        if (allTransfers.isEmpty) {
                          allTransfers = state.outgoingTransferResponse!.data;
                          visibleTransfers = allTransfers.take(_itemsPerPage).toList();
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: visibleTransfers.length + (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < visibleTransfers.length) {
                              return Column(
                                children: [
                                  OutgoingTransferContainer(outgoingTransfers: visibleTransfers[index]),
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
