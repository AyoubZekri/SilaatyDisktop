import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/Colorapp.dart';

class NotificationFilters extends StatelessWidget {
  final bool isDark;

  const NotificationFilters({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildFilterChip("all".tr, true, isDark),
          _buildFilterChip("unread".tr, false, isDark),
          _buildFilterChip("system_alerts".tr, false, isDark),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool active, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      decoration: BoxDecoration(
        color: active
            ? (isDark ? AppColor.surfaceDark : Colors.white)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: active
            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active
              ? (isDark ? Colors.white : AppColor.primaryPurple)
              : Colors.grey,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}
