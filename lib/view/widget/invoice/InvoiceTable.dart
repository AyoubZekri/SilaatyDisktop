import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Dashpord/invoicesallcontroller.dart';
import '../../../data/model/InvoiceModel.dart';
import '../../../core/class/handlingview.dart';

class InvoiceTable extends StatelessWidget {
  final bool isDark;
  final Color titleColor;
  final Color subtitleColor;

  const InvoiceTable({
    super.key,
    required this.isDark,
    required this.titleColor,
    required this.subtitleColor,
  });

  String _formatNumber(double number) {
    if (number == number.truncateToDouble()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final horizontalScroll = ScrollController();
    return GetBuilder<Invoicesallcontroller>(
      builder: (controller) => Container(
        padding: const EdgeInsets.all(24),
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
          children: [
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
                    width: 1200,
                    child: Column(
                      children: [
                        _buildTableHeader(),
                        const SizedBox(height: 8),
                        Divider(
                          color: isDark ? Colors.white10 : Colors.black12,
                          height: 1,
                        ),
                        Handlingview(
                          statusrequest: controller.statusrequest,
                          widget: controller.filteredInvoices.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Text(
                                    'لا توجد فواتير مطابقة للبحث',
                                    style: TextStyle(color: subtitleColor, fontSize: 16),
                                  ),
                                )
                              : Column(
                                  children: List.generate(
                                    controller.paginatedInvoices.length,
                                    (index) => _buildTableRow(controller, index),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildPagination(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    final style = TextStyle(
      fontSize: 14,
      color: subtitleColor,
      fontWeight: FontWeight.bold,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              'رقم الفاتورة',
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
          SizedBox(
            width: 180,
            child: Text('التاريخ', textAlign: TextAlign.right, style: style),
          ),
          SizedBox(
            width: 350,
            child: Text(
              'customer_name'.tr,
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              'المبلغ الإجمالي',
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
          SizedBox(
            width: 120,
            child: Center(child: Text('الحالة', style: style)),
          ),
          const Spacer(),
          SizedBox(
            width: 100,
            child: Center(child: Text('actions'.tr, style: style)),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(Invoicesallcontroller controller, int index) {
    final invoice = controller.filteredInvoices[index];
    
    String status = 'مدفوعة';
    Color color = const Color(0xFF28C76F);
    
    if (invoice.remaining > 0) {
      if (invoice.paymentPrice == 0 || invoice.paymentPrice == null) {
        status = 'غير مدفوعة';
        color = const Color(0xFFF44336);
      } else {
        status = 'جزئية';
        color = const Color(0xFFFF9F43);
      }
    }

    final String clientName = (invoice.name ?? '') + ' ' + (invoice.familyName ?? '');
    final String initial = clientName.trim().isNotEmpty ? clientName.trim().substring(0, 1).toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              '${invoice.number ?? ''}',
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (invoice.date != null && invoice.date!.length >= 10) 
                      ? invoice.date!.substring(0, 10) 
                      : (invoice.date ?? ''),
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  invoice.date != null && invoice.date!.length > 10 ? invoice.date!.substring(11, 16) : '',
                  style: TextStyle(color: subtitleColor, fontSize: 13),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 350,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColor.primaryPurple.withOpacity(0.1),
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: AppColor.primaryPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clientName.trim().isEmpty ? 'عميل غير معروف' : clientName,
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'عميل نقدي',
                        style: TextStyle(color: subtitleColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 180,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  _formatNumber((double.tryParse(invoice.invoiceSum?.toString() ?? '0') ?? 0) - (invoice.discount ?? 0)),
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'dz'.tr,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionIcon(
                  Icons.print_outlined, 
                  Colors.grey,
                  onTap: () {
                    // Logic to print invoice can be added later
                  }
                ),
                _buildActionIcon(
                  Icons.visibility_outlined,
                  AppColor.primaryPurple,
                  onTap: () {
                    controller.gotoShowInvoice(invoice);
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildPagination(Invoicesallcontroller controller) {
    final start = controller.filteredInvoices.isEmpty ? 0 : ((controller.currentPage - 1) * controller.itemsPerPage) + 1;
    final end = (start + controller.paginatedInvoices.length - 1).clamp(0, controller.filteredInvoices.length);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          'عرض $start إلى $end من أصل ${controller.filteredInvoices.length} فاتورة',
          style: TextStyle(color: subtitleColor, fontSize: 14),
        ),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            _buildPageItem('<', false, () => controller.previousPage()),
            ...List.generate(
              controller.totalPages,
              (index) {
                final page = index + 1;
                return _buildPageItem(
                  page.toString(),
                  page == controller.currentPage,
                  () => controller.goToPage(page),
                );
              },
            ),
            _buildPageItem('>', false, () => controller.nextPage()),
          ],
        ),
      ],
    );
  }

  Widget _buildPageItem(String label, bool active, VoidCallback onTap) {
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
