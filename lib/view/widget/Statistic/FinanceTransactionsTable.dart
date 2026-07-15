import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Statistice/PublicFinanceController.dart';
import '../../../data/model/FinanceReportModel.dart';
import '../../../core/class/handlingview.dart';

class FinanceTransactionsTable extends StatelessWidget {
  final bool isDark;
  const FinanceTransactionsTable({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Publicfinancecontroller>();

    final titleColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subtitleColor = isDark
        ? AppColor.textSecondary
        : Colors.grey.shade500;
    final horizontalScroll = ScrollController();
    final verticalScroll = ScrollController();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "financial_period_analysis".tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "detailed_transactions_log".tr,
            style: TextStyle(
              fontSize: 14,
              color: subtitleColor,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 32),

          // Fixed Height Scrollable Table
          SizedBox(
            height: 500, // Fixed height for vertical scrolling within table
            child: Scrollbar(
              controller: horizontalScroll,
              thumbVisibility: true,
              thickness: 6,
              radius: const Radius.circular(8),
              child: SingleChildScrollView(
                controller: verticalScroll,
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  controller: horizontalScroll,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 920,
                    child: Column(
                      children: [
                        _buildTableHeader(isDark, subtitleColor),
                        const SizedBox(height: 12),
                        Divider(
                          color: isDark ? Colors.white10 : Colors.grey.shade100,
                          height: 1,
                        ),
                        const SizedBox(height: 12),
                        GetBuilder<Publicfinancecontroller>(
                          builder: (controller) {
                            final details = controller.paginatedDetails;
                            if (details.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Text("no_data_for_period".tr, style: const TextStyle(fontFamily: 'Cairo')),
                                ),
                              );
                            }
                            return Handlingview(
                              statusrequest: controller.statusrequest,
                              widget: Column(
                                children: List.generate(
                                  details.length,
                                  (index) => _buildTableRow(
                                    index,
                                    details[index],
                                    isDark,
                                    titleColor,
                                    subtitleColor,
                                    controller,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
          GetBuilder<Publicfinancecontroller>(
            builder: (controller) => _buildPagination(isDark, subtitleColor, controller),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(bool isDark, Color textColor) {
    final style = TextStyle(
      fontSize: 14,
      color: textColor,
      fontWeight: FontWeight.bold,
      fontFamily: 'Cairo',
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(width: 150, child: Text('period'.tr, style: style)),
          SizedBox(width: 150, child: Text('total_revenue'.tr, style: style)),
          SizedBox(width: 150, child: Text('total_sales'.tr, style: style)),
          SizedBox(width: 150, child: Text('total_expenses'.tr, style: style)),
          SizedBox(width: 120, child: Text('items_sold'.tr, style: style)),
          SizedBox(
            width: 150,
            child: Text('financial_net_profit'.tr, style: style),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(
    int index,
    FinanceDetail item,
    bool isDark,
    Color titleColor,
    Color subtitleColor,
    Publicfinancecontroller controller,
  ) {
    bool isPositive = item.netProfit >= 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: index % 2 == 0
            ? (isDark
                  ? Colors.white.withOpacity(0.02)
                  : const Color(0xFFFBFDFF))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              controller.datefilter(item.period),
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              item.revenue
                  .toStringAsFixed(2)
                  .replaceAll(RegExp(r'0*$'), '')
                  .replaceAll(RegExp(r'\.$'), ''),
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              item.totalSales
                  .toStringAsFixed(2)
                  .replaceAll(RegExp(r'0*$'), '')
                  .replaceAll(RegExp(r'\.$'), ''),
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              item.expenses
                  .toStringAsFixed(2)
                  .replaceAll(RegExp(r'0*$'), '')
                  .replaceAll(RegExp(r'\.$'), ''),
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              item.itemsSold.toStringAsFixed(0),
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              "${isPositive ? '+' : ''}${item.netProfit.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')}",
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(bool isDark, Color subtitleColor, Publicfinancecontroller controller) {
    final int total = controller.data?.details?.length ?? 0;
    final start = total == 0 ? 0 : ((controller.currentPage - 1) * controller.itemsPerPage) + 1;
    final end = (start + controller.paginatedDetails.length - 1).clamp(0, total);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          'عرض $start إلى $end من أصل $total عملية',
          style: TextStyle(color: subtitleColor, fontSize: 14),
        ),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            _buildPageItem('<', false, isDark, () => controller.previousPage()),
            ...List.generate(
              controller.totalPages,
              (index) {
                final page = index + 1;
                return _buildPageItem(
                  page.toString(),
                  page == controller.currentPage,
                  isDark,
                  () => controller.goToPage(page),
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
