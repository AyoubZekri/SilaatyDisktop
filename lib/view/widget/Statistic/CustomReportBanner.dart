import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';

class CustomReportBanner extends StatelessWidget {
  final bool isDark;
  const CustomReportBanner({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColor.primaryPurple.withOpacity(0.15), AppColor.primaryPurple.withOpacity(0.15)]
              : [AppColor.primaryPurple.withOpacity(0.05), AppColor.primaryPurple.withOpacity(0.15)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: isDark ? Border.all(color: Colors.white10) : null,
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "need_custom_report".tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColor.white : const Color(0xFF1E3A8A),
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "custom_report_desc".tr,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? AppColor.textSecondary : Colors.grey.shade700,
                    height: 1.6,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColor.primaryPurple : Colors.white,
                    foregroundColor: isDark ? Colors.white : AppColor.primaryPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "start_designing".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Cairo'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            flex: 1,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(Icons.dashboard_customize_outlined,
                    size: 80, color: isDark ? Colors.white24 : Colors.black12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
