import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';

import '../../../controller/Statistice/ClientsAndSuppliersController.dart';
import '../../../core/class/Statusrequest.dart';

class ReportsCSSummary extends StatelessWidget {
  final bool isDark;
  const ReportsCSSummary({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientsAndSuppliersController>(builder: (controller) {
      if (controller.statusrequest == Statusrequest.loadeng) {
        return const Center(child: CircularProgressIndicator());
      }
      
      final summary = controller.data?.summary;
      final totalSold = summary?.totalSold ?? 0.0;
      final totalDebts = summary?.totalDebts ?? 0.0;

      return Row(
        children: [
          _buildStatCard(
            isDark: isDark,
            title: controller.activeTab == 0 ? "total_sales".tr : "total_purchases".tr,
            amount: totalSold,
            color: Colors.green,
          ),
          const SizedBox(width: 24),
          _buildStatCard(
            isDark: isDark,
            title: "total_debts".tr,
            amount: totalDebts,
            color: Colors.redAccent,
          ),
        ],
      );
    });
  }

  Widget _buildStatCard({required bool isDark, required String title, required double amount, required Color color}) {
    return Expanded(
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: isDark ? AppColor.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border(right: BorderSide(color: color, width: 4)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: isDark ? AppColor.textSecondary : Colors.grey.shade600, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text("currency_dz".tr, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text(
                  amount.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), ''),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF1E293B)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
