import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_progress_indecator.dart';
import 'package:golder_octopus/common/widgets/sort_header.dart';
import 'package:golder_octopus/core/di/injection.dart';
import 'package:golder_octopus/features/auth/presentation/widgets/login_form.dart';
import 'package:golder_octopus/features/transfer/data/models/incoming_transfer_response.dart';
import 'package:golder_octopus/features/transfer/presentation/bloc/transfer_bloc.dart';
import 'package:golder_octopus/features/transfer/presentation/widgets/incoming_transfer_container.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class IncomingTransferScreen extends StatefulWidget {
  const IncomingTransferScreen({super.key});

  @override
  State<IncomingTransferScreen> createState() => _IncomingTransferScreenState();
}

class _IncomingTransferScreenState extends State<IncomingTransferScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final int _itemsPerPage = 10;
  List<Datum> allTransfers = [];
  List<Datum> visibleTransfers = [];
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<TransferBloc>()..add(GetIncomingTransfersEvent()),
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
                  columns: ['المستفيد', 'العمولة', 'المبلغ'].reversed.toList(),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                const SizedBox(height: 10),
                BlocBuilder<TransferBloc, TransferState>(
                  builder: (context, state) {
                    if (state.transferStatus == Status.loading) {
                      return Center(child: CustomProgressIndecator(color: context.onPrimaryColor));
                    }

                    if (state.transferStatus == Status.success) {
                      if (state.incomingTransfers == null || state.incomingTransfers!.data.isEmpty) {
                        return Center(child: AppText.bodyMedium("لا يوجد حوالات واردة"));
                      }

                      if (allTransfers.isEmpty) {
                        allTransfers = state.incomingTransfers!.data;
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

                    return Center(child: AppText.bodyMedium("لا يوجد حوالات واردة", color: context.onPrimaryColor));
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
