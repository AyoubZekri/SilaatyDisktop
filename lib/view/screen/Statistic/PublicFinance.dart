import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Statistice/StatisticeReportesController.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../widget/Statistic/CustomReportBanner.dart';
import '../../widget/Statistic/FinanceSummaryCards.dart';
import '../../widget/Statistic/FinanceCharts.dart';
import '../../widget/Statistic/FinanceTransactionsTable.dart';
import '../../widget/Statistic/FinanceHeader.dart';

class PublicFinance extends StatelessWidget {
  const PublicFinance({super.key});

  @override
  Widget build(BuildContext context) {
    final Statisticereportescontroller controller = Get.put(Statisticereportescontroller());
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
                  FinanceHeader(
                    isDark: isDark, 
                    controller: controller,
                    onFilterApply: controller.gotoPublicFinance,
                  ),
                  const SizedBox(height: 40),
                  FinanceSummaryCards(isDark: isDark),
                  const SizedBox(height: 48),
                  FinanceTransactionsTable(isDark: isDark),
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
