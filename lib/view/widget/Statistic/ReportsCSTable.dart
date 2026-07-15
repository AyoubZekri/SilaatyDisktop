import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Statistice/ClientsAndSuppliersController.dart';
import '../../../core/class/Statusrequest.dart';
import '../../../data/model/FinanceReportModel.dart';
import '../../../core/class/handlingview.dart';

class ReportsCSTable extends StatelessWidget {
  final bool isDark;
  const ReportsCSTable({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subtitleColor = isDark
        ? AppColor.textSecondary
        : Colors.grey.shade500;
    final horizontalScroll = ScrollController();
    final verticalScroll = ScrollController();

    return GetBuilder<ClientsAndSuppliersController>(
      builder: (controller) {
        final paginatedData = controller.paginatedData;
        int totalItems = controller.data?.transactionsDetails?.length ?? 0;
        int startItem = totalItems == 0
            ? 0
            : ((controller.currentPage - 1) * controller.itemsPerPage) + 1;
        int endItem = startItem + paginatedData.length - 1;
        String typeLabel = controller.activeTab == 0 ? "customers_label".tr : "suppliers_label".tr;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: isDark ? AppColor.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  controller.activeTab == 0
                      ? "sales_reports".tr
                      : "suppliers_reports".tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 500,
                child: Scrollbar(
                  controller: horizontalScroll,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: horizontalScroll,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 1200,
                      child: Scrollbar(
                        controller: verticalScroll,
                        notificationPredicate: (notif) => notif.depth == 1,
                        child: SingleChildScrollView(
                          controller: verticalScroll,
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              _buildTableHeader(
                                isDark,
                                subtitleColor,
                                controller.activeTab,
                              ),
                              const SizedBox(height: 12),
                              Divider(
                                color: isDark
                                    ? Colors.white10
                                    : Colors.grey.shade100,
                                height: 1,
                              ),
                              const SizedBox(height: 12),
                              Handlingview(
                                statusrequest: controller.statusrequest,
                                widget: Column(
                                  children: List.generate(
                                    paginatedData.length,
                                    (index) => _buildTableRow(
                                      controller,
                                      index,
                                      paginatedData[index],
                                      isDark,
                                      titleColor,
                                      subtitleColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              if (totalItems > 0)
                _buildPagination(
                  controller,
                  startItem,
                  endItem,
                  totalItems,
                  typeLabel,
                  isDark,
                  subtitleColor,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableHeader(bool isDark, Color textColor, int tabType) {
    final style = TextStyle(
      fontSize: 13,
      color: textColor,
      fontWeight: FontWeight.bold,
      fontFamily: 'Cairo',
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: 250,
            child: Text(tabType == 0 ? "customer_single".tr : "supplier_single".tr, style: style),
          ),
          SizedBox(
            width: 120,
            child: Center(child: Text("invoice_count".tr, style: style)),
          ),
          SizedBox(
            width: 140,
            child: Center(
              child: Text(tabType == 0 ? "sales_label".tr : "purchase_label".tr, style: style),
            ),
          ),
          SizedBox(
            width: 140,
            child: Center(child: Text("debts_label".tr, style: style)),
          ),
          SizedBox(
            width: 140,
            child: Center(child: Text("average_order".tr, style: style)),
          ),
          SizedBox(
            width: 140,
            child: Center(child: Text("discounts_label".tr, style: style)),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildTableRow(
    ClientsAndSuppliersController controller,
    int index,
    CustomerTransactionDetail item,
    bool isDark,
    Color titleColor,
    Color subtitleColor,
  ) {
    String fullName = item.name;
    if (item.familyName.isNotEmpty) {
      fullName += " ${item.familyName}";
    }
    String initial = fullName.isNotEmpty ? fullName[0] : "fallback_initial".tr;

    // Time logic
    String formattedTime = item.lastOperationTime.isNotEmpty
        ? controller.datefilter(item.lastOperationTime)
        : "not_available".tr;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: index % 2 == 0
            ? (isDark
                  ? Colors.white.withOpacity(0.02)
                  : const Color(0xFFF1F5F9).withOpacity(0.5))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: 250,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fullName,
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      formattedTime,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 11,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: Center(
              child: Text(
                "${item.totalInvoices}",
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 140,
            child: Center(
              child: Text(
                "${item.totalSold.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')} ${"currency_dz".tr}",
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 140,
            child: Center(
              child: Text(
                "${item.debts.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')} ${"currency_dz".tr}",
                style: TextStyle(
                  color: (item.debts <= 0 ? Colors.grey : Colors.red),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 140,
            child: Center(
              child: Text(
                "${item.averageOrderValue.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')} ${"currency_dz".tr}",
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 140,
            child: Center(
              child: Text(
                "${item.totalDiscount.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')} ${"currency_dz".tr}",
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildPagination(
    ClientsAndSuppliersController controller,
    int startItem,
    int endItem,
    int totalItems,
    String typeLabel,
    bool isDark,
    Color textColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          'عرض $startItem إلى $endItem من أصل $totalItems سجل',
          style: TextStyle(color: textColor, fontSize: 14),
        ),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            _buildPageItem('<', false, isDark, () => controller.prevPage()),
            ...List.generate(
              controller.totalPages,
              (index) {
                final page = index + 1;
                return _buildPageItem(
                  page.toString(),
                  page == controller.currentPage,
                  isDark,
                  () => controller.setPage(page),
                );
              },
            ),
            _buildPageItem('>', false, isDark, () => controller.nextPage()),
          ],
        ),
      ],
    );
  }

  Widget _buildPageItem(String label, bool active, bool isDark, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColor.primaryPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: active
              ? null
              : Border.all(color: isDark ? Colors.white10 : Colors.black12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

extension on ClientsAndSuppliersController {
  String datefilter(String date) {
    print("=========================$date");

    if (filter == "today" || filter == "yesterday") {
      String normalized = date.length >= 19 ? date.substring(0, 19) : date;
      return formatSmartDate(normalized);
    } else {
      String normalized = date.length >= 10 ? date.substring(0, 10) : date;
      return formatSmartDate(normalized);
    }
  }
}
