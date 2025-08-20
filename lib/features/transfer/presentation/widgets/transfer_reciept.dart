import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../common/utils/number_to_arabic_words.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../common/widgets/dotted_line.dart';
import '../../data/models/trans_details_response.dart';
import '../../../../generated/assets.gen.dart';

class TransferReciept extends StatelessWidget {
  final GlobalKey globalKey;
  final TransDetailsResponse transDetailsResponse;
  const TransferReciept({super.key, required this.globalKey, required this.transDetailsResponse});

  String getFinalBalance(String amount) {
    String balanceInWords = NumberToArabicWords.convertToWords(double.tryParse(amount)?.toInt() ?? 0);

    return balanceInWords;
  }

  String setDerliverAddress(Data transDetails) {
    if (transDetails.apiInfo == "false") {
      return "${transDetails.targetAddress} ${transDetails.targetName}";
    } else {
      return transDetails.apiInfo;
    }
  }

  String setTransNum(Data transDetails) {
    if (transDetails.apiInfo == "false") {
      return transDetails.transnum;
    } else {
      return transDetails.apiTransnum;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Data transDetails = transDetailsResponse.data;
    return Expanded(
      child: SingleChildScrollView(
        child: RepaintBoundary(
          key: globalKey,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(10, 16, 10, 0),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(Assets.images.logo.companyLogo.path, scale: 14),
                    if (transDetails.api != "false")
                      Image.network(
                        transDetails.header,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox.shrink();
                        },
                      ),
                    Align(
                      alignment: Alignment.center,
                      child: _buildColumn(
                        "رقم الإشعار",
                        setTransNum(transDetails),
                        color: Color.fromARGB(255, 19, 38, 160),
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        textAlign: TextAlign.center,
                        lableFontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  spacing: 10,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildColumn("المصدر", transDetails.srcName)),
                    Expanded(child: _buildColumn("الوجهة", transDetails.targetBox)),
                    Expanded(
                      child: _buildColumn("التاريخ", DateFormat('yyyy-MM-dd HH:mm:ss').format(transDetails.transdate)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(child: _buildColumn("المستفيد", transDetails.benifName)),
                    Expanded(child: _buildColumn("الجوال", transDetails.benifPhone)),
                    Expanded(child: _buildColumn("الرقم السري", transDetails.password, color: Colors.red)),
                  ],
                ),

                const SizedBox(height: 5),
                AppText.bodyMedium(
                  '${transDetails.amount} ${transDetails.currencyName}',
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                AppText.bodyMedium(
                  '${getFinalBalance(transDetails.amount)} ${transDetails.currencyName}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildColumn(
                    "عنوان التسليم",
                    setDerliverAddress(transDetails),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    lableFontWeight: FontWeight.bold,
                  ),
                ),
                DottedLine(),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppText.bodyMedium(
                    'ملاحظات هامة',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                SizedBox(height: 5),
                AppText.bodyMedium(
                  '-يتم تسليم الحوالة بيد المستلم حصراً بعد التأكد من الهوية الأصلية ولا تُقبل الصورة.\n'
                  '-لا تشارك هذا الإيصال إلا مع المستلم حرصًا على سلامة أموالك.',
                  height: 1.8,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(
    String key,
    String value, {
    Color? color,
    CrossAxisAlignment? crossAxisAlignment,
    TextAlign? textAlign,
    FontWeight? lableFontWeight,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        AppText.bodyMedium(
          key,
          fontWeight: lableFontWeight,
          style: const TextStyle(color: Colors.black),
          textAlign: textAlign,
        ),
        const SizedBox(height: 4),
        AppText.bodyMedium(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color ?? Colors.black),
          textAlign: textAlign,
        ),
      ],
    );
  }
}
