import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/items/ItemsController.dart';
import '../../../core/constant/Colorapp.dart';

class StockStatsBoard extends StatelessWidget {
  const StockStatsBoard({super.key});

  String _formatNumber(dynamic value) {
    if (value == null) return '0';
    double? parsed;
    if (value is String) {
      parsed = double.tryParse(value);
    } else if (value is num) {
      parsed = value.toDouble();
    }
    if (parsed == null) return '0';
    if (parsed == parsed.toInt()) {
      return parsed.toInt().toString();
    }
    return parsed.toString();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Siedbarcontroller>();
    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final titleColor = isDark ? AppColor.textDark : const Color(0xFF2D2D2D);
      final subtitleColor = isDark
          ? AppColor.textSecondary
          : const Color(0xFF8E92BC);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: GetBuilder<Itemscontroller>(
            builder: (itemsCtrl) {
              return Row(
                children: [
                  _buildStatCard(
                    title: 'total_sale_val'.tr,
                    value: _formatNumber(itemsCtrl.totalSaleValue),
                    currency: 'currency_dz'.tr,
                    isDark: isDark,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                  ),
                  SizedBox(width: 12),
                  _buildStatCard(
                    title: 'total_purchase_val'.tr,
                    value: _formatNumber(itemsCtrl.totalPurchaseValue),
                    currency: 'currency_dz'.tr,
                    isDark: isDark,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                  ),
                  SizedBox(width: 12),

                  _buildStatCard(
                    title: 'total_products'.tr,
                    value: _formatNumber(itemsCtrl.totalProductsCount),
                    unit: 'items'.tr,
                    isDark: isDark,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                  ),
                  SizedBox(width: 12),

                  _buildAlertCard(isDark, itemsCtrl.lowStockCount),
                ],
              );
            }
          ),
        ),
      );
    });
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    String? currency,
    String? percentage,
    String? trend,
    String? unit,
    required bool isDark,
    required Color titleColor,
    required Color subtitleColor,
  }) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: subtitleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (percentage != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    percentage,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (trend != null)
                Text(
                  trend,
                  style: TextStyle(color: subtitleColor, fontSize: 12),
                ),
              if (unit != null)
                Text(
                  unit,
                  style: TextStyle(color: subtitleColor, fontSize: 12),
                ),
              const Spacer(),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  if (currency != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      currency,
                      style: TextStyle(fontSize: 14, color: subtitleColor),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(bool isDark, int count) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9F43).withOpacity(isDark ? 0.1 : 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFF9F43).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFFF9F43),
            size: 32,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'low_stock_alert'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFFF9F43),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9F43),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'items'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFF9F43),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
