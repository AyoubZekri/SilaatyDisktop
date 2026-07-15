import 'package:flutter/material.dart';
import '../../../core/constant/Colorapp.dart';

class ReportInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isDark;
  final bool hasSidebarBorder;
  final VoidCallback? onTap;

  const ReportInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isDark,
    this.hasSidebarBorder = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColor.surfaceDark : AppColor.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: hasSidebarBorder
              ? const Border(
                  right: BorderSide(color: AppColor.primaryPurple, width: 4),
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColor.white : AppColor.black,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColor.textSecondary : Colors.grey.shade600,
                fontFamily: 'Cairo',
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Icon(Icons.arrow_back,
                size: 20,
                color: isDark ? Colors.white30 : AppColor.primaryPurple),
          ],
        ),
      ),
    );
  }
}
