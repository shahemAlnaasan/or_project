import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_progress_indecator.dart';
import 'package:golder_octopus/common/widgets/sort_header.dart';
import 'package:golder_octopus/common/widgets/toast_dialog.dart';
import 'package:golder_octopus/core/di/injection.dart';
import 'package:golder_octopus/features/auth/presentation/widgets/login_form.dart';
import 'package:golder_octopus/features/transfer/data/models/incoming_transfer_response.dart';
import 'package:golder_octopus/features/transfer/data/models/trans_details_response.dart';
import 'package:golder_octopus/features/transfer/presentation/bloc/transfer_bloc.dart';
import 'package:golder_octopus/features/transfer/presentation/widgets/dialogs/incoming_transfer_details_dialog.dart';
import 'package:golder_octopus/features/transfer/presentation/widgets/incoming_transfer_container.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';
import 'package:toastification/toastification.dart';

class IncomingTransferScreen extends StatefulWidget {
  const IncomingTransferScreen({super.key});

  @override
  State<IncomingTransferScreen> createState() => _IncomingTransferScreenState();
}

class _IncomingTransferScreenState extends State<IncomingTransferScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final int _itemsPerPage = 10;
  List<IncomingTransfers> allTransfers = [];
  List<IncomingTransfers> visibleTransfers = [];
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
        visibleTransfers = allTransfers.take(_itemsPerPage).toList();
      } else {
        visibleTransfers = allTransfers.where((transfer) => transfer.source.toLowerCase().contains(query)).toList();
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

    Comparator<IncomingTransfers> comparator;

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
        return IncomingTransferDetailsDialog(transDetailsResponse: transDetailsResponse);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<TransferBloc>()..add(GetIncomingTransfersEvent()),
      child: BlocListener<TransferBloc, TransferState>(
        listener: (context, state) {
          if (state.incomingTransferStatus == Status.failure) {
            ToastificationDialog.showToast(msg: state.errorMessage!, context: context, type: ToastificationType.error);
          }
          if (state.incomingTransDetailsStatus == Status.loading) {
            ToastificationDialog.showLoading(context: context);
          }
          if (state.incomingTransDetailsStatus == Status.success && state.incomingTransDetailsResponse != null) {
            ToastificationDialog.dismiss();
            _showDetailsDialog(context, transDetailsResponse: state.incomingTransDetailsResponse!);
          }
        },
        child: Scaffold(
          backgroundColor: context.background,
          body: Builder(
            builder: (context) {
              return RefreshIndicator(
                color: context.onPrimaryColor,
                onRefresh: () async {
                  context.read<TransferBloc>().add(GetIncomingTransfersEvent());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 75),
                    width: context.screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.displaySmall(
                          LocaleKeys.transfer_incoming_transfers.tr(),
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          hint: LocaleKeys.transfer_search.tr(),
                          sufIcon: const Icon(Icons.search),
                          controller: searchController,
                        ),
                        const SizedBox(height: 10),
                        SortHeader(
                          columns: [
                            SortColumn(label: 'المبلغ', onSort: (direction) => _sortTransfers('المبلغ', direction)),
                            SortColumn(label: 'العمولة', onSort: (direction) => _sortTransfers('العمولة', direction)),
                            SortColumn(label: 'المستفيد', onSort: (direction) => _sortTransfers('المستفيد', direction)),
                          ],
                        ),

                        const SizedBox(height: 10),
                        BlocBuilder<TransferBloc, TransferState>(
                          builder: (context, state) {
                            if (state.incomingTransferStatus == Status.loading) {
                              return Center(child: CustomProgressIndecator(color: context.onPrimaryColor));
                            }

                            if (state.incomingTransferStatus == Status.success) {
                              if (state.incomingTransferResponse == null ||
                                  state.incomingTransferResponse!.data.isEmpty) {
                                return Center(child: AppText.bodyMedium("لا يوجد حوالات واردة"));
                              }

                              if (allTransfers.isEmpty) {
                                allTransfers = state.incomingTransferResponse!.data;
                                visibleTransfers = allTransfers.take(_itemsPerPage).toList();
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: visibleTransfers.length + (_isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index < visibleTransfers.length) {
                                    return Column(
                                      children: [
                                        IncomingTransferContainer(incomingTransfers: visibleTransfers[index]),
                                        const SizedBox(height: 10),
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
                              child: AppText.bodyMedium("لا يوجد حوالات واردة", color: context.onPrimaryColor),
                            );
                          },
                        ),
                      ],
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
