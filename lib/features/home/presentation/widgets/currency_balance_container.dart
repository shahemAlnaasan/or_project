import 'package:flutter/material.dart';
import 'package:golder_octopus/core/config/app_config.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/navigation_extensions.dart';
import '../../../../common/extentions/size_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../account_statement/presentation/pages/account_statement_screen.dart';
import '../../data/models/account_info_response.dart';
import '../../../../generated/assets.gen.dart';

enum CurrencyType { turkish, dolar, euro, total }

class CurrencyBalanceContainer extends StatelessWidget {
  final Acc acc;

  const CurrencyBalanceContainer({super.key, required this.acc});

  String getIcon(String currencyName) {
    switch (currencyName) {
      case 'يورو':
        return Assets.images.flags.europe.path;
      case 'دولار':
        return Assets.images.flags.unitedStates.path;
      case 'ليرة تركية':
        return Assets.images.flags.turkey.path;
      case 'رصيد مقوم':
        return Assets.images.flags.balanceScale.path;
      default:
        return Assets.images.flags.balanceScale.path;
    }
  }

  CurrencyType getCurrencyType(String currency) {
    switch (currency.toLowerCase()) {
      case 'eur':
        return CurrencyType.euro;
      case 'usd':
        return CurrencyType.dolar;
      case 'tl':
        return CurrencyType.turkish;
      default:
        return CurrencyType.total;
    }
  }

  Color getColor(BuildContext context) {
    return acc.amount < 0 ? context.error : context.onTertiary;
  }

  String getBalanceDirectionText() {
    return acc.amount < 0 ? 'عليكم' : 'لكم';
  }

  @override
  Widget build(BuildContext context) {
    final color = getColor(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
      child: GestureDetector(
        onTap: () => context.push(AccountStatementScreen(currencyType: getCurrencyType(acc.currency))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          width: context.screenWidth,
          decoration: BoxDecoration(
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 5, offset: Offset(0, 4))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                "${AppConfig.imageUrl}${acc.currencyImg}",
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox.shrink();
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText.headlineMedium(
                    acc.amount.toStringAsFixed(2),
                    fontWeight: FontWeight.bold,
                    color: color,
                    textDirection: TextDirection.ltr,
                  ),
                  AppText.bodySmall(
                    "${acc.currencyName} ${getBalanceDirectionText()}",
                    textAlign: TextAlign.right,
                    color: color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
