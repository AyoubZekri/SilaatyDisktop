import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/Profaile/transaction/transactionController.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../widget/cs/CSStatsBoard.dart';
import '../../widget/cs/CSFilterBar.dart';
import '../../widget/cs/CSTable.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Transactioncontroller(initialType: 2));
    final sidebarController = Get.find<Siedbarcontroller>();

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;

      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Header
              Text(
                'customers'.tr,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 32),

              // Stats Board
              const CSStatsBoard(),
              const SizedBox(height: 32),

              // Filter Bar (Tabs + Search + Add)
              const CSFilterBar(),
              const SizedBox(height: 24),

              // Data Table
              const CSTable(),

              const SizedBox(height: 48),
            ],
          ),
        ),
      );
    });
  }
}
