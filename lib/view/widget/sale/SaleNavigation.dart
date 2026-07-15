import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';

class SaleNavigation extends StatelessWidget {
  const SaleNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final surfaceColor = isDark ? AppColor.surfaceDark : Colors.white;
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;

      return Container(
        width: 140, // Narrow sidebar like the image
        height: double.infinity,
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border(
            left: BorderSide(
              color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
            ),
          
          )),
        child: Column(
          children: [
            const SizedBox(height: 32),
            // User Avatar (Top)
            _buildAvatar(isDark),
            const SizedBox(height: 32),
            
            // Menu Items
            _buildNavItem(Icons.grid_view_rounded, 'home'.tr, false, isDark, textColor),
            _buildNavItem(Icons.shopping_cart_rounded, 'sales_title'.tr, true, isDark, textColor),
            _buildNavItem(Icons.assessment_outlined, 'reports'.tr, false, isDark, textColor),
            _buildNavItem(Icons.inventory_2_outlined, 'products'.tr, false, isDark, textColor),
            _buildNavItem(Icons.settings_outlined, 'settings'.tr, false, isDark, textColor),
            
            const Spacer(),
            
            // Bottom Actions
            _buildActionCard(isDark),
            const SizedBox(height: 16),
            _buildNavItem(Icons.help_outline_rounded, 'support'.tr, false, isDark, textColor),
            _buildNavItem(Icons.logout_rounded, 'logout'.tr, false, isDark, Colors.redAccent),
            const SizedBox(height: 32),
          ],
        ),
      );
    });
  }

  Widget _buildAvatar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.primaryPurple.withOpacity(0.3), width: 2),
      ),
      child: const CircleAvatar(
        radius: 22,
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2014/04/03/10/32/businessman-310819_1280.png'),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, bool isDark, Color color) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: isActive 
            ? Border(right: BorderSide(color: AppColor.primaryPurple, width: 4))
            : null,
          color: isActive ? AppColor.primaryPurple.withOpacity(0.05) : Colors.transparent,
        ),
        child: Column(
          children: [
            Icon(
              icon, 
              color: isActive ? AppColor.primaryPurple : color.withOpacity(0.6), 
              size: 26
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? AppColor.primaryPurple : color.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.primaryPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.add_shopping_cart_rounded, color: AppColor.primaryPurple),
          const SizedBox(height: 8),
          Text(
            'new_invoice'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryPurple,
            ),
          ),
        ],
      ),
    );
  }
}
