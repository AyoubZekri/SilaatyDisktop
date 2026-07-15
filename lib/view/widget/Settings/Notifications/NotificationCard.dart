import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/Colorapp.dart';

class NotificationCard extends StatelessWidget {
  final bool isDark;
  final Color surfaceColor;
  final Color textColor;
  final Color subTextColor;
  final String title;
  final String desc;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool hasBadge;
  final bool showActions;

  const NotificationCard({
    super.key,
    required this.isDark,
    required this.surfaceColor,
    required this.textColor,
    required this.subTextColor,
    required this.title,
    required this.desc,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.hasBadge,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: hasBadge ? Border.all(color: AppColor.primaryPurple.withOpacity(0.3), width: 1.5) : null,
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Cairo')),
                    const SizedBox(width: 12),
                    if (hasBadge) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColor.primaryPurple, shape: BoxShape.circle)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                      child: Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Cairo')),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(desc, style: TextStyle(fontSize: 14, color: subTextColor, height: 1.5, fontFamily: 'Cairo'), textAlign: TextAlign.right),
                if (showActions) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    textDirection: TextDirection.rtl,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: Text("view_details".tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () {},
                        child: Text("ignore".tr, style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
