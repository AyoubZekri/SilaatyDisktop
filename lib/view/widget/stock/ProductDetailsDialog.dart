import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../data/model/Product_Model.dart' as Prodact;
import '../../../LinkApi.dart';
import '../../../core/constant/imageassets.DART';

class ProductDetailsDialog extends StatelessWidget {
  final Prodact.Data product;

  const ProductDetailsDialog({super.key, required this.product});

  ImageProvider _getImageProvider(String path) {
    if (path.isEmpty) return const AssetImage(Appimageassets.test2);
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
      final fieldColor = isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF0F4FF);
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;
      final subtitleColor = isDark ? Colors.white54 : Colors.black54;

      final double qty = double.tryParse(product.productQuantity ?? '0') ?? 0;
      final double purchase = product.productPricePurchase?.toDouble() ?? 0.0;
      final double sale = product.productPrice?.toDouble() ?? 0.0;
      final double totalPurchase = qty * purchase;
      final double totalSale = qty * sale;

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: surfaceColor,
        child: Container(
          width: 750,
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Background Area
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                      surfaceColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(Icons.close_rounded, color: textColor),
                          style: IconButton.styleFrom(
                            backgroundColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                          ),
                        ),
                        Text(
                          'تفاصيل المنتج',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Hero(
                          tag: 'product_image_${product.uuid}',
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isDark ? Colors.white10 : Colors.black12,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                              image: (product.productImage?.isNotEmpty ?? false)
                                  ? DecorationImage(
                                      image: _getImageProvider(product.productImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: (product.productImage?.isEmpty ?? true)
                                ? const Image(
                                    image: AssetImage(Appimageassets.test2),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                product.productName ?? 'بدون اسم',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                textDirection: TextDirection.rtl,
                                children: [
                                  // الباركود
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Icon(Icons.qr_code_2_rounded, size: 16, color: subtitleColor),
                                        const SizedBox(width: 6),
                                        Text(
                                          product.codepar?.toString() ?? 'بدون باركود',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: subtitleColor,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // تاريخ الإضافة
                                  if (product.createdAt != null && product.createdAt!.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          Icon(Icons.calendar_month_rounded, size: 16, color: subtitleColor),
                                          const SizedBox(width: 6),
                                          Text(
                                            product.createdAt!.length >= 10 ? product.createdAt!.substring(0, 10) : product.createdAt!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: subtitleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (product.productDescription != null && product.productDescription!.isNotEmpty)
                                Text(
                                  product.productDescription!,
                                  style: TextStyle(color: subtitleColor, fontSize: 14),
                                  textAlign: TextAlign.right,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content Area
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: Column(
                  children: [
                    // Prices Row
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(child: _buildInfoCard('سعر الشراء', '${_formatNum(purchase)} د.ج', Icons.shopping_cart_checkout_rounded, Colors.orange, isDark, fieldColor, textColor, subtitleColor)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildInfoCard('سعر البيع', '${_formatNum(sale)} د.ج', Icons.sell_rounded, const Color(0xFF28C76F), isDark, fieldColor, textColor, subtitleColor)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Wholesale Prices
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(child: _buildInfoCard('نصف جملة', '${_formatNum(product.productPriceHalfWholesale)} د.ج', Icons.local_offer_rounded, Colors.blue, isDark, fieldColor, textColor, subtitleColor)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildInfoCard('جملة', '${_formatNum(product.productPriceWholesale)} د.ج', Icons.inventory_rounded, Colors.purple, isDark, fieldColor, textColor, subtitleColor)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Stock and Totals
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            'المخزون المتوفر',
                            '${_formatNum(qty)} ${(product.type == 2) ? 'كغ' : 'وحدة'}',
                            Icons.all_inbox_rounded,
                            qty <= 0 ? Colors.red : Colors.teal,
                            isDark,
                            fieldColor,
                            textColor,
                            subtitleColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              _buildMiniRow('إجمالي الشراء', '${_formatNum(totalPurchase)} د.ج', isDark, fieldColor, textColor, subtitleColor),
                              const SizedBox(height: 8),
                              _buildMiniRow('إجمالي البيع المتوقع', '${_formatNum(totalSale)} د.ج', isDark, fieldColor, textColor, subtitleColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color iconColor, bool isDark, Color fieldColor, Color textColor, Color subtitleColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Right aligned due to RTL row
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: subtitleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniRow(String title, String value, bool isDark, Color fieldColor, Color textColor, Color subtitleColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: subtitleColor, fontSize: 13, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
