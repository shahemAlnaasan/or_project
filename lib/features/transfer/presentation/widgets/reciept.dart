import 'package:flutter/material.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/dotted_line.dart';

class Reciept extends StatelessWidget {
  final GlobalKey globalKey;
  final Map<String, String> data;
  const Reciept({super.key, required this.globalKey, required this.data});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RepaintBoundary(
        key: globalKey,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            spacing: 18,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildColumn("رقم الإشعار", data['ref']!, color: const Color.fromARGB(255, 19, 38, 160)),
                  _buildColumn("رقم الإشعار", data['ref']!, color: Color.fromARGB(255, 19, 38, 160)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildColumn("المصدر", data['source']!),
                  _buildColumn("الوجهة", data['destination']!),
                  _buildColumn("التاريخ", data['date']!),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildColumn("المستفيد", data['receiver']!),
                  _buildColumn("الجوال", data['phone']!),
                  _buildColumn("الرقم السري", data['secret']!, color: Colors.red),
                ],
              ),

              // const SizedBox(height: 10),
              AppText.bodyMedium(
                '${data['amount']} دولار',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              AppText.bodyMedium('الف دولار', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: _buildColumn("عنوان التسليم", data['address']!, crossAxisAlignment: CrossAxisAlignment.start),
              ),
              DottedLine(),
              Align(
                alignment: Alignment.centerRight,
                child: AppText.bodyMedium(
                  'ملاحظات هامة',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              AppText.bodyMedium(
                '-يتم تسليم الحوالة بعد التأكد من الهوية الأصلية ولا تُقبل الصورة.\n'
                '-لا تشارك هذا الإيصال إلا مع المستلم حرصًا على سلامة أموالك.',
                height: 1.8,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(String key, String value, {Color? color, CrossAxisAlignment? crossAxisAlignment}) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        AppText.bodyMedium(key, style: const TextStyle(color: Colors.black)),
        const SizedBox(height: 4),
        AppText.bodyMedium(value, style: TextStyle(fontWeight: FontWeight.bold, color: color ?? Colors.black)),
      ],
    );
  }
}
