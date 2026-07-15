import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../data/model/Product_Model.dart' as Prodact;
import '../../../controller/items/ItemsController.dart';
import '../../../LinkApi.dart';
import '../../../core/constant/imageassets.DART';
import '../../../core/functions/valiedinput.dart';
import '../../../core/functions/Snacpar.dart';
import '../CustemTextField.dart';

class UpdateStockDialog extends StatefulWidget {
  final Prodact.Data product;
  const UpdateStockDialog({super.key, required this.product});

  @override
  State<UpdateStockDialog> createState() => _UpdateStockDialogState();
}

class _UpdateStockDialogState extends State<UpdateStockDialog> {
  late TextEditingController qtyController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    qtyController = TextEditingController(text: '0');
  }

  void _increment() {
    if (widget.product.type == 2) {
      double val = double.tryParse(qtyController.text) ?? 0.0;
      qtyController.text = (val + 1).toString();
    } else {
      int val = int.tryParse(qtyController.text) ?? 0;
      qtyController.text = (val + 1).toString();
    }
    setState(() {});
  }

  void _decrement() {
    if (widget.product.type == 2) {
      double val = double.tryParse(qtyController.text) ?? 0.0;
      if (val > 0) {
        qtyController.text = (val - 1).toString();
        setState(() {});
      }
    } else {
      int val = int.tryParse(qtyController.text) ?? 0;
      if (val > 0) {
        qtyController.text = (val - 1).toString();
        setState(() {});
      }
    }
  }

  ImageProvider _getImageProvider(String path) {
    if (path.isEmpty) return const AssetImage(Appimageassets.test2); // or any fallback
    if (path.startsWith('http')) return NetworkImage(path);
    if (path.contains(r':\') || path.contains(':/') || path.startsWith('/')) return FileImage(File(path));
    return NetworkImage("${Applink.image}/$path");
  }

  String _formatNum(dynamic value) {
    if (value == null) return "0";
    double? d = double.tryParse(value.toString());
    if (d == null) return value.toString();
    if (d == d.toInt()) return d.toInt().toString();
    return d.toString();
  }

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();
    final primaryColor = AppColor.primaryPurple;

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final surfaceColor = isDark ? AppColor.surfaceDark : Colors.white;
      final fieldColor = isDark
          ? Colors.white.withOpacity(0.05)
          : const Color(0xFFF0F4FF);
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: surfaceColor,
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                    Text(
                      'update_stock_title'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Product Preview Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: fieldColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      // Product Image
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isDark ? Colors.white10 : Colors.black12,
                          image: (widget.product.productImage?.isNotEmpty ?? false) ? DecorationImage(
                            image: _getImageProvider(widget.product.productImage!),
                            fit: BoxFit.cover,
                          ) : null,
                        ),
                        child: (widget.product.productImage?.isEmpty ?? true) ? Icon(Icons.image_not_supported, color: isDark ? Colors.white30 : Colors.black26) : null,
                      ),
                      const SizedBox(width: 16),
                      // Product Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF28C76F).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'premium_product'.tr,
                                style: const TextStyle(
                                  color: Color(0xFF28C76F),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.product.productName ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              textDirection: TextDirection.rtl,
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                                children: [
                                  TextSpan(text: 'current_qty'.tr + ': '),
                                  TextSpan(
                                    text: '${_formatNum(widget.product.productQuantity)} ' + 'unit'.tr,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Quantity Input Label
                Text(
                  'new_qty_to_add'.tr,
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),

                // Quantity Counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQtyAction(Icons.add, primaryColor, onTap: _increment),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustemTextField(
                        controller: qtyController,
                        hint: '0',
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.numberWithOptions(decimal: widget.product.type == 2),
                        validator: (val) => validInput(val ?? "", 100, 1, widget.product.type == 2 ? "decimal" : "number"),
                        onChanged: (val) {
                          if (widget.product.type != 2) {
                            if (val.contains('.') || val.contains(',')) {
                              qtyController.text = val.replaceAll(RegExp(r'[.,]'), '');
                              qtyController.selection = TextSelection.fromPosition(TextPosition(offset: qtyController.text.length));
                            }
                          }
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildQtyAction(
                      Icons.remove,
                      Colors.grey,
                      onTap: _decrement,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Info Tip
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.02)
                        : Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Icon(
                        Icons.info_rounded,
                        color: Colors.amber.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'stock_update_tip'.tr,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Actions
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          
                          String type = widget.product.type == 2 ? "decimal" : "number";
                          if (!validInputsnak(qtyController.text, 1, 100, type)) {
                            return;
                          }

                          double qty = double.tryParse(qtyController.text) ?? 0;
                          if (widget.product.type != 2) qty = qty.floorToDouble();
                          
                          if (qty > 0) {
                            Get.back();
                            final stockController = Get.find<Itemscontroller>();
                            await stockController.addQuantity(widget.product, qty);
                          } else {
                            showSnackbar("تنبيه", "يجب أن تكون الكمية المضافة أكبر من صفر", Colors.orange);
                          }
                        },
                        icon: const Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          'update_qty'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: fieldColor,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'cancel'.tr,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildQtyAction(IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 60,
        height: 70,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
