import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/HomeScreen/HomeController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/class/handlingview.dart';

class TransactionsTable extends StatelessWidget {
  const TransactionsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Siedbarcontroller>();
    return GetBuilder<Homecontroller>(
      builder: (homeController) {
        return Obx(() {
          final isDark = controller.isDarkMode.value;
          final titleColor = isDark ? AppColor.textDark : const Color(0xFF5D596C);

          return Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
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
                    Text(
                      'recent_transactions'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: titleColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('view_all'.tr, style: const TextStyle(color: AppColor.primaryPurple, fontFamily: 'Cairo')),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTableHeader(isDark),
                Divider(color: isDark ? Colors.white10 : Colors.black12),
                Handlingview(
                  statusrequest: homeController.staticrequest,
                  widget: homeController.recentTransactions.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text('no_recent_transactions'.tr, style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontFamily: 'Cairo')),
                          ),
                        )
                      : Column(
                          children: homeController.recentTransactions.map((tx) {
                            return _buildTableRow(
                              tx['product_name'] ?? 'product'.tr,
                              tx['invoies_date'] ?? '',
                              tx['customer_name'] ?? 'unknown_customer'.tr,
                              'completed'.tr, // Assuming completed for now
                              '${tx['subtotal']} ${'dzd'.tr}',
                              Colors.green,
                              Icons.check_circle_outline,
                              isDark,
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          );
        });
      }
    );
  }

  Widget _buildTableHeader(bool isDark) {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: isDark ? AppColor.textSecondary : const Color(0xFF8E92BC),
      fontSize: 13,
      fontFamily: 'Cairo',
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
           Expanded(flex: 2, child: Text('product'.tr, textAlign: TextAlign.right, style: headerStyle)),
           Expanded(flex: 2, child: Text('date'.tr, textAlign: TextAlign.right, style: headerStyle)),
           Expanded(flex: 2, child: Text('customer'.tr, textAlign: TextAlign.right, style: headerStyle)),
           Expanded(flex: 1, child: Text('status'.tr, textAlign: TextAlign.right, style: headerStyle)),
           Expanded(flex: 1, child: Text('amount'.tr, textAlign: TextAlign.right, style: headerStyle)),
        ],
      ),
    );
  }

  Widget _buildTableRow(String product, String date, String customer, String status, String amount, Color statusColor, IconData icon, bool isDark) {
    final titleColor = isDark ? AppColor.textDark : const Color(0xFF5D596C);
    final subtitleColor = isDark ? AppColor.textSecondary : const Color(0xFF8E92BC);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF3F4F9), borderRadius: BorderRadius.circular(8)),
                  child:  Icon(icon, size: 18, color: AppColor.primaryPurple),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    product, 
                    style: TextStyle(fontWeight: FontWeight.w600, color: titleColor, fontSize: 14, fontFamily: 'Cairo'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(date, textAlign: TextAlign.right, style: TextStyle(color: subtitleColor, fontSize: 14, fontFamily: 'Cairo'))),
          Expanded(flex: 2, child: Text(customer, textAlign: TextAlign.right, style: TextStyle(color: titleColor, fontSize: 14, fontFamily: 'Cairo'))),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? statusColor.withOpacity(0.05) : statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6)
                ),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              ),
            ),
          ),
          Expanded(flex: 1, child: Text(amount, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.primaryPurple, fontSize: 14, fontFamily: 'Cairo'))),
        ],
      ),
    );
  }
}
