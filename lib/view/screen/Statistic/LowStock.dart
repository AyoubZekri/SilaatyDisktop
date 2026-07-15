import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Statistice/LowStockController.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../widget/Statistic/ReportsLowStockSummary.dart';
import '../../widget/Statistic/ReportsLowStockTable.dart';
import '../../widget/Statistic/ReportsLowStockBanner.dart';

class LowStock extends StatelessWidget {
  const LowStock({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Lowstockcontroller());
    final sidebarController = Get.find<Siedbarcontroller>();

    return Obx(() {
      final bool isDark = sidebarController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColor.backgroundDark
            : AppColor.backgroundLight,
        body: LayoutBuilder(
          builder: (context, constraints) {
            double horizontalPadding = constraints.maxWidth > 1400 ? 64 : 32;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            "المخزون المنخفض",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              fontFamily: 'Cairo',
                            ),
                          ),
                          Text(
                            "نظرة عامة على المنتجات التي اقتربت من النفاد",
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? AppColor.textSecondary : Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  // ReportsLowStockSummary(isDark: isDark),
                  // const SizedBox(height: 48),
                  ReportsLowStockTable(isDark: isDark),
                  // const SizedBox(height: 48),
                  // ReportsLowStockBanner(isDark: isDark),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
