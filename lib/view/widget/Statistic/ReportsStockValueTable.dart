import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/class/Statusrequest.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Statistice/StockValueController.dart';
import '../../../core/class/handlingview.dart';

class ReportsStockValueTable extends StatelessWidget {
  final bool isDark;
  const ReportsStockValueTable({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subtitleColor = isDark ? AppColor.textSecondary : Colors.grey.shade500;
    final horizontalScroll = ScrollController();
    final verticalScroll = ScrollController();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "product_value_details".tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
          ),
          const SizedBox(height: 32),
          
          SizedBox(
            height: 450,
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
                          _buildTableHeader(isDark, subtitleColor),
                          const SizedBox(height: 12),
                          GetBuilder<Stockvaluecontroller>(
                            builder: (controller) {
                              final products = controller.paginatedProducts;
                              
                              return Handlingview(
                                statusrequest: controller.statusrequest,
                                widget: controller.data?.productsBalance == null || controller.data!.productsBalance!.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(32.0),
                                          child: Text(
                                            "no_data_for_period".tr,
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
          GetBuilder<Stockvaluecontroller>(
            builder: (controller) => _buildPagination(controller, isDark, subtitleColor),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(bool isDark, Color textColor) {
    final style = TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.bold, fontFamily: 'Cairo');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(width: 300, child: Text('product'.tr, style: style)),
          SizedBox(width: 150, child: Center(child: Text("category_label".tr, style: style))),
          SizedBox(width: 120, child: Center(child: Text("opening_balance".tr, style: style))),
          SizedBox(width: 120, child: Center(child: Text("purchases_label".tr, style: style))),
          SizedBox(width: 150, child: Center(child: Text("sales_label".tr, style: style))),
          SizedBox(width: 150, child: Center(child: Text("closing_balance".tr, style: style))),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildTableRow(int index, dynamic item, bool isDark, Color titleColor, Color subtitleColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? (isDark ? Colors.white.withOpacity(0.02) : const Color(0xFFF1F5F9).withOpacity(0.5)) : Colors.transparent,
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
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.inventory_2_outlined, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(item.productName, style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Cairo'), overflow: TextOverflow.ellipsis),
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
          SizedBox(width: 120, child: Center(child: Text(item.startsubtotal.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), ''), style: TextStyle(color: subtitleColor, fontSize: 13, fontFamily: 'Cairo')))),
          SizedBox(width: 120, child: Center(child: Text(item.insubtotal.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), ''), style: TextStyle(color: Colors.orange, fontSize: 13, fontFamily: 'Cairo')))),
          SizedBox(width: 150, child: Center(child: Text(item.soldsubtotal.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), ''), style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontFamily: 'Cairo')))),
          SizedBox(width: 150, child: Center(child: Text(item.endsubtotal.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), ''), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: 'Cairo')))),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildPagination(
    Stockvaluecontroller controller,
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
          'عرض $start إلى $end من أصل $total منتج',
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
