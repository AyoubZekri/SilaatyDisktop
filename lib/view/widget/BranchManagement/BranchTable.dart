import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import './BranchDialog.dart';
import '../../../controller/SellerController.dart';
import '../../../core/class/handlingview.dart';

class BranchTable extends StatelessWidget {
  final bool isDark;
  final ScrollController horizontalScroll;
  final ScrollController verticalScroll;
  final SellerController controller;

  const BranchTable({
    super.key,
    required this.isDark,
    required this.horizontalScroll,
    required this.verticalScroll,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (controller.filteredSellers.isEmpty) {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            "لا يوجد بائعين",
            style: TextStyle(
              color: isDark ? AppColor.textSecondary : Colors.grey.shade500,
              fontSize: 18,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      );
    } else {
      content = GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          mainAxisExtent: 200,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
        ),
        itemCount: controller.filteredSellers.length,
        itemBuilder: (context, index) {
          return _buildSellerCard(controller.filteredSellers[index]);
        },
      );
    }

    return Handlingview(
      statusrequest: controller.statusrequest,
      widget: content,
    );
  }

  Widget _buildSellerCard(Map seller) {
    final titleColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subtitleColor = isDark ? AppColor.textSecondary : Colors.grey.shade500;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "status_active".tr,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  IconButton(
                    onPressed: () {
                      controller.openEditDialog(seller);
                      Get.dialog(BranchDialog(isDark: isDark, controller: controller, sellerId: seller['id']));
                    },
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 22),
                  ),
                  IconButton(
                    onPressed: () => controller.deleteSeller(seller['id']),
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 22),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person_outline, color: Colors.blue, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      seller['name'] ?? '',
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(Icons.email_outlined, color: subtitleColor, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            seller['email'] ?? '',
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 14,
                              fontFamily: 'Cairo',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
