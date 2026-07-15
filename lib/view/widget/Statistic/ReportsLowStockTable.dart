import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/Statistice/LowStockController.dart';
import '../../../core/class/Statusrequest.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/class/handlingview.dart';
import '../../../core/constant/imageassets.DART';

class ReportsLowStockTable extends StatelessWidget {
  final bool isDark;
  const ReportsLowStockTable({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Row(
              //   children: [
              //     _buildSecondaryButton("refresh_list".tr, isDark),
              //     const SizedBox(width: 12),
              //     _buildPrimaryButton("order_new_stock".tr),
              //   ],
              // ),
              Text(
                "low_stock_list".tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Fixed Height Scrollable Table
          SizedBox(
            height: 500,
            child: Scrollbar(
              controller: horizontalScroll,
              thumbVisibility: true,
              thickness: 6,
              radius: const Radius.circular(8),
              child: SingleChildScrollView(
                controller: horizontalScroll,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 1000,
                  child: Scrollbar(
                    controller: verticalScroll,
                    notificationPredicate: (notif) => notif.depth == 1,
                    child: SingleChildScrollView(
                      controller: verticalScroll,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          _buildTableHeader(isDark, subtitleColor),
                          const SizedBox(height: 12),
                          Divider(
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade100,
                            height: 1,
                          ),
                          const SizedBox(height: 12),
                          GetBuilder<Lowstockcontroller>(
                            builder: (controller) {
                              final products = controller.paginatedDetails;
                              
                              return Handlingview(
                                statusrequest: controller.statusrequest,
                                widget: products.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(32.0),
                                          child: Text(
                                            "no_low_stock_products".tr,
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              color: subtitleColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: List.generate(
                                          products.length,
                                          (index) => _buildTableRow(
                                            index,
                                            products[index],
                                            isDark,
                                            titleColor,
                                            subtitleColor,
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
          ),
          const SizedBox(height: 16),
          GetBuilder<Lowstockcontroller>(
            builder: (controller) => _buildPagination(controller, isDark, subtitleColor),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(String title) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0056D2), // Dark Blue from image
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String title, bool isDark) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? Colors.white70 : Colors.grey.shade700,
        side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: isDark
            ? Colors.white.withOpacity(0.02)
            : const Color(0xFFF8FAFC),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
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
          SizedBox(width: 300, child: Text("product_label".tr, style: style)),
          SizedBox(width: 150, child: Text("category_label".tr, style: style)),
          SizedBox(
            width: 150,
            child: Text("current_quantity".tr, style: style),
          ),
          SizedBox(width: 150, child: Text("minimum_limit".tr, style: style)),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 150,
            child: Center(child: Text("status_label".tr, style: style)),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(
    int index,
    var item, // FinanceProduct
    bool isDark,
    Color titleColor,
    Color subtitleColor,
  ) {
    String qtyString = double.tryParse(item.quantity)?.toStringAsFixed(0) ?? "0";
    int qty = int.tryParse(qtyString) ?? 0;
    
    Color statusColor = Colors.orange;
    String status = "near_limit".tr;
    if (qty <= 5) {
      statusColor = Colors.redAccent;
      status = "out_of_stock_warning".tr;
    }
    if (qty == 0) {
      statusColor = Colors.red;
      status = "very_critical".tr;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            width: 300,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: AssetImage(Appimageassets.test2),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      item.uuid,
                      style: TextStyle(color: subtitleColor, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              "-", // Category is not returned directly
              style: TextStyle(color: titleColor, fontFamily: 'Cairo'),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              "$qtyString ${"piece_label".tr}",
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              "10 ${"pieces_label".tr}", // Default min limit
              style: TextStyle(color: titleColor, fontWeight: FontWeight.w500, fontFamily: 'Cairo'),
            ),
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 150,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.circle,
                      color: statusColor,
                      size: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(Lowstockcontroller controller, bool isDark, Color textColor) {
    final int total = controller.data?.details?.length ?? 0;
    final start = total == 0 ? 0 : ((controller.currentPage - 1) * controller.itemsPerPage) + 1;
    final end = (start + controller.paginatedDetails.length - 1).clamp(0, total);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          'عرض $start إلى $end من أصل $total منتج',
          style: TextStyle(color: textColor, fontSize: 14),
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
