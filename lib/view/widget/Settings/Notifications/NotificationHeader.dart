import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'NotificationQuickActions.dart';

class NotificationHeader extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final Color subTextColor;

  const NotificationHeader({
    super.key,
    required this.isDark,
    required this.textColor,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "command_center".tr,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: textColor,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "command_center_desc".tr,
              style: TextStyle(
                fontSize: 16,
                color: subTextColor,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        NotificationQuickActions(isDark: isDark),
      ],
    );
  }
}
