import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Statistice/PublicFinanceController.dart';

class FinanceSummaryCards extends StatelessWidget {
  final bool isDark;
  const FinanceSummaryCards({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Publicfinancecontroller>(builder: (controller) {
      final summary = controller.data?.summary;
      return Row(
        children: [
          _buildSummaryCard("total_revenue".tr, summary?.totalRevenue.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '') ?? "0", Icons.trending_up, Colors.green),
          const SizedBox(width: 24),
          _buildSummaryCard("financial_net_profit".tr, summary?.netProfit.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '') ?? "0", Icons.auto_graph_rounded, AppColor.primaryPurple),
          const SizedBox(width: 24),
          _buildSummaryCard("total_expenses".tr, summary?.totalExpenses.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '') ?? "0", Icons.trending_down, Colors.orange),
          const SizedBox(width: 24),
          _buildSummaryCard("invoice_count".tr, summary?.totalInvoices.toString() ?? "0", Icons.receipt_long_rounded, Colors.blue),
        ],
      );
    });
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColor.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 20),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColor.textSecondary : Colors.grey.shade500,
                fontWeight: FontWeight.w500,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
