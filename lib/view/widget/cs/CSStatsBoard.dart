import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/Profaile/transaction/transactionController.dart';

class CSStatsBoard extends StatelessWidget {
  const CSStatsBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final cardColor = isDark ? AppColor.surfaceDark : Colors.white;
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;

      return GetBuilder<Transactioncontroller>(
        builder: (csController) {
          int totalCount = csController.transaction.length;
          double totalDebt = 0;
          double totalCredit = 0;
          
          for (var data in csController.transaction) {
            final sumPrice = double.tryParse(data.sumPrice?.toString() ?? '0') ?? 0;
            if (sumPrice < 0) {
              totalDebt += sumPrice.abs();
            } else {
              totalCredit += sumPrice;
            }
          }
          
          final isSupplier = csController.type == 1;

          return Row(
            textDirection: TextDirection.rtl,
            children: [
              // Total Customers/Suppliers Card
              Expanded(
                child: _buildStatCard(
                  title: isSupplier ? 'suppliers'.tr : 'customers'.tr,
                  value: totalCount.toString(),
                  isPositive: true,
                  isDark: isDark,
                  cardColor: cardColor,
                  textColor: textColor,
                  icon: isSupplier ? Icons.local_shipping_outlined : Icons.people_outline_rounded,
                  iconColor: const Color(0xFF003AB9),
                ),
              ),
              const SizedBox(width: 24),
              // Total Debt Card (They owe us)
              Expanded(
                child: _buildStatCard(
                  title: 'إجمالي الديون (لنا)',
                  value: totalDebt.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), ''),
                  currency: 'currency_dz'.tr,
                  isPositive: false,
                  isDark: isDark,
                  cardColor: cardColor,
                  textColor: textColor,
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: const Color(0xFFF44336),
                ),
              ),
              const SizedBox(width: 24),
              // Total Credit Card (We owe them)
              Expanded(
                child: _buildStatCard(
                  title: 'إجمالي المستحقات (علينا)',
                  value: totalCredit.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), ''),
                  currency: 'currency_dz'.tr,
                  isDark: isDark,
                  cardColor: cardColor,
                  textColor: textColor,
                  icon: Icons.payments_outlined,
                  iconColor: const Color(0xFF28C76F),
                ),
              ),
            ],
          );
        }
      );
    });
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    String? currency,
    String? percentage,
    String? trend,
    bool isPositive = true,
    required bool isDark,
    required Color cardColor,
    required Color textColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      if (currency != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          currency,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            textDirection: TextDirection.rtl,
            children: [
              if (percentage != null) ...[
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive
                      ? const Color(0xFF28C76F)
                      : const Color(0xFFF44336),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${isPositive ? '+' : '-'}$percentage',
                  style: TextStyle(
                    color: isPositive
                        ? const Color(0xFF28C76F)
                        : const Color(0xFFF44336),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
              if (trend != null) ...[
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: const Color(0xFF28C76F),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  trend,
                  style: const TextStyle(
                    color: Color(0xFF28C76F),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
