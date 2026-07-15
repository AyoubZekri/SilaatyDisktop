import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';

class ReportsCSHeader extends StatelessWidget {
  final bool isDark;
  const ReportsCSHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "clients_suppliers_report".tr,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 500,
          child: Text(
            "clients_suppliers_report_desc".tr,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColor.textSecondary : Colors.grey.shade600,
              height: 1.5,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        const SizedBox(height: 48),
        _buildToggleTabs(isDark),
      ],
    );
  }

  Widget _buildToggleTabs(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.1 : 0.04), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          _buildTabItem("customers".tr, true, isDark),
          const SizedBox(width: 8),
          _buildTabItem("suppliers".tr, false, isDark),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? (isDark ? AppColor.primaryPurple : const Color(0xFFF1F5F9)) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? (isDark ? Colors.white : AppColor.primaryPurple) : (isDark ? Colors.white60 : Colors.grey),
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}
