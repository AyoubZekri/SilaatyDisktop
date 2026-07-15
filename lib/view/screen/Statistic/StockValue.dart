import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Statistice/StatisticeReportesController.dart';
import '../../../controller/Statistice/StockValueController.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../widget/Statistic/ReportsStockValueSummary.dart';
import '../../widget/Statistic/ReportsStockValueTable.dart';

class StockValue extends StatelessWidget {
  const StockValue({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Stockvaluecontroller());
    final Statisticereportescontroller statController = Get.find<Statisticereportescontroller>();
    final sidebarController = Get.find<Siedbarcontroller>();

    return Obx(() {
      final bool isDark = sidebarController.isDarkMode.value;
      
      return Scaffold(
        backgroundColor: isDark ? AppColor.backgroundDark : AppColor.backgroundLight,
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
                            "قيمة المخزون",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              fontFamily: 'Cairo',
                            ),
                          ),
                          Text(
                            "نظرة عامة على القيمة المالية للمخزون",
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? AppColor.textSecondary : Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => statController.showFilterDialog(context, statController.gotoStockValue),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColor.primaryPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColor.primaryPurple.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 18,
                                    color: AppColor.primaryPurple,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "تحديد الفترة",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.primaryPurple,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  ReportsStockValueSummary(isDark: isDark),
                  const SizedBox(height: 48),
                  ReportsStockValueTable(isDark: isDark),
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
