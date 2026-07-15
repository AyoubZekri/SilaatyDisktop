import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/Profaile/invoice/InvoiceController.dart';

class CSDetailsStats extends StatelessWidget {
  const CSDetailsStats({super.key});

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();
    final invoiceController = Get.find<InvoicesController>();

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;
      final surfaceColor = isDark ? AppColor.surfaceDark : Colors.white;

      return GetBuilder<InvoicesController>(
        builder: (controller) {
          final remainingAmount = controller.getRemainingAmount();
          final sumPayment = controller.invoice?.sumPaymentPrice ?? 0.0;
          final numInvoices = controller.invoice?.invoices?.length ?? 0;

          return Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'remaining_balance'.tr,
                  value: _formatNumber(double.tryParse(remainingAmount) ?? 0.0),
                  tag: 'due'.tr,
                  tagColor: Colors.redAccent,
                  icon: Icons.account_balance_wallet_outlined,
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildSummaryCard(
                  title: 'total_paid_amount'.tr,
                  value: _formatNumber(double.tryParse(sumPayment.toString()) ?? 0.0),
                  icon: Icons.payments_outlined,
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildSummaryCard(
                  title: 'total_invoices'.tr,
                  value: '$numInvoices',
                  icon: Icons.receipt_long_outlined,
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                ),
              ),
            ],
          );
        }
      );
    });
  }

  String _formatNumber(double number) {
    if (number == number.truncateToDouble()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    String? tag,
    Color? tagColor,
    String? trend,
    Color? trendColor,
    required IconData icon,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Fixed to Start Alignment for RTL
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (tagColor ?? AppColor.primaryPurple).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: tagColor ?? AppColor.primaryPurple, size: 24),
              ),
              if (tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: tagColor!.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(tag, style: TextStyle(color: tagColor, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: trendColor!.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(trend, style: TextStyle(color: trendColor, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: textColor),
              ),
              const SizedBox(width: 6),
              Text('currency_dz'.tr, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
