import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import './BranchDialog.dart';

import '../../../controller/SellerController.dart';

class BranchHeader extends StatelessWidget {
  final bool isDark;
  final SellerController controller;
  const BranchHeader({super.key, required this.isDark, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "seller_management".tr,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "seller_management_desc".tr,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColor.textSecondary : Colors.grey.shade600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                color: isDark ? AppColor.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.1 : 0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.searchSellers,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "search_sellers".tr,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: 'Cairo',
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(width: 24),
            ElevatedButton.icon(
              onPressed: () {
                controller.openAddDialog();
                Get.dialog(BranchDialog(isDark: isDark, controller: controller));
              },
              icon: const Icon(
                Icons.person_add_alt_1_outlined,
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                "add_new_seller".tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
