import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Profaile/transaction/transactionController.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import 'AddCSDialog.dart';

class CSFilterBar extends StatelessWidget {
  const CSFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final csController = Get.find<Transactioncontroller>();
    final sidebarController = Get.find<Siedbarcontroller>();

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;
      final fieldColor = isDark
          ? Colors.white.withOpacity(0.05)
          : const Color(0xFFF7F8FA);

      return Row(
        textDirection: TextDirection.rtl,
        children: [
          // Add Button
          ElevatedButton.icon(
            onPressed: () async {
              await Get.dialog(const AddCSDialog());
              Get.find<Transactioncontroller>().getTransactions();
            },
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
            label: Text(
              'add_new'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryPurple,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
          const SizedBox(width: 16),
          // Search Field
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
              ),
              child: TextField(
                textAlign: TextAlign.right,
                style: TextStyle(color: textColor, fontSize: 15),
                onChanged: (val) => csController.onSearch(val),
                decoration: InputDecoration(
                  hintText: 'search_cs'.tr,
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
