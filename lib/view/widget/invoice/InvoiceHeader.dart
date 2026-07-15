import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Dashpord/invoicesallcontroller.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';

class InvoiceHeader extends StatelessWidget {
  final bool isDark;
  final Color textColor;

  const InvoiceHeader({
    super.key,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'invoice_history'.tr,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'تتبع جميع مبيعاتك وحالات الدفع بشكل تفصيلي',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey : Colors.grey.shade500,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => Get.find<Siedbarcontroller>().changePage(4),
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text(
            'new_invoice'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryPurple,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }
}
