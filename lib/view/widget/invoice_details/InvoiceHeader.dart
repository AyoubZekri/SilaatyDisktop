import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Profaile/invoice/Shwoinvoicecontroller.dart';
import '../../../core/functions/valiedinput.dart';

class InvoiceHeader extends StatelessWidget {
  final String invoiceNo;
  final bool isDark;
  final Color surfaceColor;
  final Color textColor;
  final Shwoinvoicecontroller controller;

  const InvoiceHeader({
    super.key,
    required this.invoiceNo,
    required this.isDark,
    required this.surfaceColor,
    required this.textColor,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final invoice = controller.invoices;
    final productSale = controller.productSale;

    final customerName = [
      invoice?.familyName,
      invoice?.name,
    ].where((e) => e != null && e.trim().isNotEmpty).join(" ");

    final safeCustomerName = customerName.isEmpty
        ? "unknown".tr
        : customerName;

    final issueDate = invoice?.date ?? '';
    final saleType = productSale?.saleType == 3
        ? 'wholesale'.tr
        : (productSale?.saleType == 2 ? 'half_wholesale'.tr : 'retail'.tr);

    final remaining = controller.getRemainingAmount();
    final total = double.tryParse(productSale?.sumPrice.toString() ?? "0") ?? 0;

    String statusStr = '';
    Color statusColor = Colors.green;
    IconData statusIcon = Icons.check_circle;

    if (total == 0) {
      statusStr = 'unknown'.tr;
      statusColor = Colors.grey;
      statusIcon = Icons.help_outline;
    } else if (remaining <= 0) {
      statusStr = 'fully_paid'.tr;
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (remaining < total) {
      statusStr = 'partially_paid'.tr;
      statusColor = Colors.orange;
      statusIcon = Icons.timelapse;
    } else {
      statusStr = 'unpaid'.tr;
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    }

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              // Left: Invoice No & Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        invoiceNo,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(statusIcon, size: 14, color: statusColor),
                            const SizedBox(width: 6),
                            Text(
                              statusStr,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 24),
              // Right: Action Buttons
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.start,
                  textDirection: TextDirection.rtl,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    InkWell(
                      onTap: () {
                        _showPaymentDialog(context);
                      },
                      child: _buildHeaderBtn(
                        Icons.add_card_rounded,
                        'register_payment'.tr,
                        AppColor.primaryPurple,
                        Colors.white,
                        true,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _showDiscountDialog(context);
                      },
                      child: _buildHeaderBtn(
                        Icons.percent,
                        'discount'.tr,
                        Colors.orange.withOpacity(0.1),
                        Colors.orange,
                        false,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await controller.generateArabicPdf();
                      },
                      child: _buildHeaderBtn(
                        Icons.print_outlined,
                        'print'.tr,
                        Colors.blue.withOpacity(0.1),
                        Colors.blue,
                        false,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await controller.printThermalInvoice();
                      },
                      child: _buildHeaderBtn(
                        Icons.receipt_long_outlined,
                        'thermal_print'.tr,
                        Colors.teal.withOpacity(0.1),
                        Colors.teal,
                        false,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (controller.uuid != null) {
                          controller.returnFullInvoice(controller.uuid!);
                        }
                      },
                      child: _buildHeaderBtn(
                        Icons.keyboard_return,
                        'return_invoice'.tr,
                        Colors.orange.withOpacity(0.1),
                        Colors.orange,
                        false,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (controller.uuid != null) {
                          _showDeleteConfirmDialog(context);
                        }
                      },
                      child: _buildHeaderBtn(
                        Icons.delete_outline,
                        'delete'.tr,
                        Colors.red.withOpacity(0.1),
                        Colors.red,
                        false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Info Row
          Row(
            textDirection: TextDirection.rtl,
            children: [
              _buildHeaderInfoItem(
                Icons.business_rounded,
                'customer'.tr,
                safeCustomerName,
                textColor,
              ),
              const Spacer(),
              _buildHeaderInfoItem(
                Icons.calendar_today_outlined,
                'issue_date'.tr,
                issueDate,
                textColor,
              ),
              const SizedBox(width: 48),
              _buildHeaderInfoItem(
                Icons.shopping_cart_outlined,
                'sale_type'.tr,
                saleType,
                textColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Get.dialog(
      barrierColor: Colors.black.withValues(alpha: 0.5),
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColor.primaryPurple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_card_rounded,
                    size: 32,
                    color: AppColor.primaryPurple,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "register_payment".tr,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: controller.paymentPrice,
                  keyboardType: TextInputType.number,
                  validator: (val) => validInput(val ?? "", 20, 1, "decimal"),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: "amount".tr,
                    labelStyle: const TextStyle(color: Colors.grey),
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 24,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColor.primaryPurple,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.grey.withValues(alpha: 0.05),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "cancel".tr,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (controller.uuid != null &&
                                controller.paymentPrice.text.isNotEmpty) {
                              controller.Editinvoise(controller.uuid!);
                              Get.back();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "confirm".tr,
                          style: const TextStyle(
                            fontSize: 16,
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
      ),
    );
  }

  void _showDiscountDialog(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Get.dialog(
      barrierColor: Colors.black.withValues(alpha: 0.5),
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.percent_rounded,
                    size: 32,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "discount".tr,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: controller.discount,
                  keyboardType: TextInputType.number,
                  validator: (val) => validInput(val ?? "", 20, 1, "decimal"),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: "discount_amount".tr,
                    labelStyle: const TextStyle(color: Colors.grey),
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 24,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.orange,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.grey.withValues(alpha: 0.05),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "cancel".tr,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (controller.uuid != null &&
                                controller.discount.text.isNotEmpty) {
                              controller.Editdiscount(controller.uuid!);
                              Get.back();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "confirm".tr,
                          style: const TextStyle(
                            fontSize: 16,
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
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    Get.dialog(
      barrierColor: Colors.black.withValues(alpha: 0.5),
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  size: 32,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "confirm_delete".tr,
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "delete_message".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "cancel".tr,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.uuid != null) {
                          Get.back();
                          controller.deleteInvoice(controller.uuid!);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "delete_confirm_btn".tr,
                        style: const TextStyle(
                          fontSize: 16,
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

  Widget _buildHeaderBtn(
    IconData icon,
    String label,
    Color bg,
    Color contentColor,
    bool filled,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: contentColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: contentColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfoItem(
    IconData icon,
    String label,
    String value,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 6),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(icon, size: 16, color: AppColor.primaryPurple),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
