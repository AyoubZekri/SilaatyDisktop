import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/Profaile/invoice/Shwoinvoicecontroller.dart';
import '../../widget/invoice_details/InvoiceHeader.dart';
import '../../widget/invoice_details/InvoiceProductsTable.dart';
import '../../widget/invoice_details/InvoiceSummarySidebar.dart';

import '../../../data/model/InvoiceModel.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final String invoiceNo;
  final InvoiceItem? invoiceData;

  const InvoiceDetailsScreen({
    super.key,
    required this.invoiceNo,
    this.invoiceData,
  });

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();
    final controller = Get.put(Shwoinvoicecontroller());
    
    // Initialize custom if we passed data (useful for dialogs where Get.arguments isn't automatically caught by Get.put)
    if (invoiceData != null) {
      controller.initCustom(invoiceData!);
    }

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;
      final surfaceColor = isDark ? AppColor.surfaceDark : Colors.white;

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: Container(
          width: 1100, // Fixed optimal width for desktop
          constraints: const BoxConstraints(maxHeight: 800), // Fit in most screens
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF8F9FD),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Bar with Close Button
              Container(
                padding: const EdgeInsets.only(top: 16, right: 24, left: 24),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${'تفاصيل الفاتورة'.tr} #$invoiceNo",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: textColor),
                      onPressed: () => Get.back(),
                      style: IconButton.styleFrom(
                        backgroundColor: surfaceColor,
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main Scrollable Content
              Expanded(
                child: GetBuilder<Shwoinvoicecontroller>(
                  builder: (csController) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                      child: Column(
                        children: [
                          // 1. Top Navigation & Invoice Header
                          InvoiceHeader(
                            invoiceNo: invoiceNo,
                            isDark: isDark,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            controller: csController,
                          ),
                          const SizedBox(height: 24),

                          // 2. Main Content (Two Columns)
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                textDirection: TextDirection.rtl,
                                children: [
                                  // Products Table (Wide)
                                  Expanded(
                                    flex: 3,
                                    child: InvoiceProductsTable(
                                      isDark: isDark,
                                      surfaceColor: surfaceColor,
                                      textColor: textColor,
                                      controller: csController,
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  // Summary Sidebar
                                  Expanded(
                                    flex: 2,
                                    child: InvoiceSummarySidebar(
                                      isDark: isDark,
                                      surfaceColor: surfaceColor,
                                      textColor: textColor,
                                      controller: csController,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
