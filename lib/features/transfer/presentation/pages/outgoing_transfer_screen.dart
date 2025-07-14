import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_progress_indecator.dart';
import 'package:golder_octopus/common/widgets/custom_text_field.dart';
import 'package:golder_octopus/common/widgets/date_dropdown_field.dart';
import 'package:golder_octopus/common/widgets/large_button.dart';
import 'package:golder_octopus/common/widgets/sort_header.dart';
import 'package:golder_octopus/core/di/injection.dart';
import 'package:golder_octopus/features/transfer/data/models/outgoing_transfer_response.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/outgoing_transfers_usecase.dart';
import 'package:golder_octopus/features/transfer/presentation/bloc/transfer_bloc.dart';
import 'package:golder_octopus/features/transfer/presentation/widgets/outgoing_transfer_container.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

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
        visibleTransfers = allTransfers.where((transfer) => transfer.target.toLowerCase().contains(query)).toList();
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
      create: (context) => getIt<TransferBloc>(),
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
                    DateDropdownField(selectedDate: fromDate, onChanged: (picked) => setState(() => fromDate = picked)),
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
                SortHeader(columns: ['المستفيد', 'العمولة', 'المبلغ'].reversed.toList()),
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
