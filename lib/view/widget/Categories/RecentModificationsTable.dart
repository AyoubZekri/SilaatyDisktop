import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../core/constant/Colorapp.dart';

class RecentModificationsTable extends StatelessWidget {
  const RecentModificationsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Siedbarcontroller>();
    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final titleColor = isDark ? AppColor.textDark : const Color(0xFF2D2D2D);

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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: Text('view_all'.tr),
                  style: TextButton.styleFrom(foregroundColor: AppColor.primaryPurple),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildTableHeader(isDark),
            Divider(color: isDark ? Colors.white10 : Colors.black12, height: 32),
            _buildTableRow('إلكترونيات', 'أحمد محمود', '12 أكتوبر 2023', 'مكتمل', isDark, Colors.green),
            _buildTableRow('أزياء وملابس', 'سارة علي', '10 أكتوبر 2023', 'قيد المراجعة', isDark, Colors.orange),
            _buildTableRow('أثاث ومنزل', 'خالد العمري', '08 أكتوبر 2023', 'مرفوض', isDark, Colors.red),
          ],
        ),
      );
    });
  }

  Widget _buildTableHeader(bool isDark) {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: isDark ? AppColor.textSecondary : const Color(0xFF8E92BC),
      fontSize: 14,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(flex: 2, child: Text('categories'.tr, textAlign: TextAlign.right, style: headerStyle)),
          Expanded(flex: 2, child: Text('username'.tr, textAlign: TextAlign.right, style: headerStyle)),
          Expanded(flex: 2, child: Text('Date', textAlign: TextAlign.right, style: headerStyle)),
          Expanded(flex: 1, child: Text('Status', textAlign: TextAlign.right, style: headerStyle)),
        ],
      ),
    );
  }

  Widget _buildTableRow(String category, String user, String date, String status, bool isDark, Color statusColor) {
    final textColor = isDark ? AppColor.textDark : const Color(0xFF2D2D2D);
    final subtitleColor = isDark ? AppColor.textSecondary : const Color(0xFF8E92BC);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(flex: 2, child: Text(category, textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 15))),
          Expanded(flex: 2, child: Text(user, textAlign: TextAlign.right, style: TextStyle(color: subtitleColor, fontSize: 14))),
          Expanded(flex: 2, child: Text(date, textAlign: TextAlign.right, style: TextStyle(color: subtitleColor, fontSize: 14))),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? statusColor.withOpacity(0.05) : statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
