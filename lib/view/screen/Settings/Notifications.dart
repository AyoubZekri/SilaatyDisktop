import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../widget/Settings/Notifications/NotificationNavBar.dart';
import '../../widget/Settings/Notifications/NotificationHeader.dart';
import '../../widget/Settings/Notifications/NotificationQuickActions.dart';
import '../../widget/Settings/Notifications/NotificationFilters.dart';
import '../../widget/Settings/Notifications/NotificationList.dart';
import '../../widget/Settings/Notifications/NotificationPerformanceSummary.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();

    return Obx(() {
      final bool isDark = sidebarController.isDarkMode.value;
      final backgroundColor = isDark
          ? AppColor.backgroundDark
          : AppColor.backgroundLight;
      final surfaceColor = isDark ? AppColor.surfaceDark : Colors.white;
      final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
      final subTextColor = isDark
          ? AppColor.textSecondary
          : Colors.grey.shade600;

      return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              NotificationHeader(
                isDark: isDark,
                textColor: textColor,
                subTextColor: subTextColor,
              ),
              const SizedBox(height: 32),
              NotificationFilters(isDark: isDark),
              const SizedBox(height: 32),
              NotificationList(
                isDark: isDark,
                surfaceColor: surfaceColor,
                textColor: textColor,
                subTextColor: subTextColor,
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      );
    });
  }
}
