import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/Statistice/StatisticeReportesController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../widget/Statistic/ReportHeader.dart';
import '../../widget/Statistic/FinancialOverviewCard.dart';
import '../../widget/Statistic/LowStockCard.dart';
import '../../widget/Statistic/ReportInfoCard.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

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
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ReportHeader(isDark: isDark),
                  const SizedBox(height: 32),
                  _buildGridSection(context, isDark, constraints, controller),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildGridSection(BuildContext context, bool isDark, BoxConstraints constraints, Statisticereportescontroller controller) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: FinancialOverviewCard(
                  isDark: isDark,
                  onTap: () => controller.showFilterDialog(context, controller.gotoPublicFinance),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: LowStockCard(
                  isDark: isDark,
                  onTap: () => controller.gotoLowStock(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: constraints.maxWidth > 1200 ? 3 : (constraints.maxWidth > 800 ? 2 : 1),
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 1.6,
          children: [
            ReportInfoCard(
              title: "stock_balance".tr,
              subtitle: "stock_balance_desc".tr,
              icon: Icons.inventory_2_outlined,
              iconColor: AppColor.primaryPurple,
              isDark: isDark,
              onTap: () => controller.showFilterDialog(context, controller.gotoStockBalance),
            ),
            ReportInfoCard(
              title: "stock_value".tr,
              subtitle: "stock_value_desc".tr,
              icon: Icons.account_balance_wallet_outlined,
              iconColor: Colors.teal,
              isDark: isDark,
              onTap: () => controller.showFilterDialog(context, controller.gotoStockValue),
            ),
            ReportInfoCard(
              title: "cs_reports".tr,
              subtitle: "cs_reports_desc".tr,
              icon: Icons.people_outline_rounded,
              iconColor: AppColor.accentPurple,
              hasSidebarBorder: true,
              isDark: isDark,
              onTap: () => controller.showFilterDialog(context, controller.gotoCustomerSales),
            ),
          ],
        ),
      ],
    );
  }
}
