import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../widget/BranchManagement/BranchHeader.dart';
import '../widget/BranchManagement/BranchSummary.dart';
import '../widget/BranchManagement/BranchTable.dart';
import '../widget/BranchManagement/BranchGeoDist.dart';
import '../../../controller/SellerController.dart';

class BranchManagement extends StatefulWidget {
  const BranchManagement({super.key});

  @override
  State<BranchManagement> createState() => _BranchManagementState();
}

class _BranchManagementState extends State<BranchManagement> {
  final ScrollController _horizontalScroll = ScrollController();
  final ScrollController _verticalScroll = ScrollController();
  final ScrollController _mainScroll = ScrollController();

  @override
  void dispose() {
    _horizontalScroll.dispose();
    _verticalScroll.dispose();
    _mainScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();

    final SellerController sellerController = Get.put(SellerController());

    return Obx(() {
      final bool isDark = sidebarController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColor.backgroundDark
            : AppColor.backgroundLight,
        body: LayoutBuilder(
          builder: (context, constraints) {
            double horizontalPadding = constraints.maxWidth > 1400 ? 64 : 32;
            return Scrollbar(
              controller: _mainScroll,
              thumbVisibility: true,
              child: GetBuilder<SellerController>(
                builder: (controller) {
                  return SingleChildScrollView(
                    controller: _mainScroll,
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BranchHeader(isDark: isDark, controller: controller),
                        const SizedBox(height: 48),
                        BranchTable(
                          isDark: isDark,
                          horizontalScroll: _horizontalScroll,
                          verticalScroll: _verticalScroll,
                          controller: controller,
                        ),
                        const SizedBox(height: 64),
                      ],
                    ),
                  );
                }
              ),
            );
          },
        ),
      );
    });
  }
}
