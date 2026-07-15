import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/Profaile/invoice/InvoiceController.dart';

class CSDetailsHeader extends StatelessWidget {
  final String name;
  final String type;

  const CSDetailsHeader({
    super.key,
    required this.name,
    this.type = 'customer',
  });

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();
    final invoiceController = Get.find<InvoicesController>();

    String _formatNumber(double number) {
      if (number == number.truncateToDouble()) {
        return number.toInt().toString();
      }
      return number.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
    }

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;
      final surfaceColor = isDark ? AppColor.surfaceDark : Colors.white;

      return Column(
        children: [

            GetBuilder<InvoicesController>(
              builder: (controller) {
                final phone = controller.invoice?.transaction?.phoneNumber ?? '+966 50 123 4567';
                final remainingAmount = controller.getRemainingAmount();
                
                return Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryPurple.withOpacity(
                          isDark ? 0.15 : 0.08,
                        ),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppColor.primaryPurple.withOpacity(0.05),
                    ),
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      // 1. Avatar
                      Container(
                        width: 120,
                        height: 120,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.primaryPurple.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColor.primaryPurple,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            name.isNotEmpty ? name.substring(0, 1) : '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),

                      // 2. Name & Phone Group (Fixed to Start Alignment for RTL)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: textColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              textDirection: TextDirection.rtl,
                              children: [
                                Icon(
                                  Icons.phone_iphone_rounded,
                                  color: AppColor.primaryPurple.withOpacity(0.6),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  phone,
                                  style: TextStyle(
                                    color: textColor.withOpacity(0.6),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 40),
                      // 3. Vertical Divider
                      Container(
                        height: 80,
                        width: 1,
                        color: isDark
                            ? Colors.white10
                            : Colors.black.withOpacity(0.05),
                      ),
                      const SizedBox(width: 40),

                      // 4. Stylish Balance Display (Fixed to Start Alignment for RTL)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'total_due_balance'.tr,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              textDirection: TextDirection.rtl,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  _formatNumber(double.tryParse(remainingAmount) ?? 0.0),
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'currency_dz'.tr,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
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
            ),
        ],
      );
    });
  }
}
