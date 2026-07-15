import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Statistice/StatisticeReportesController.dart';
import '../../../controller/Statistice/ClientsAndSuppliersController.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../widget/Statistic/FinanceHeader.dart';
import '../../widget/Statistic/ReportsCSHeader.dart';
import '../../widget/Statistic/ReportsCSSummary.dart';
import '../../widget/Statistic/ReportsCSTable.dart';

class ClientsAndSuppliers extends StatelessWidget {
  const ClientsAndSuppliers({super.key});

  @override
  Widget build(BuildContext context) {
    final Statisticereportescontroller controller =
        Get.find<Statisticereportescontroller>();
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
                  GetBuilder<ClientsAndSuppliersController>(
                    builder: (csController) {
                      return FinanceHeader(
                        isDark: isDark, 
                        controller: controller,
                        title: "cs_reports".tr,
                        subtitle: "cs_reports_desc".tr,
                        onFilterApply: controller.gotoCustomerSales,
                        showAccountFilter: csController.activeTab == 0,
                        extraFilter: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => csController.changeTab(1),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: csController.activeTab == 1 ? Colors.indigo : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text("suppliers_label".tr, style: TextStyle(color: csController.activeTab == 1 ? Colors.white : (isDark ? AppColor.textSecondary : Colors.grey.shade500), fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => csController.changeTab(0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: csController.activeTab == 0 ? Colors.indigo : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text("customers_label".tr, style: TextStyle(color: csController.activeTab == 0 ? Colors.white : (isDark ? AppColor.textSecondary : Colors.grey.shade500), fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 48),
                  // ReportsCSHeader(isDark: isDark),
                  // const SizedBox(height: 48),
                  ReportsCSSummary(isDark: isDark),
                  const SizedBox(height: 48),
                  ReportsCSTable(isDark: isDark),
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
