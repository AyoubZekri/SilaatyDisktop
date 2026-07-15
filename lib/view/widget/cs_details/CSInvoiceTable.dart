import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/Profaile/invoice/InvoiceController.dart';
import '../../../core/class/handlingview.dart';

class CSInvoiceTable extends StatelessWidget {
  const CSInvoiceTable({super.key});

  String _formatNumber(double number) {
    if (number == number.truncateToDouble()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();
    final verticalScroll = ScrollController();
    final horizontalScroll = ScrollController();

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;
      final surfaceColor = isDark ? AppColor.surfaceDark : Colors.white;

      return GetBuilder<InvoicesController>(
        builder: (controller) {
          final invoices = controller.filteredInvoices;

          return Container(
            padding: const EdgeInsets.all(32),
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
                      'invoice_history'.tr,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    // Filters
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        _buildFilterTab(0, 'all'.tr, controller.filterType, controller, isDark),
                        const SizedBox(width: 8),
                        _buildFilterTab(1, 'paid'.tr, controller.filterType, controller, isDark),
                        const SizedBox(width: 8),
                        _buildFilterTab(2, 'unpaid'.tr, controller.filterType, controller, isDark),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 420,
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
                          width: 900,
                          child: Scrollbar(
                            controller: verticalScroll,
                            notificationPredicate: (notif) => notif.depth == 1,
                            child: SingleChildScrollView(
                              controller: verticalScroll,
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  _buildTableHeader(isDark),
                                  const SizedBox(height: 12),
                                  Divider(
                                    color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                                    height: 1,
                                  ),
                                  Handlingview(
                                    statusrequest: controller.statusrequest,
                                    widget: invoices.isEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.all(32.0),
                                            child: Center(
                                              child: Text(
                                                'no_data'.tr,
                                                style: TextStyle(color: Colors.grey),
                                              ),
                                            ),
                                          )
                                        : Column(
                                            children: invoices.map((inv) {
                                              final double invSum = inv.invoiceSum ?? 0.0;
                                              final double invPaid = inv.paymentPrice ?? 0.0;
                                              final double discount = inv.discount ?? 0.0;
                                              final double remaining = invSum - invPaid - discount;
                                              
                                              String status = 'unpaid';
                                              if (remaining <= 0) {
                                                status = 'fully_paid';
                                              } else if (invPaid > 0) {
                                                status = 'partially_paid';
                                              }

                                              return Column(
                                                children: [
                                                  _buildInvoiceRow(
                                                    inv,
                                                    inv.number ?? '-',
                                                    inv.date ?? '-',
                                                    _formatNumber(invSum),
                                                    _formatNumber(invPaid),
                                                    status,
                                                    isDark,
                                                    textColor,
                                                    controller,
                                                  ),
                                                  Divider(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05), height: 1),
                                                ],
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
      );
    });
  }

  Widget _buildFilterTab(int index, String label, int currentFilter, InvoicesController controller, bool isDark) {
    final bool active = currentFilter == index;
    return InkWell(
      onTap: () => controller.setFilter(index),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColor.primaryPurple : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(bool isDark) {
    final style = const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(width: 180, child: Text('invoice_no'.tr, textAlign: TextAlign.right, style: style)),
          SizedBox(width: 140, child: Text('issue_date'.tr, textAlign: TextAlign.right, style: style)),
          SizedBox(width: 140, child: Text('total_amount'.tr, textAlign: TextAlign.right, style: style)),
          SizedBox(width: 140, child: Text('total_paid_amount'.tr, textAlign: TextAlign.right, style: style)),
          SizedBox(width: 140, child: Text('status'.tr, textAlign: TextAlign.right, style: style)),
          const Spacer(),
          SizedBox(width: 80, child: Text('actions'.tr, textAlign: TextAlign.center, style: style)),
        ],
      ),
    );
  }

  Widget _buildInvoiceRow(dynamic inv, String no, String date, String total, String paid, String status, bool isDark, Color textColor, InvoicesController controller) {
    Color statusColor;
    String statusText;
    if (status == 'fully_paid') {
      statusColor = const Color(0xFF28C76F);
      statusText = 'paid'.tr;
    } else if (status == 'partially_paid') {
      statusColor = const Color(0xFFFF9F43);
      statusText = 'partially_paid'.tr;
    } else {
      statusColor = const Color(0xFFEA5455);
      statusText = 'unpaid'.tr;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(width: 180, child: Text(no, textAlign: TextAlign.right, style: const TextStyle(color: AppColor.primaryPurple, fontWeight: FontWeight.bold, fontSize: 15))),
          SizedBox(width: 140, child: Text(date, textAlign: TextAlign.right, style: const TextStyle(color: Colors.grey, fontSize: 14))),
          SizedBox(
            width: 140,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text(total, style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(width: 4),
                Text('currency_dz'.tr, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          SizedBox(
            width: 140,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text(paid, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 4),
                Text('currency_dz'.tr, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          SizedBox(
            width: 140,
            child: Row(textDirection: TextDirection.rtl, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold))),
            ]),
          ),
          const Spacer(),
          SizedBox(
            width: 80,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _buildRowAction(icon: Icons.visibility_outlined, color: AppColor.primaryPurple, onTap: () {
                controller.gotoShowInvoice(inv);
              }),
              const SizedBox(width: 8),
              _buildRowAction(icon: Icons.delete_outline_rounded, color: Colors.redAccent, onTap: () {
                controller.deleteInvoice(inv.uuid ?? "");
              }),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildRowAction({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(8), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 18)));
  }
}

