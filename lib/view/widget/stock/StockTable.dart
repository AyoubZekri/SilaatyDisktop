import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/items/ItemsController.dart';
import '../../../LinkApi.dart';
import '../../../controller/items/AdditemsController.dart';
import '../../../controller/items/Edititemcontroller.dart';
import '../../../data/model/Product_Model.dart' as Prodact;
import '../../../core/constant/Colorapp.dart';
import 'AddProductDialog.dart';
import 'UpdateStockDialog.dart';
import 'ProductDetailsDialog.dart';
import '../../../core/class/handlingview.dart';
import '../../../core/constant/imageassets.DART';

class StockTable extends StatelessWidget {
  const StockTable({super.key});

  ImageProvider _getImageProvider(String path) {
    if (path.isEmpty) return const AssetImage(Appimageassets.test2);
    if (path.startsWith('http')) return NetworkImage(path);
    if (path.contains(r':\') || path.contains(':/') || path.startsWith('/')) return FileImage(File(path));
    return NetworkImage("${Applink.image}/$path");
  }

  String _formatNumber(dynamic value) {
    if (value == null) return '0';
    double? parsed;
    if (value is String) {
      parsed = double.tryParse(value);
    } else if (value is num) {
      parsed = value.toDouble();
    }
    if (parsed == null) return '0';
    if (parsed == parsed.toInt()) {
      return parsed.toInt().toString();
    }
    return parsed.toString();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Siedbarcontroller>();
    final stockController = Get.find<Itemscontroller>();
    final verticalScroll = ScrollController();
    final horizontalScroll = ScrollController();

    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final titleColor = isDark ? AppColor.textDark : const Color(0xFF2D2D2D);
      final subtitleColor = isDark
          ? AppColor.textSecondary
          : const Color(0xFF8E92BC);

      return Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        decoration: BoxDecoration(
          color: isDark ? AppColor.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.rtl,
              children: [
                _buildSearchField(isDark, titleColor, stockController),
                InkWell(
                  onTap: () {
                    Get.put(Additemscontroller());
                    Get.dialog(const AddProductDialog(isEdit: false));
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColor.purpleGradient,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryPurple.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add_rounded, color: Colors.white, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'add_product'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Scrollbar(
              controller: horizontalScroll,
              thumbVisibility: true,
              thickness: 8,
              radius: const Radius.circular(8),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                    PointerDeviceKind.stylus,
                    PointerDeviceKind.trackpad,
                  },
                ),
                child: SingleChildScrollView(
                  controller: horizontalScroll,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 1250,
                    child: GetBuilder<Itemscontroller>(
                      builder: (ctrl) {
                        var items = ctrl.paginatedProducts;

                        return Column(
                          children: [
                            _buildTableHeader(isDark, subtitleColor),
                            const SizedBox(height: 8),
                            Divider(
                              color: isDark ? Colors.white10 : Colors.black12,
                              height: 1,
                            ),
                            Handlingview(
                              statusrequest: ctrl.statusrequest,
                              widget: Column(
                                children: [
                                  if (items.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: Text('no_products'.tr, style: TextStyle(color: titleColor, fontSize: 16)),
                                    ),
                                  for (var item in items) ...[
                                    _buildTableRow(
                                      item: item,
                                      name: item.productName ?? '',
                                      barcode: item.codepar?.toString() ?? '',
                                      img: item.productImage ?? '',
                                      sale: _formatNumber(item.productPrice),
                                      wholesale: _formatNumber(item.productPriceWholesale),
                                      halfWholesale: _formatNumber(item.productPriceHalfWholesale),
                                      qty: _formatNumber(item.productQuantity),
                                      qtyStatus: (double.tryParse(item.productQuantity ?? '0') ?? 0) <= 0 ? 'out_of_stock' : ((double.tryParse(item.productQuantity ?? '0') ?? 0) < 10 ? 'low_stock' : 'stable'),
                                      isDark: isDark,
                                      titleColor: titleColor,
                                      subtitleColor: subtitleColor,
                                      stockController: ctrl,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildPagination(isDark, subtitleColor, stockController),
          ],
        ),
      );
    });
  }

  Widget _buildSearchField(bool isDark, Color textColor, Itemscontroller stockController) {
    return Container(
      width: 480,
      height: 52,
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceDark : const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: TextField(
        controller: stockController.searchController,
        textAlign: TextAlign.right,
        style: TextStyle(color: textColor, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'search_product'.tr,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          suffixIcon: const Icon(Icons.search_rounded, color: Colors.grey, size: 24),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        onChanged: (val) => stockController.search(val),
      ),
    );
  }

  Widget _buildTableHeader(bool isDark, Color headerColor) {
    final style = TextStyle(fontSize: 14, color: headerColor, fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(width: 350, child: Text('product_barcode'.tr, textAlign: TextAlign.right, style: style)),
          SizedBox(width: 150, child: Text('sale_price'.tr, textAlign: TextAlign.center, style: style)),
          SizedBox(width: 150, child: Text('half_wholesale_price'.tr, textAlign: TextAlign.center, style: style)),
          SizedBox(width: 150, child: Text('wholesale_price'.tr, textAlign: TextAlign.center, style: style)),
          SizedBox(width: 150, child: Text('quantity'.tr, textAlign: TextAlign.center, style: style)),
          const Spacer(),
          SizedBox(width: 200, child: Text('actions'.tr, textAlign: TextAlign.center, style: style)),
        ],
      ),
    );
  }

  Widget _buildTableRow({
    required Prodact.Data item,
    required String name,
    required String barcode,
    required String img,
    required String sale,
    required String wholesale,
    required String halfWholesale,
    required String qty,
    required String qtyStatus,
    required bool isDark,
    required Color titleColor,
    required Color subtitleColor,
    required Itemscontroller stockController,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: 350,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isDark ? Colors.white10 : Colors.black12,
                        image: img.isNotEmpty ? DecorationImage(image: _getImageProvider(img), fit: BoxFit.cover) : null,
                      ),
                      child: img.isEmpty ? Icon(Icons.image_not_supported, color: isDark ? Colors.white30 : Colors.black26) : null,
                    ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Start = Right in RTL
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: titleColor, fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(barcode, style: TextStyle(color: subtitleColor, fontSize: 13)),
                        const SizedBox(width: 4),
                        Icon(Icons.qr_code_2_rounded, size: 14, color: subtitleColor),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(sale, textAlign: TextAlign.center, style: const TextStyle(color: AppColor.primaryPurple, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          SizedBox(
            width: 150,
            child: Text(halfWholesale, textAlign: TextAlign.center, style: TextStyle(color: titleColor, fontSize: 16)),
          ),
          SizedBox(
            width: 150,
            child: Text(wholesale, textAlign: TextAlign.center, style: TextStyle(color: titleColor, fontSize: 16)),
          ),
          SizedBox(
            width: 150,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: _getStatusColor(qtyStatus).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text('$qty ${_getStatusLabel(qtyStatus)}', style: TextStyle(color: _getStatusColor(qtyStatus), fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionIcon(Icons.info_outline_rounded, Colors.blue, isDark, onTap: () {
                  Get.dialog(ProductDetailsDialog(product: item));
                }),
                _buildActionIcon(Icons.delete_outline, Colors.red, isDark, onTap: () {
                  stockController.deleteProduct(item);
                }),
                _buildActionIcon(Icons.edit_outlined, Colors.grey, isDark, onTap: () async {
                  final ctrl = Get.put(Edititemcontroller());
                  ctrl.initData(item);
                  final result = await Get.dialog(AddProductDialog(isEdit: true, product: item));
                  if (result == true) {
                    await stockController.refreshProductsList();
                  }
                }),
                _buildActionIcon(Icons.add_rounded, AppColor.primaryPurple, isDark, onTap: () => Get.dialog(UpdateStockDialog(product: item))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color color, bool isDark, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFEEEEF5), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'stable') return const Color(0xFF28C76F);
    if (status == 'low_stock') return const Color(0xFFFF9F43);
    return Colors.grey;
  }

  String _getStatusLabel(String status) {
    if (status == 'low_stock') return 'low_stock_status'.tr;
    if (status == 'stable') return 'stable_status'.tr;
    return 'piece'.tr;
  }

  Widget _buildPagination(bool isDark, Color textColor, Itemscontroller stockController) {
    final start = stockController.filteredProducts.isEmpty ? 0 : ((stockController.currentPage - 1) * stockController.itemsPerPage) + 1;
    final end = (start + stockController.paginatedProducts.length - 1).clamp(0, stockController.filteredProducts.length);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          'showing_cs_records'.tr.replaceFirst('%s', '$start').replaceFirst('%s', '$end').replaceFirst('%s', '${stockController.filteredProducts.length}').replaceFirst('%s', 'product'.tr),
          style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14),
        ),
        Row(
          children: [
            _buildPageItem('<', false, isDark, textColor, () => stockController.previousPage()),
            ...List.generate(
              stockController.totalPages,
              (index) {
                final page = index + 1;
                return _buildPageItem(
                  page.toString(),
                  page == stockController.currentPage,
                  isDark,
                  textColor,
                  () => stockController.goToPage(page),
                );
              },
            ),
            _buildPageItem('>', false, isDark, textColor, () => stockController.nextPage()),
          ],
        ),
      ],
    );
  }

  Widget _buildPageItem(String label, bool active, bool isDark, Color textColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(duration: const Duration(milliseconds: 250), margin: const EdgeInsets.symmetric(horizontal: 10), width: 36, height: 36, alignment: Alignment.center, decoration: BoxDecoration(color: active ? AppColor.primaryPurple : Colors.transparent, borderRadius: BorderRadius.circular(8), border: active ? null : Border.all(color: isDark ? Colors.white10 : Colors.black12)), child: Text(label, style: TextStyle(color: active ? Colors.white : (isDark ? Colors.white70 : Colors.black87), fontWeight: FontWeight.bold, fontSize: 14))),
    );
  }
}
