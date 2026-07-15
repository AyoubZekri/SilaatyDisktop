import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/items/ItemsController.dart';
import '../../../controller/Dashpord/Salecontroller.dart';
import '../../../LinkApi.dart';
import '../../../core/class/handlingview.dart';
import '../../../core/constant/imageassets.DART';
import '../../../core/functions/Snacpar.dart';

class ProductCatalog extends StatelessWidget {
  const ProductCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();
    final itemsController = Get.put(Itemscontroller());
    final saleController = Get.find<SaleController>();
    final scrollController = ScrollController();

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 1. Modern Header & Search Bar (Side by side)
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: _buildSearchBar(isDark, textColor, itemsController),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Category Filter
            _buildCategoryFilter(isDark, itemsController),
            const SizedBox(height: 24),

            // 3. Products Grid
            Expanded(
              child: GetBuilder<Itemscontroller>(
                builder: (controller) {
                  return Handlingview(
                    statusrequest: controller.statusrequest,
                    widget: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      thickness: 6,
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
                        child: GridView.builder(
                          controller: scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 180,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.75,
                              ),
                          itemCount: controller.product.length,
                          itemBuilder: (context, index) {
                            return _buildProductCard(
                              controller.product[index],
                              isDark,
                              textColor,
                              saleController,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSearchBar(
    bool isDark,
    Color textColor,
    Itemscontroller controller,
  ) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(
            Icons.search_rounded,
            color: isDark ? Colors.white54 : Colors.grey.shade600,
            size: 26,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              textAlign: TextAlign.right,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (val) {
                controller.search(val);
              },
              decoration: InputDecoration(
                hintText: 'بحث عن منتج...'.tr,
                hintStyle: TextStyle(
                  color: isDark ? Colors.white30 : Colors.grey.shade400,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(String path) {
    if (path.isEmpty) return const AssetImage(Appimageassets.test2);
    if (path.startsWith('http')) return NetworkImage(path);
    if (path.contains(r':\') || path.contains(':/') || path.startsWith('/'))
      return FileImage(File(path));
    return NetworkImage("${Applink.image}/$path");
  }

  Widget _buildCategoryFilter(bool isDark, Itemscontroller controller) {
    return GetBuilder<Itemscontroller>(
      builder: (controller) {
        if (controller.categories.isEmpty) return const SizedBox.shrink();

        final categories = [
          {'uuid': '', 'name': 'الكل'.tr},
          ...controller.categories
              .map((c) => {'uuid': c.uuid, 'name': c.categorisName})
              .toList(),
        ];
        return Align(
          alignment: Alignment.centerRight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              textDirection: TextDirection.rtl,
              children: categories.map((cat) {
                final isSelected = controller.selectedCategoryId == cat['uuid'];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.primaryPurple
                        : (isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColor.primaryPurple
                          : (isDark ? Colors.white10 : Colors.grey.shade200),
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: AppColor.primaryPurple.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      else if (!isDark)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => controller.selectCategory(cat['uuid']!),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Text(
                        cat['name']!,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                    ? Colors.white70
                                    : Colors.grey.shade700),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(
    dynamic productData,
    bool isDark,
    Color textColor,
    SaleController saleController,
  ) {
    final qty =
        double.tryParse(productData.productQuantity?.toString() ?? '0') ?? 0;
    final isLowStock = qty > 0 && qty < 10;
    final isOutOfStock = qty <= 0;
    final String formattedQty = qty
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'0*$'), '')
        .replaceAll(RegExp(r'\.$'), '');

    return InkWell(
      onTap: () {
        if (!isOutOfStock || saleController.type == 1) {
          saleController.addProductFromCatalog(productData.toJson());
        } else {
          showSnackbar("خطأ", "الكمية غير متوفرة", Colors.red);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2D) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade100,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black38 : Colors.grey.shade200,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black12 : Colors.grey.shade50,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      image:
                          (productData.productImage != null &&
                              productData.productImage != '')
                          ? DecorationImage(
                              image: _getImageProvider(
                                productData.productImage,
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child:
                        (productData.productImage == null ||
                            productData.productImage == '')
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image(
                              image: _getImageProvider(''),
                              fit: BoxFit.contain,
                            ),
                          )
                        : null,
                  ),
                  // Gradient overlay to make text/badges readable
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isOutOfStock
                            ? Colors.redAccent.withOpacity(0.9)
                            : (isLowStock
                                  ? Colors.orangeAccent.withOpacity(0.9)
                                  : const Color(0xFF28C76F).withOpacity(0.9)),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        isOutOfStock
                            ? 'pos_out_of_stock'.tr
                            : (isLowStock
                                  ? 'pos_low_stock'.tr
                                  : 'pos_in_stock'.tr),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    productData.productName ?? '',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'الكمية: $formattedQty',
                        style: TextStyle(
                          fontSize: 12,
                          color: isOutOfStock
                              ? Colors.red
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'currency_dz'.tr,
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(width: 4),
                      Obx(
                        () => Text(
                          '${saleController.getSalePrice(productData.toJson()).toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryPurple,
                          ),
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
  }
}
