import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';

class ReportsStockValueAnalysis extends StatelessWidget {
  final bool isDark;
  const ReportsStockValueAnalysis({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Warehouse Distribution (Right in RTL, Left in code)
        Expanded(
          flex: 4,
          child: _buildDistributionCard(isDark),
        ),
        const SizedBox(width: 24),
        // Stock Flow Improvement (Left in RTL, Right in code)
        Expanded(
          flex: 6,
          child: _buildFlowImprovementCard(isDark),
        ),
      ],
    );
  }

  Widget _buildFlowImprovementCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF0038A8), // Deep Blue from image
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Stack(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "improve_stock_flow".tr,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'Cairo'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "improve_stock_desc".tr,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.8), height: 1.6, fontFamily: 'Cairo'),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0038A8),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text("view_full_recommendations".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // Graph Placeholder
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.analytics_rounded, size: 80, color: Colors.white24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "warehouse_distribution".tr,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF1E293B), fontFamily: 'Cairo'),
          ),
          const SizedBox(height: 8),
          Text(
            "warehouse_dist_desc".tr,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 14, color: isDark ? AppColor.textSecondary : Colors.grey.shade500, fontFamily: 'Cairo'),
          ),
          const SizedBox(height: 32),
          _buildProgressItem("smartphones_cat".tr, 0.65, Colors.blue, "65%"),
          const SizedBox(height: 20),
          _buildProgressItem("accessories_cat".tr, 0.25, Colors.green, "25%"),
          const SizedBox(height: 20),
          _buildProgressItem("tablets_cat".tr, 0.10, Colors.orange, "10%"),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, double percent, Color color, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo')),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: percent,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
