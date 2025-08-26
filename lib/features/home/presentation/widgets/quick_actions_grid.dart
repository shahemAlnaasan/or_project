import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/features/transfer/presentation/pages/forms_screens/withdrawl_transfer_screen.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/navigation_extensions.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../account_statement/presentation/pages/account_statement_screen.dart';
import '../../../credit/presentation/pages/incoming_credit_screen.dart';
import '../../../credit/presentation/pages/outgoing_credit_screen.dart';
import '../../../credit/presentation/pages/send_credit_screen.dart';
import '../../../exchange/presentation/pages/cut_exchange_screen.dart';
import '../../../transfer/presentation/pages/incoming_transfer_screen.dart';
import '../../../transfer/presentation/pages/forms_screens/international_transfer_screen.dart';
import '../../../transfer/presentation/pages/forms_screens/new_transfer_screen.dart';
import '../../../transfer/presentation/pages/outgoing_transfer_screen.dart';
import '../../../transfer/presentation/pages/received_transfer_screen.dart';
import '../../../transfer/presentation/pages/forms_screens/syrian_transfer_screen.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locale_keys.g.dart';

class QuickActionsGrid extends StatefulWidget {
  const QuickActionsGrid({super.key});

  @override
  State<QuickActionsGrid> createState() => _QuickActionsGridState();
}

class _QuickActionsGridState extends State<QuickActionsGrid> {
  @override
  Widget build(BuildContext context) {
    final List<GridItem> gridItems = [
      GridItem(
        icon: Assets.images.quickActions.transfer.path,
        label: LocaleKeys.home_send_transfer.tr(),
        onTap: () => context.push(NewTransferScreen()),
      ),
      GridItem(
        icon: Assets.images.quickActions.usdt.path,
        label: "حوالة USDT",
        onTap: () => context.push(SyrianTransferScreen()),
      ),
      GridItem(
        icon: Assets.images.quickActions.international.path,
        label: LocaleKeys.home_international_transfer.tr(),
        onTap: () => context.push(InternationalTransferScreen()),
      ),
      GridItem(
        icon: Assets.images.quickActions.accountStatement.path,
        label: LocaleKeys.home_account_statement.tr(),
        onTap: () => context.push(AccountStatementScreen()),
      ),
      GridItem(
        icon: Assets.images.quickActions.outgoingTransfer.path,
        label: LocaleKeys.home_outgoing_transfers.tr(),
        onTap: () => context.push(OutgoingTransferScreen()),
      ),
      GridItem(
        icon: Assets.images.quickActions.incomingTransfer.path,
        label: LocaleKeys.home_incoming_transfer.tr(),
        onTap: () => context.push(IncomingTransferScreen()),
      ),
      GridItem(
        icon: Assets.images.quickActions.receiveMoney.path,
        label: LocaleKeys.home_recived_transfer.tr(),
        onTap: () => context.push(ReceivedTransferScreen()),
      ),
      GridItem(
        icon: Assets.images.quickActions.sendCredit.path,
        label: LocaleKeys.home_send_credit.tr(),
        onTap: () => context.push(SendCreditScreen()),
      ),
      GridItem(
        icon: Assets.images.quickActions.outgoingCredit.path,
        label: LocaleKeys.home_outgoing_credits.tr(),
        onTap: () => context.push(OutgoingCreditScreen()),
      ),
      GridItem(
        icon: Assets.images.quickActions.incomingCredit.path,
        label: LocaleKeys.home_incoming_credits.tr(),
        onTap: () => context.push(IncomingCreditScreen()),
      ),
      GridItem(
        icon: Assets.images.quickActions.shearBone.path,
        label: LocaleKeys.home_shear_bond.tr(),
        onTap: () => context.push(CutExchangeScreen()),
      ),
      GridItem(
        icon: Assets.images.quickActions.moneyWithdraw.path,
        label: LocaleKeys.home_withdrawl_transfer.tr(),
        onTap: () => context.push(WithdrawlTransferScreen()),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 1),
        itemCount: gridItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          // mainAxisExtent: 150,
          crossAxisCount: 4,
          crossAxisSpacing: 15,
          mainAxisSpacing: 10,
          childAspectRatio: 1 / 1.35,
        ),
        itemBuilder: (context, index) {
          final item = gridItems[index];
          return GestureDetector(
            onTap: item.onTap,
            child: Container(
              decoration: BoxDecoration(
                color: context.primaryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: const Color(0x20000000), blurRadius: 5, offset: const Offset(0, 4))],
              ),
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(item.icon, scale: 2.6),
                  const SizedBox(height: 4),
                  Flexible(
                    child: AppText.labelMedium(
                      item.label,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class GridItem {
  final String icon;
  final String label;
  final VoidCallback onTap;

  GridItem({required this.icon, required this.label, required this.onTap});
}
