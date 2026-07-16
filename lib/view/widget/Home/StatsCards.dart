import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/HomeScreen/HomeController.dart';
import '../../../core/constant/Colorapp.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Siedbarcontroller>();
    return GetBuilder<Homecontroller>(
      builder: (homeController) {
        return Obx(() {
          final isDark = controller.isDarkMode.value;
          final stats = homeController.statisticsHome;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                _buildStatCard(
                  title: 'net_profit'.tr,
                  value: '${(stats?.todayNetProfit ?? 0).toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')} ${'dzd'.tr}',
                  percentage: '', // removed percentage for now as it's not dynamically calculated
                  isPositive: true,
                  icon: Icons.trending_up,
                  iconBg: isDark
                      ? const Color(0xFF1E3A20)
                      : const Color(0xFFE8F5E9),
                  iconColor: const Color(0xFF4CAF50),
                  isDark: isDark,
                ),
                _buildStatCard(
                  title: 'today_income'.tr,
                  value: '${(stats?.todayIncome ?? 0).toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')} ${'dzd'.tr}',
                  percentage: '',
                  isPositive: true,
                  icon: Icons.account_balance_wallet_outlined,
                  iconBg: isDark
                      ? const Color(0xFF1A2E44)
                      : const Color(0xFFE3F2FD),
                  iconColor: const Color(0xFF2196F3),
                  isDark: isDark,
                ),
                _buildStatCard(
                  title: 'low_stock'.tr,
                  value: '${stats?.lowStockCount ?? 0}',
                  percentage: 'product'.tr,
                  isPositive: false,
                  icon: Icons.warning_amber_rounded,
                  iconBg: isDark
                      ? const Color(0xFF3D1F1F)
                      : const Color(0xFFFFEBEE),
                  iconColor: const Color(0xFFEF5350),
                  isDark: isDark,
                ),
                _buildStatCard(
                  title: 'today_invoices_count'.tr,
                  value: '${stats?.todayInvoices ?? 0}',
                  percentage: 'invoice'.tr,
                  isPositive: true,
                  icon: Icons.shopping_basket_outlined,
                  iconBg: isDark
                      ? const Color(0xFF3A2D1F)
                      : const Color(0xFFFFF3E0),
                  iconColor: const Color(0xFFFFA726),
                  hasAvatars: true,
                  isDark: isDark,
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String percentage,
    required bool isPositive,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required bool isDark,
    bool hasAvatars = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColor.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: iconBg.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    percentage,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColor.textSecondary
                    : const Color(0xFF8E92BC),
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: isDark ? AppColor.textDark : const Color(0xFF5D596C),
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
