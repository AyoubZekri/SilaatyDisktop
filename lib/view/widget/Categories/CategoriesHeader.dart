import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../core/constant/Colorapp.dart';

import './AddCategoryDialog.dart';

class CategoriesHeader extends StatelessWidget {
  const CategoriesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Siedbarcontroller>();
    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final titleColor = isDark ? AppColor.textDark : const Color(0xFF2D2D2D);
      final subtitleColor = isDark ? AppColor.textSecondary : const Color(0xFF8E92BC);

      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'manage_categories'.tr,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'categories_desc'.tr,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              textDirection: TextDirection.rtl,
              children: [
                // Add Button
                InkWell(
                  onTap: () {
                    Get.dialog(const AddCategoryDialog(isEdit: false));
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: AppColor.purpleGradient),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryPurple.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_rounded, color: Colors.white, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'add_new_category'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Search Bar
                Expanded(
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: isDark ? AppColor.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                    ),
                    child: TextField(
                      textAlign: TextAlign.right,
                      style: TextStyle(color: titleColor),
                      decoration: InputDecoration(
                        hintText: 'search_category'.tr,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white30 : Colors.grey,
                        ),
                        prefixIcon: Icon(Icons.search_rounded, color: isDark ? Colors.white30 : Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
