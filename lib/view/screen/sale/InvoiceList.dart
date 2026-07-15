import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/Dashpord/invoicesallcontroller.dart';
import '../../widget/invoice/InvoiceHeader.dart';
import '../../widget/invoice/InvoiceStatsBoard.dart';
import '../../widget/invoice/InvoiceFilterBar.dart';
import '../../widget/invoice/InvoiceTable.dart';
class InvoiceList extends StatelessWidget {
  const InvoiceList({super.key});

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();
    Get.put(Invoicesallcontroller());

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final backgroundColor = isDark
          ? AppColor.backgroundDark
          : const Color(0xFFF4F7FE);
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;
      final titleColor = isDark ? AppColor.textDark : const Color(0xFF2D2D2D);
      final subtitleColor = isDark
          ? AppColor.textSecondary
          : const Color(0xFF8E92BC);

      return GetBuilder<Invoicesallcontroller>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 1. Header Widget
                  InvoiceHeader(isDark: isDark, textColor: textColor),
                  const SizedBox(height: 32),

                  // 2. Stats Section Widget
                  InvoiceStatsBoard(isDark: isDark, textColor: textColor),
                  const SizedBox(height: 32),

                  // 3. Filter Bar Widget
                  InvoiceFilterBar(isDark: isDark, textColor: textColor),
                  const SizedBox(height: 24),

                  // 4. Data Table Widget
                  InvoiceTable(
                    isDark: isDark,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                  ),
                ],
              ),
            ),
          );
        }
      );
    });
  }
}
