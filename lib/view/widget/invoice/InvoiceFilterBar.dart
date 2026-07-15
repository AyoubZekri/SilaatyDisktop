import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Dashpord/invoicesallcontroller.dart';

class InvoiceFilterBar extends StatelessWidget {
  final bool isDark;
  final Color textColor;

  const InvoiceFilterBar({
    super.key,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Invoicesallcontroller>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              onChanged: (value) => controller.searchInvoices(value),
              textAlign: TextAlign.right,
              style: TextStyle(color: textColor, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'بحث برقم الفاتورة أو اسم العميل...',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                prefixIcon: Icon(Icons.search_rounded, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 32),
          _filterChip(controller, 'الكل', 0),
          const SizedBox(width: 12),
          _filterChip(controller, 'مدفوعة', 1),
          const SizedBox(width: 12),
          _filterChip(controller, 'غير مدفوعة', 2),
          const SizedBox(width: 12),
          _filterChip(controller, 'جزئية', 3),
        ],
      ),
    );
  }

  Widget _filterChip(Invoicesallcontroller controller, String label, int index) {
    final isSelected = controller.filterIndex == index;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      showCheckmark: false,
      onSelected: (val) {
        controller.setFilterIndex(index);
      },
      backgroundColor: isDark
          ? Colors.grey[850]
          : const Color(0xFFF1F3F9),
      selectedColor: AppColor.primaryPurple,
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : (isDark ? Colors.white70 : Colors.black87),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide.none,
    );
  }
}
