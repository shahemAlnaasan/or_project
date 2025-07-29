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
import '../../../../core/di/injection.dart';
import '../../data/models/received_transfer_response.dart';
import '../../domain/use_cases/received_transfers_usecase.dart';
import '../bloc/transfer_bloc.dart';
import '../widgets/received_transfer_container.dart';
import '../../../../generated/locale_keys.g.dart';

class ReceivedTransferScreen extends StatefulWidget {
  const ReceivedTransferScreen({super.key});

  @override
  State<ReceivedTransferScreen> createState() => _OutgoingTransferScreenState();
}

class _OutgoingTransferScreenState extends State<ReceivedTransferScreen> {
  final TextEditingController searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  final int _itemsPerPage = 10;

  List<ReceivedTransfers> allTransfers = [];
  List<ReceivedTransfers> visibleTransfers = [];

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
            allTransfers
                .where((transfer) => transfer.source.toLowerCase().contains(query)) // adjust field accordingly
                .toList();
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

  void _sortTransfers(int index, SortDirection direction) {
    if (direction == SortDirection.none || direction == SortDirection.nothing) return;

    Comparator<ReceivedTransfers> comparator;

    switch (index) {
      case 0:
        comparator = (a, b) => a.source.compareTo(b.source);
        break;
      case 1:
        comparator = (a, b) => a.amount.compareTo(b.amount);
        break;
      default:
        return;
    }

    setState(() {
      allTransfers.sort(direction == SortDirection.ascending ? comparator : (a, b) => comparator(b, a));
      visibleTransfers = allTransfers.take(_itemsPerPage).toList();
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
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TransferBloc>(),
      child: Scaffold(
        backgroundColor: context.background,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 75),
            width: context.screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.displaySmall(
                  LocaleKeys.home_recived_transfer.tr(),
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
                              state.receivedTransferStatus == Status.loading
                                  ? () {}
                                  : () {
                                    final ReceivedTransfersParams params = ReceivedTransfersParams(
                                      startDate: _formatDateTime(fromDate!),
                                      endDate: _formatDateTime(toDate!),
                                    );
                                    context.read<TransferBloc>().add(GetReceivedTransfersEvent(params: params));
                                  },
                          text: LocaleKeys.transfer_search.tr(),
                          backgroundColor: context.primaryContainer,
                          textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),

                          circularRadius: 12,
                          child: state.receivedTransferStatus == Status.loading ? CustomProgressIndecator() : null,
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
                    SortColumn(
                      label: LocaleKeys.credits_destination.tr(),
                      onSort: (direction) => _sortTransfers(0, direction),
                    ),
                    SortColumn(
                      label: LocaleKeys.credits_money_amount.tr(),
                      onSort: (direction) => _sortTransfers(1, direction),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                BlocBuilder<TransferBloc, TransferState>(
                  builder: (context, state) {
                    if (state.receivedTransferStatus == Status.success) {
                      if (state.receivedTransfersResponse == null || state.receivedTransfersResponse!.data.isEmpty) {
                        return Center(child: AppText.bodyMedium("لا يوجد حوالات صادرة"));
                      }

                      if (allTransfers.isEmpty) {
                        allTransfers = state.receivedTransfersResponse!.data;
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
                                ReceivedTransferContainer(receivedTransfers: visibleTransfers[index]),
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
