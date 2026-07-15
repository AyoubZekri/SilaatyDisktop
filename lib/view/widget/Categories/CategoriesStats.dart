import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../core/constant/Colorapp.dart';

class CategoriesStats extends StatelessWidget {
  const CategoriesStats({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Siedbarcontroller>();
    return Obx(() {
      final isDark = controller.isDarkMode.value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            _buildStatCard(
              title: 'total_cat_count'.tr,
              value: '12',
              icon: Icons.grid_view_rounded,
              iconBg: isDark ? const Color(0xFF1A2E44) : const Color(0xFFE3F2FD),
              iconColor: const Color(0xFF2196F3),
              isDark: isDark,
            ),
            _buildStatCard(
              title: 'active_cat'.tr,
              value: '10',
              icon: Icons.check_circle_outline_rounded,
              iconBg: isDark ? const Color(0xFF1E3A20) : const Color(0xFFE8F5E9),
              iconColor: const Color(0xFF4CAF50),
              isDark: isDark,
            ),
            _buildStatCard(
              title: 'avg_products'.tr,
              value: '24',
              icon: Icons.inventory_2_outlined,
              iconBg: isDark ? const Color(0xFF3B2E4A) : const Color(0xFFF3E5F5),
              iconColor: const Color(0xFF9C27B0),
              isDark: isDark,
            ),
            _buildStatCard(
              title: 'cat_growth'.tr,
              value: '+15%',
              icon: Icons.trending_up,
              iconBg: isDark ? const Color(0xFF1E3A20) : const Color(0xFFE8F5E9),
              iconColor: const Color(0xFF4CAF50),
              isDark: isDark,
              isBadge: true,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required bool isDark,
    bool isBadge = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 8),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: isDark ? AppColor.textDark : const Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColor.textSecondary : const Color(0xFF8E92BC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
