import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Dashpord/invoicesallcontroller.dart';

class InvoiceStatsBoard extends StatelessWidget {
  final bool isDark;
  final Color textColor;

  const InvoiceStatsBoard({
    super.key,
    required this.isDark,
    required this.textColor,
  });

  String _formatNumber(double number) {
    if (number == number.truncateToDouble()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Invoicesallcontroller>();
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        _buildStatCard(
          'إجمالي الفواتير',
          '${controller.invoices.length}',
          Icons.receipt_long_rounded,
          Colors.blue,
        ),
        const SizedBox(width: 24),
        _buildStatCard(
          'المبالغ المحصلة',
          '${_formatNumber(controller.totalCollected)} ${'dz'.tr}',
          Icons.check_circle_rounded,
          Colors.green,
        ),
        const SizedBox(width: 24),
        _buildStatCard(
          'مبالغ معلقة',
          '${_formatNumber(controller.totalPending)} ${'dz'.tr}',
          Icons.pending_actions_rounded,
          Colors.orange,
        ),
        const SizedBox(width: 24),
        _buildStatCard(
          'متأخرة السداد',
          '${controller.totalOverdue}',
          Icons.report_problem_rounded,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColor.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
