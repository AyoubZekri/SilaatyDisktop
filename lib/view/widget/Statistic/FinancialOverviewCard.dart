import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';

class FinancialOverviewCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onTap;
  const FinancialOverviewCard({super.key, required this.isDark, this.onTap});

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
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildSimpleChart(),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.bar_chart_rounded,
                          color: AppColor.primaryPurple),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "financial_overview".tr,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColor.white : AppColor.black,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "financial_overview_desc".tr,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColor.textSecondary : Colors.grey.shade600,
                        height: 1.5,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: Text(
                        "view_detailed_report".tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                      ),
                      style: TextButton.styleFrom(
                          foregroundColor: AppColor.primaryPurple),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleChart() {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : const Color(0xFFF8F9FD),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildBar(100, AppColor.primaryPurple),
          _buildBar(60, AppColor.primaryPurple.withOpacity(0.4)),
          _buildBar(80, AppColor.primaryPurple.withOpacity(0.7)),
          _buildBar(50, AppColor.primaryPurple.withOpacity(0.3)),
        ],
      ),
    );
  }

  Widget _buildBar(double height, Color color) {
    return Container(
      width: 20,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
