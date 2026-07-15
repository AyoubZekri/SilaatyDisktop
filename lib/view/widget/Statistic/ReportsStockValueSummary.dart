import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/class/Statusrequest.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Statistice/StockValueController.dart';

class ReportsStockValueSummary extends StatelessWidget {
  final bool isDark;
  const ReportsStockValueSummary({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Stockvaluecontroller>(
      builder: (controller) {
        if (controller.statusrequest == Statusrequest.loadeng) {
          return const Center(child: CircularProgressIndicator());
        }
        final summary = controller.data?.summary;
        final totalStart = summary?.totalStart ?? 0.0;
        final totalIn = summary?.totalIn ?? 0.0;
        final totalSold = summary?.totalSold ?? 0.0;
        final totalEnd = summary?.totalEnd ?? 0.0;

        return Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildSummaryCard(
                    "opening_stock_value".tr,
                    "${totalStart.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')} ${"currency_dz".tr}",
                    null,
                    Icons.inventory_2_outlined,
                    isDark,
                    Colors.blue,
                  ),
                  const SizedBox(height: 24),
                  _buildSummaryCard(
                    "purchases_value".tr,
                    "${totalIn.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')} ${"currency_dz".tr}",
                    null,
                    Icons.input_rounded,
                    isDark,
                    Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  _buildSummaryCard(
                    "sales_value".tr,
                    "${totalSold.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')} ${"currency_dz".tr}",
                    null,
                    Icons.shopping_bag_outlined,
                    isDark,
                    Colors.indigo,
                  ),
                  const SizedBox(height: 24),
                  _buildSummaryCard(
                    "closing_stock_value".tr,
                    "${totalEnd.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')} ${"currency_dz".tr}",
                    null,
                    Icons.check_circle_outline,
                    isDark,
                    Colors.green,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    String? badge,
    IconData icon,
    bool isDark,
    Color iconColor,
  ) {
    return Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColor.textSecondary : Colors.grey.shade500,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 4),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
        ],
      ),
    );
  }
}
