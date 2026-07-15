import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Profaile/invoice/Shwoinvoicecontroller.dart';
import '../../../core/class/handlingview.dart';

class InvoiceProductsTable extends StatelessWidget {
  final bool isDark;
  final Color surfaceColor;
  final Color textColor;
  final Shwoinvoicecontroller controller;

  const InvoiceProductsTable({
    super.key,
    required this.isDark,
    required this.surfaceColor,
    required this.textColor,
    required this.controller,
  });

  String _formatNumber(double number) {
    if (number == number.truncateToDouble()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final verticalScroll = ScrollController();
    final horizontalScroll = ScrollController();

    final products = controller.productSale?.products ?? [];

    return Container(
      padding: const EdgeInsets.all(32),
      height: 500,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
              Text(
                'product_details'.tr,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Scrollbar(
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
                    width: 860,
                    child: Scrollbar(
                      controller: verticalScroll,
                      notificationPredicate: (notif) => notif.depth == 1,
                      child: SingleChildScrollView(
                        controller: verticalScroll,
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            _buildTableHeader(),
                            const SizedBox(height: 12),
                            Divider(
                              color: isDark
                                  ? Colors.white10
                                  : Colors.black.withOpacity(0.05),
                              height: 1,
                            ),
                            Handlingview(
                              statusrequest: controller.statusrequest,
                              widget: Column(
                                children: products.map((product) {
                                  return _buildProductRow(
                                    product.productName ?? '',
                                    _formatNumber(double.tryParse(product.productPrice.toString()) ?? 0),
                                    _formatNumber(double.tryParse(product.quantity.toString()) ?? 0),
                                    _formatNumber(double.tryParse(product.subtotal.toString()) ?? 0),
                                    textColor,
                                    product.uuid,
                                    double.tryParse(product.quantity.toString()) ?? 0.0,
                                  );
                                }).toList(),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    final style = const TextStyle(
      color: Colors.grey,
      fontSize: 13,
      fontWeight: FontWeight.bold,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: 320,
            child: Text('product'.tr, textAlign: TextAlign.right, style: style),
          ),
          SizedBox(
            width: 140,
            child: Text(
              'unit_price'.tr,
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
          SizedBox(
            width: 160,
            child: Text(
              'quantity'.tr,
              textAlign: TextAlign.center,
              style: style,
            ),
          ),
          SizedBox(
            width: 140,
            child: Text(
              'subtotal'.tr,
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 60,
            child: Text(
              'actions'.tr,
              textAlign: TextAlign.center,
              style: style,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(
    String name,
    String price,
    String qty,
    String total,
    Color textColor,
    String? uuidSale,
    double rawQty,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: 320,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Fixed for RTL right-alignment alignment
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 140,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Fixed: Physically right in RTL
              children: [
                Text(
                  price,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'currency_dz'.tr,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildQtyBtn(Icons.remove, onTap: () {
                  if (uuidSale != null && rawQty > 1) {
                    controller.editProduct(uuidSale, rawQty - 1);
                  }
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    qty,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                _buildQtyBtn(Icons.add, onTap: () {
                  if (uuidSale != null) {
                    controller.editProduct(uuidSale, rawQty + 1);
                  }
                }),
              ],
            ),
          ),
          SizedBox(
            width: 140,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Fixed: Physically right in RTL
              children: [
                Text(
                  total,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'currency_dz'.tr,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 60,
            child: Center(
              child: _buildRowAction(
                icon: Icons.keyboard_return,
                color: Colors.orange,
                onTap: () {
                  if (uuidSale != null) {
                    controller.returnProduct(uuidSale);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowAction({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColor.primaryPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: AppColor.primaryPurple),
      ),
    );
  }

  Widget _buildBottomActionBtn(
    IconData icon,
    String label,
    Color color, {
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: textColor ?? color),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: textColor ?? color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
