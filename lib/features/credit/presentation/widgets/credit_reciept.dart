import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/features/transfer/data/models/trans_details_response.dart';
import '../../../../common/utils/number_to_arabic_words.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../common/widgets/dotted_line.dart';
import '../../../../generated/assets.gen.dart';

class CreditReciept extends StatelessWidget {
  final GlobalKey globalKey;
  final TransDetailsResponse transDetailsResponse;
  const CreditReciept({super.key, required this.globalKey, required this.transDetailsResponse});

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

  String maskNumber(String number) {
    if (number.length <= 2) return number; // too short, return as is
    String visible = number.substring(0, 2);
    String hidden = '*' * (number.length - 2);
    return '$hidden $visible';
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(Assets.images.logo.companyLogo.path, scale: 16),
                ),
                const SizedBox(height: 1),
                AppText.titleSmall(
                  "ايصال اعتماد",
                  fontWeight: FontWeight.w100,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
                  textAlign: TextAlign.center,
                ),

                _buildColumn("الاشعار", transDetails.transnum),
                const SizedBox(height: 2),
                _buildColumn("المصدر", maskNumber(transDetails.srcBox)),
                const SizedBox(height: 2),
                _buildColumn("الوجهة", transDetails.targetBox),
                const SizedBox(height: 2),

                _buildColumn(
                  "المبلغ رقما",
                  "${transDetails.amount} ${transDetails.currencyName}",
                  color: const Color.fromARGB(255, 46, 131, 49),
                ),
                const SizedBox(height: 2),
                _buildColumn(
                  "المبلغ كتابة",
                  "${getFinalBalance(transDetails.amount)} ${transDetails.currencyName}",
                  color: const Color.fromARGB(255, 46, 131, 49),
                ),
                const SizedBox(height: 2),
                _buildColumn("البيان", ""),
                const SizedBox(height: 2),
                _buildColumn("التاريخ", DateFormat('yyyy-MM-dd HH:mm:ss').format(transDetails.transdate)),

                const SizedBox(height: 5),

                DottedLine(),
                AppText.bodyMedium(
                  "الاعتماد غير مخصص للزبائن وانما للمكاتب فقط لنقل الارصدة",
                  height: 1.5,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 5),
                AppText.bodySmall(
                  "يمنع منعا باتا قبول أي إعتماد من زبون وتسليمه حوالة مقابله - خصوصا اعمال اليوز ، في حال وجود أي مخالفة لهذا الأمر سيتم حجز الاعتماد و إغلاق الصندوق فورًا يرجى عدم قبول أي اعتماد لأعمال يوز أو لأعمال مشبوهه لزبائن خارجيين, المكتب الذي سيستلم الاعتماد مسؤول عن التحقق من مصدر الاعتماد تحت طائله حجز المبلغ",
                  height: 1.5,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: const Color.fromARGB(255, 228, 54, 42)),
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
    FontWeight? lableFontWeight,
  }) {
    return Row(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: AppText.bodyMedium(
            "$key:",
            fontWeight: lableFontWeight,
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          flex: 2,
          child: AppText.bodyMedium(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color ?? Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
