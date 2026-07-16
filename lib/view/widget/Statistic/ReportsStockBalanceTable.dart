import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/Statistice/StockBalanceController.dart';
import '../../../core/class/Statusrequest.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/class/handlingview.dart';

class ReportsStockBalanceTable extends StatelessWidget {
  final bool isDark;
  const ReportsStockBalanceTable({super.key, required this.isDark});

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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "stock_balance_details".tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
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
                  width: 1150,
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
                          GetBuilder<Stockbalancecontroller>(
                            builder: (controller) {
                              final products = controller.paginatedProducts;

                              return Handlingview(
                                statusrequest: controller.statusrequest,
                                widget: controller.data?.productsBalance == null ||
                                        controller.data!.productsBalance!.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(32.0),
                                          child: Text(
                                            "no_stock_movement".tr,
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              color: subtitleColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          ...List.generate(
                                            products.length,
                                            (index) => _buildTableRow(
                                              index,
                                              products[index],
                                              isDark,
                                              titleColor,
                                              subtitleColor,
                                            ),
                                          ),
                                        ],
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
          const SizedBox(height: 32),
          GetBuilder<Stockbalancecontroller>(
            builder: (controller) =>
                _buildPagination(controller, isDark, subtitleColor),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Icon(
        icon,
        color: isDark ? Colors.white70 : Colors.grey.shade700,
        size: 20,
      ),
    );
  }

  Widget _buildTableHeader(bool isDark, Color textColor) {
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
          SizedBox(width: 300, child: Text("product_label".tr, style: style)),
          SizedBox(
            width: 150,
            child: Center(child: Text("category_label".tr, style: style)),
          ),
          SizedBox(
            width: 120,
            child: Center(child: Text("start_balance".tr, style: style)),
          ),
          SizedBox(
            width: 120,
            child: Center(child: Text("total_in_short".tr, style: style)),
          ),
          SizedBox(
            width: 120,
            child: Center(child: Text("total_out_short".tr, style: style)),
          ),
          SizedBox(
            width: 150,
            child: Center(child: Text("end_balance".tr, style: style)),
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 120,
            child: Center(child: Text("status_label".tr, style: style)),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(
    int index,
    var item, // StockProduct
    bool isDark,
    Color titleColor,
    Color subtitleColor,
  ) {
    Color statusColor = item.endQuantity > 0 ? Colors.green : Colors.red;

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
            width: 300,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.inventory_2_outlined, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  item.productName,
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150,
            child: Center(
              child: Text(
                item.categoryName,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 13,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Center(
              child: Text(
                item.startQuantity.toStringAsFixed(0),
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 13,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Center(
              child: Text(
                item.inQuantity.toStringAsFixed(0),
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Center(
              child: Text(
                item.soldQuantity.toStringAsFixed(0),
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Center(
              child: Text(
                item.endQuantity.toStringAsFixed(0),
                style: TextStyle(
                  color: titleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 120,
            child: Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(
    Stockbalancecontroller controller,
    bool isDark,
    Color textColor,
  ) {
    final int total = controller.data?.productsBalance?.length ?? 0;
    final start = total == 0 ? 0 : ((controller.currentPage - 1) * controller.itemsPerPage) + 1;
    final end = (start + controller.paginatedProducts.length - 1).clamp(0, total);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          'showing_cs_records'.tr.replaceFirst('%s', '$start').replaceFirst('%s', '$end').replaceFirst('%s', '$total').replaceFirst('%s', 'product'.tr),
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
