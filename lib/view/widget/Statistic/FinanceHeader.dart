import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../controller/SellerController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/Statistice/StatisticeReportesController.dart';

class FinanceHeader extends StatelessWidget {
  final bool isDark;
  final Statisticereportescontroller controller;
  final Widget? extraFilter;
  final VoidCallback onFilterApply;
  final String? title;
  final String? subtitle;
  final bool showAccountFilter;

  const FinanceHeader({
    super.key,
    required this.isDark,
    required this.controller,
    required this.onFilterApply,
    this.extraFilter,
    this.title,
    this.subtitle,
    this.showAccountFilter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "public_finance_overview".tr,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  subtitle ?? "financial_summary_desc".tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColor.textSecondary
                        : Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (extraFilter != null) ...[
                  extraFilter!,
                  const SizedBox(width: 16),
                ],
                if (showAccountFilter) ...[
                  _buildSalesAccountFilter(isDark),
                  const SizedBox(width: 16),
                ],
                _buildFilterButton(context, controller, isDark),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSalesAccountFilter(bool isDark) {
    return GetBuilder<SellerController>(
      init: SellerController(),
      builder: (sellerController) {
        return Obx(
          () => DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              value: controller.selectedAccount.value,
              items: [
                DropdownMenuItem<String>(
                  value: "all_sellers",
                  child: Text(
                    "all_sellers".tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColor.black,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "-1",
                  child: Text(
                    "seller_01".tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColor.black,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                ...sellerController.sellers.map(
                  (seller) => DropdownMenuItem<String>(
                    value: seller['id'].toString(),
                    child: Text(
                      seller['name'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColor.black,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
              ],
              onChanged: (String? newValue) {
            if (newValue != null) {
              controller.changeAccount(newValue);
            }
          },
          buttonStyleData: ButtonStyleData(
            height: 48,
            width: 220,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColor.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
              ),
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isDark ? Colors.white70 : Colors.grey,
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
            width: 220,
            direction: DropdownDirection.right,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark ? AppColor.surfaceDark : Colors.white,
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
              ),
            ),
            offset: const Offset(0, -6),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: WidgetStateProperty.all(6),
              thumbVisibility: WidgetStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
      ),
    ));
    },
    );
  }
  Widget _buildLastUpdateBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(Icons.history, size: 14, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            "last_update_daily".tr,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    BuildContext context,
    Statisticereportescontroller controller,
    bool isDark,
  ) {
    return InkWell(
      onTap: () => controller.showFilterDialog(context, onFilterApply),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.primaryPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.primaryPurple.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 18,
              color: AppColor.primaryPurple,
            ),
            const SizedBox(width: 8),
            Text(
              "select_period".tr,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryPurple,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
