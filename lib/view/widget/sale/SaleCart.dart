import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/Dashpord/Salecontroller.dart';
import '../../../LinkApi.dart';
import '../../../core/functions/Snacpar.dart';
import '../../../core/functions/valiedinput.dart';
import '../CustemTextField.dart';
import '../cs/AddCSDialog.dart';
import '../../../core/constant/imageassets.DART';
import '../../../core/services/Services.dart';

class SaleCart extends StatelessWidget {
  const SaleCart({super.key});

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();
    final saleController = Get.find<SaleController>();
    final itemsScrollController = ScrollController();

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      // final surfaceColor = isDark ? AppColor.surfaceDark : Colors.white;
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;

      // Determine if it's a Purchase (Supplier) or Sale (Customer)
      final isPurchase = saleController.type == 1;

      return Container(
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. Professional Unified Selector
            _buildProfessionalClientSection(
              context,
              saleController,
              isDark,
              textColor,
            ),

            if (!isPurchase) ...[
              const SizedBox(height: 12),
              _buildSaleTypeSelector(
                context,
                saleController,
                isDark,
                textColor,
              ),
            ],

            const SizedBox(height: 16),

            // 2. Cart Items
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Scrollbar(
                    controller: itemsScrollController,
                    thumbVisibility: true,
                    thickness: 4,
                    child: Obx(
                      () => ListView.separated(
                        controller: itemsScrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: saleController.selectedProducts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = saleController.selectedProducts[index];
                          return _buildCartItem(
                            context,
                            item,
                            isDark,
                            textColor,
                            saleController,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 3. Summary Section (Save Button) Fixed at the bottom
            _buildSummary(context, isDark, textColor, saleController),
          ],
        ),
      );
    });
  }

  Widget _buildProfessionalClientSection(
    BuildContext context,
    SaleController controller,
    bool isDark,
    Color textColor,
  ) {
    final isPurchase = controller.type == 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          controller.fetchCustomers();
          controller.searchCustomer('');
          _showCustomerSelectionDialog(context, controller, isDark);
        },
        borderRadius: BorderRadius.circular(16),
        child: Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: controller.isCashCustomer.value
                    ? Colors.green.withOpacity(0.3)
                    : (isPurchase
                          ? Colors.blue.withOpacity(0.3)
                          : AppColor.primaryPurple.withOpacity(0.3)),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      (controller.isCashCustomer.value
                              ? Colors.green
                              : (isPurchase
                                    ? Colors.blue
                                    : AppColor.primaryPurple))
                          .withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          (controller.isCashCustomer.value
                                  ? Colors.green
                                  : (isPurchase
                                        ? Colors.blue
                                        : AppColor.primaryPurple))
                              .withOpacity(0.1),
                      child: Icon(
                        controller.isCashCustomer.value
                            ? (isPurchase
                                  ? Icons.inventory_2_outlined
                                  : Icons.payments_outlined)
                            : (isPurchase
                                  ? Icons.local_shipping_rounded
                                  : Icons.person_rounded),
                        size: 18,
                        color: controller.isCashCustomer.value
                            ? Colors.green
                            : (isPurchase
                                  ? Colors.blue
                                  : AppColor.primaryPurple),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.isCashCustomer.value
                              ? (isPurchase ? 'quick_supply_operation'.tr : 'cash_customer'.tr)
                              : (isPurchase
                                    ? 'selected_supplier'.tr
                                    : 'current_customer_name'.tr),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          controller.isCashCustomer.value
                              ? (isPurchase
                                    ? 'unidentified_supplier'.tr
                                    : 'quick_sale_operation'.tr)
                              : (controller.selectedName.value.isEmpty
                                    ? (isPurchase
                                          ? 'click_to_select_supplier'.tr
                                          : 'click_to_select_customer'.tr)
                                    : '${controller.selectedName.value} ${controller.selectedFamilyName.value}'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  size: 20,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCustomerSelectionDialog(
    BuildContext context,
    SaleController controller,
    bool isDark,
  ) {
    final isPurchase = controller.type == 1;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: isDark ? AppColor.backgroundDark : Colors.white,
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              (isPurchase
                                      ? Colors.blue
                                      : AppColor.primaryPurple)
                                  .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isPurchase
                              ? Icons.local_shipping_rounded
                              : Icons.person_search_rounded,
                          color: isPurchase
                              ? Colors.blue
                              : AppColor.primaryPurple,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isPurchase ? 'select_supplier'.tr : 'select_customer'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Bar
              TextField(
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                onChanged: (val) => controller.searchCustomer(val),
                decoration: InputDecoration(
                  hintText: isPurchase
                      ? 'search_supplier_name_phone'.tr
                      : 'search_customer_name_phone'.tr,
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withOpacity(0.05)
                      : const Color(0xFFF4F7FE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // List Content
              Flexible(
                child: Obx(() {
                  if (controller.filteredCustomersList.isEmpty) {
                    return  Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'no_data'.tr,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.filteredCustomersList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = controller.filteredCustomersList[index];
                      final nameStr =
                          '${item['name']} ${item['family_name'] ?? ''}';
                      final phoneStr = item['phone_number']?.toString() ?? '';
                      final charStr = nameStr.trim().isNotEmpty
                          ? nameStr.trim()[0]
                          : '?';
                      final colorsList = [
                        Colors.blue,
                        Colors.green,
                        Colors.orange,
                        Colors.purple,
                        Colors.red,
                      ];
                      final colorItem = colorsList[index % colorsList.length];

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.02)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? Colors.white10
                                : Colors.black.withOpacity(0.05),
                          ),
                        ),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: colorItem.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                charStr,
                                style: TextStyle(
                                  color: colorItem,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    nameStr,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    phoneStr,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            ElevatedButton(
                              onPressed: () {
                                controller.selectedUuid.value =
                                    item['uuid']?.toString() ?? '';
                                controller.selectedName.value =
                                    item['name']?.toString() ?? '';
                                controller.selectedFamilyName.value =
                                    item['family_name']?.toString() ?? '';
                                controller.selectedCustomer.value = nameStr;
                                controller.isCashCustomer.value = false;
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark
                                    ? Colors.white10
                                    : const Color(0xFFF8F9FA),
                                foregroundColor: isPurchase
                                    ? Colors.blue
                                    : AppColor.primaryPurple,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child:  Text(
                                'select'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Footer Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      controller.isCashCustomer.value = true;
                      controller.selectedUuid.value = '';
                      controller.selectedName.value = '';
                      controller.selectedFamilyName.value = '';
                      controller.selectedCustomer.value = isPurchase
                          ? 'unregistered_supplier'.tr
                          : 'cash_customer'.tr;
                      Get.back();
                    },
                    icon: Icon(
                      isPurchase
                          ? Icons.inventory_2_outlined
                          : Icons.payments_outlined,
                      size: 20,
                    ),
                    label: Text(
                      isPurchase ? 'unregistered_supplier'.tr : 'cash_customer'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final result = await Get.dialog(
                        AddCSDialog(data: {'type': isPurchase ? 1 : 0}),
                      );
                      if (result != null) {
                        controller.selectedUuid.value =
                            result['uuid']?.toString() ?? '';
                        controller.selectedName.value =
                            result['name']?.toString() ?? '';
                        controller.selectedFamilyName.value =
                            result['famlyname']?.toString() ?? '';
                        controller.selectedCustomer.value =
                            '${result['name']} ${result['famlyname']}'.trim();
                        controller.isCashCustomer.value = false;
                        controller.fetchCustomers();
                        Get.back();
                      }
                    },
                    icon: Icon(
                      isPurchase
                          ? Icons.add_business_rounded
                          : Icons.person_add_alt_1_rounded,
                      size: 20,
                    ),
                    label: Text(
                      isPurchase ? 'add_new_supplier'.tr : 'add_new_customer'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: isPurchase
                          ? Colors.blue
                          : AppColor.primaryPurple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  ImageProvider _getImageProvider(String path) {
    if (path.isEmpty) return const AssetImage(Appimageassets.test2);
    if (path.startsWith('http')) return NetworkImage(path);
    if (path.contains(r':\') || path.contains(':/') || path.startsWith('/'))
      return FileImage(File(path));
    return NetworkImage("${Applink.image}/$path");
  }

  Widget _buildSaleTypeSelector(
    BuildContext context,
    SaleController controller,
    bool isDark,
    Color textColor,
  ) {
    final int userTypeSale = Get.find<Myservices>().sharedPreferences?.getInt("sell_type") ?? 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : const Color(0xFFF2F5FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: _buildSaleTypeButton(
                  title: 'retail'.tr,
                  isActive: controller.saleType.value == 1,
                  isDark: isDark,
                  onTap: () {
                    controller.changeSaleType(1);
                  },
                ),
              ),
              if (userTypeSale >= 2)
                Expanded(
                  child: _buildSaleTypeButton(
                    title: 'half_wholesale'.tr,
                    isActive: controller.saleType.value == 2,
                    isDark: isDark,
                    onTap: () {
                      controller.changeSaleType(2);
                    },
                  ),
                ),
              if (userTypeSale >= 3)
                Expanded(
                  child: _buildSaleTypeButton(
                    title: 'wholesale'.tr,
                    isActive: controller.saleType.value == 3,
                    isDark: isDark,
                    onTap: () {
                      controller.changeSaleType(3);
                    },
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSaleTypeButton({
    required String title,
    required bool isActive,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColor.primaryPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColor.primaryPurple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive
                  ? Colors.white
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    Map<String, dynamic> item,
    bool isDark,
    Color textColor,
    SaleController controller,
  ) {
    final isPurchase = controller.type == 1;
    final primaryColor = isPurchase ? Colors.blue : AppColor.primaryPurple;

    final String name = item['name'] ?? 'unknown_product'.tr;
    final bool isWeighed = item['type_item'] == 2;
    double rawQty = double.tryParse(item['quantity'].toString()) ?? 1.0;
    String displayQty = rawQty == rawQty.toInt()
        ? rawQty.toInt().toString()
        : rawQty.toString();

    double rawTotal = double.tryParse(item['total'].toString()) ?? 0.0;
    String displayTotal = rawTotal
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'0*$'), '')
        .replaceAll(RegExp(r'\.$'), '');

    final unitPrice = isPurchase
        ? (item['price_Purchase'] ?? 0.0)
        : (item['price'] ?? 0.0);
    final String displayUnitPrice = unitPrice
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'0*$'), '')
        .replaceAll(RegExp(r'\.$'), '');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.05 : 0.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () => _showPriceEditDialog(
                    context,
                    item,
                    isDark,
                    textColor,
                    controller,
                    primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${'unit_price'.tr}: $displayUnitPrice ${'currency_dz'.tr}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$displayTotal ${'currency_dz'.tr}',
                  style: TextStyle(
                    fontSize: 15,
                    color: primaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Qty Control
          _CartItemQtyControl(
            initialQty: displayQty,
            uuid: item['uuid'],
            isDark: isDark,
            textColor: textColor,
            controller: controller,
            primaryColor: primaryColor,
            isWeighed: isWeighed,
          ),

          const SizedBox(width: 12),

          // Delete Btn
          InkWell(
            onTap: () => controller.deleteProduct(item['uuid']),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                size: 22,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPriceEditDialog(
    BuildContext context,
    Map<String, dynamic> item,
    bool isDark,
    Color textColor,
    SaleController controller,
    Color primaryColor,
  ) {
    final isPurchase = controller.type == 1;
    final unitPrice = isPurchase
        ? (item['price_Purchase'] ?? 0.0)
        : (item['price'] ?? 0.0);
    final priceController = TextEditingController(
      text: unitPrice
          .toStringAsFixed(2)
          .replaceAll(RegExp(r'0*$'), '')
          .replaceAll(RegExp(r'\.$'), ''),
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? AppColor.backgroundDark : Colors.white,
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'edit_unit_price'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                decoration: InputDecoration(
                  labelText: 'new_price'.tr,
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final newPrice = double.tryParse(priceController.text);
                        if (newPrice != null && newPrice >= 0) {
                          controller.updateProductPrice(item['uuid'], newPrice);
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child:  Text(
                        'save'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:  Text(
                        'cancel'.tr,
                        style: TextStyle(
                          color: Colors.grey,
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
  }

  Widget _buildSummary(
    BuildContext context,
    bool isDark,
    Color textColor,
    SaleController controller,
  ) {
    final isPurchase = controller.type == 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : Colors.white,
        borderRadius:  BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                if (controller.selectedProducts.isEmpty) {
                  showSnackbar(
                    "alert".tr,
                    "no_products_add_first".tr,
                    Colors.orange,
                  );
                  return;
                }
                _showPaymentDialog(context, controller, isDark, textColor);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isPurchase
                    ? Colors.blue
                    : AppColor.primaryPurple,
                elevation: 10,
                shadowColor: (isPurchase ? Colors.blue : AppColor.primaryPurple)
                    .withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_rounded, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'save'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(
    BuildContext context,
    SaleController controller,
    bool isDark,
    Color textColor,
  ) {
    final isPurchase = controller.type == 1;
    final primaryColor = isPurchase ? Colors.blue : AppColor.primaryPurple;

    final dueInitial = controller.totalallPrice - controller.discount.value;
    final paymentController = TextEditingController(
      text: dueInitial
          .toStringAsFixed(2)
          .replaceAll(RegExp(r'0*$'), '')
          .replaceAll(RegExp(r'\.$'), ''),
    );
    final discountController = TextEditingController(
      text: controller.discount.value == 0
          ? ''
          : controller.discount.value
                .toStringAsFixed(2)
                .replaceAll(RegExp(r'0*$'), '')
                .replaceAll(RegExp(r'\.$'), ''),
    );
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 440,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: isDark ? AppColor.backgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Obx(() {
            final total = controller.totalallPrice;
            final discount = controller.discount.value;
            final due = total - discount;

            return Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Icon
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPurchase
                            ? Icons.shopping_cart_checkout_rounded
                            : Icons.receipt_long_rounded,
                        size: 40,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                   Center(
                    child: Text(
                      'confirm_payment'.tr,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Summary Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.03)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textDirection: TextDirection.rtl,
                          children: [
                            Text(
                              'grand_total'.tr + ':',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${total.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')} ${'currency_dz'.tr}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Divider(
                            height: 1,
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade200,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textDirection: TextDirection.rtl,
                          children: [
                             Text(
                              'amount_due'.tr + ':',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${due.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')} ${'currency_dz'.tr}',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: primaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Inputs: Discount & Pay Amount
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                             Text(
                              'discount'.tr,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustemTextField(
                              controller: discountController,
                              hint: '0',
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              textDirection: TextDirection.ltr,
                              validator: (val) =>
                                  validInput(val ?? "", 100, 0, "decimal"),
                              onChanged: (val) {
                                controller.discount.value =
                                    double.tryParse(val) ?? 0.0;
                                paymentController.text =
                                    (controller.totalallPrice -
                                            controller.discount.value)
                                        .toStringAsFixed(2)
                                        .replaceAll(RegExp(r'0*$'), '')
                                        .replaceAll(RegExp(r'\.$'), '');
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                             Text(
                              'payment_amount'.tr,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustemTextField(
                              controller: paymentController,
                              hint: '0',
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              textDirection: TextDirection.ltr,
                              validator: (val) =>
                                  validInput(val ?? "", 10000000, 0, "decimal"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      // Confirm & Print
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                primaryColor.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.4),
                                offset: const Offset(0, 4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                if (!formKey.currentState!.validate()) return;
                                final payAmount =
                                    double.tryParse(paymentController.text) ??
                                    due;
                                controller.saveSale(
                                  payAmount,
                                  printInvoice: true,
                                );
                                Get.back();
                              },
                              child:  Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.print_rounded,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        'confirm_and_print'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Confirm Only
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: isDark ? Colors.grey.shade800 : Colors.white,
                            border: Border.all(
                              color: primaryColor.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                if (!formKey.currentState!.validate()) return;
                                final payAmount =
                                    double.tryParse(paymentController.text) ??
                                    due;
                                controller.saveSale(
                                  payAmount,
                                  printInvoice: false,
                                );
                                Get.back();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline_rounded,
                                      size: 20,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        'confirm_only'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Cancel
                      TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'cancel'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value,
    Color color, {
    bool isNegative = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          '${isNegative ? "- " : ""}$value ${'currency_dz'.tr}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _secondaryActionBtn(
    IconData icon,
    String label,
    bool isDark,
    Color textColor, {
    VoidCallback? onTap,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFFEEEEF5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemQtyControl extends StatefulWidget {
  final String initialQty;
  final String uuid;
  final bool isDark;
  final Color textColor;
  final SaleController controller;
  final Color primaryColor;
  final bool isWeighed;

  const _CartItemQtyControl({
    Key? key,
    required this.initialQty,
    required this.uuid,
    required this.isDark,
    required this.textColor,
    required this.controller,
    required this.primaryColor,
    required this.isWeighed,
  }) : super(key: key);

  @override
  State<_CartItemQtyControl> createState() => _CartItemQtyControlState();
}

class _CartItemQtyControlState extends State<_CartItemQtyControl> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialQty);
  }

  @override
  void didUpdateWidget(covariant _CartItemQtyControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQty != widget.initialQty &&
        _textController.text != widget.initialQty) {
      _textController.text = widget.initialQty;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.isWeighed) {
      if (!validInputsnak(_textController.text, 1, 20, "decimal")) {
        _textController.text = widget.initialQty;
        return;
      }
      double? newQty = double.tryParse(_textController.text);
      if (newQty != null && newQty > 0) {
        widget.controller.updateQuantity(widget.uuid, newQty);
        _textController.text = newQty == newQty.toInt()
            ? newQty.toInt().toString()
            : newQty.toString();
      } else {
        showSnackbar(
          "error".tr,
          "qty_or_weight_must_be_greater_than_zero".tr,
          Colors.red,
        );
        _textController.text = widget.initialQty;
      }
    } else {
      if (!validInputsnak(_textController.text, 1, 20, "number")) {
        _textController.text = widget.initialQty;
        return;
      }
      int? newQty = int.tryParse(_textController.text);
      if (newQty != null && newQty > 0) {
        widget.controller.updateQuantity(widget.uuid, newQty);
        _textController.text = newQty.toString();
      } else {
        showSnackbar(
          "error".tr,
          "qty_must_be_greater_than_zero".tr,
          Colors.red,
        );
        _textController.text = widget.initialQty;
      }
    }
  }

  void _increment() {
    double currentQty = double.tryParse(_textController.text) ?? 1.0;
    currentQty++;
    _textController.text = widget.isWeighed
        ? (currentQty == currentQty.toInt()
              ? currentQty.toInt().toString()
              : currentQty.toString())
        : currentQty.toInt().toString();
    _submit();
  }

  void _decrement() {
    double currentQty = double.tryParse(_textController.text) ?? 1.0;
    if (currentQty > 1) {
      currentQty--;
      _textController.text = widget.isWeighed
          ? (currentQty == currentQty.toInt()
                ? currentQty.toInt().toString()
                : currentQty.toString())
          : currentQty.toInt().toString();
      _submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: widget.isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDark ? Colors.white10 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qtyBtn(
            Icons.add_rounded,
            widget.isDark,
            widget.primaryColor,
            _increment,
          ),
          Container(
            width: 36,
            height: 32,
            alignment: Alignment.center,
            child: TextField(
              controller: _textController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.numberWithOptions(
                decimal: widget.isWeighed,
              ),
              inputFormatters: [
                if (!widget.isWeighed) FilteringTextInputFormatter.digitsOnly,
                if (widget.isWeighed)
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: widget.textColor,
                fontSize: 15,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          _qtyBtn(
            Icons.remove_rounded,
            widget.isDark,
            widget.primaryColor,
            _decrement,
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(
    IconData icon,
    bool isDark,
    Color primaryColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? Colors.white12 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark ? Colors.white : primaryColor,
        ),
      ),
    );
  }
}
