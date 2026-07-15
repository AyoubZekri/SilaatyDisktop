import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:silaaty_desktop/core/constant/Colorapp.dart';
import 'package:silaaty_desktop/core/constant/routes.dart';
import 'package:silaaty_desktop/core/functions/Snacpar.dart';
import '../HomeScreen/SiedBarController.dart';
import '../../view/screen/Statistic/PublicFinance.dart';
import '../../view/screen/Statistic/LowStock.dart';
import '../../view/screen/Statistic/StockValue.dart';
import '../../view/screen/Statistic/StockBalance.dart';
import '../../view/screen/Statistic/ClientsAndSuppliers.dart';
import 'ClientsAndSuppliersController.dart';
import 'CustomerSalesController.dart';
import 'PublicFinanceController.dart';
import 'StockValueController.dart';
import 'Supplierreportscontroller.dart';
import 'StockBalanceController.dart';

class Statisticereportescontroller extends GetxController {
  String? filterController;
  DateTime? customStartDate;
  DateTime? customEndDate;

  final Map<String, String> ranges = {
    "today": "today_filter".tr,
    "yesterday": "yesterday_filter".tr,
    "last_7_days": "last_7_days".tr,
    "last_30_days": "last_30_days".tr,
    "this_month": "this_month".tr,
    "last_month": "last_month".tr,
    "this_year": "this_year".tr,
    "last_year": "last_year".tr,
  };

  var selectedAccount = "all_sellers".obs;

  void changeAccount(String value) {
    selectedAccount.value = value;
    if (Get.isRegistered<Publicfinancecontroller>()) {
      Get.find<Publicfinancecontroller>().changeAccount(value);
    }
    if (Get.isRegistered<ClientsAndSuppliersController>()) {
      Get.find<ClientsAndSuppliersController>().changeAccount(value);
    }
    update();
  }

  final Map<String, String> rangesEn = {
    "today": "Today",
    "yesterday": "Yesterday",
    "last_7_days": "Last 7 days",
    "last_30_days": "Last 30 days",
    "this_month": "This month",
    "last_month": "Last month",
    "this_year": "This year",
    "last_year": "Last year",
  };

  gotoPublicFinance() {
    if (filterController == null &&
        (customStartDate == null || customEndDate == null)) {
      showSnackbar("error".tr, "select_period_error".tr, Colors.red);
      return;
    }

    final currentFilter = filterController;
    final currentFrom = customStartDate;
    final currentTo = customEndDate;

    try {
      final sidebarController = Get.find<Siedbarcontroller>();
      sidebarController.currentPage.value = 7;
      sidebarController.expandedIndex.value = 7;
      if (Get.isRegistered<Publicfinancecontroller>()) {
        final ctrl = Get.find<Publicfinancecontroller>();
        ctrl.filter = currentFilter;
        ctrl.from = currentFrom;
        ctrl.to = currentTo;
        ctrl.getdata();
        sidebarController.changeSubPage(0, () => const PublicFinance());
      } else {
        sidebarController.changeSubPage(0, () {
          Get.put(
            Publicfinancecontroller()
              ..filter = currentFilter
              ..from = currentFrom
              ..to = currentTo
              ..getdata(),
          );
          return const PublicFinance();
        });
      }
    } catch (e) {
      Get.toNamed(
        Approutes.publicfinance,
        arguments: {
          "filter": currentFilter,
          "from": currentFrom,
          "to": currentTo,
        },
      );
    }

    _resetFilters();
  }

  gotoLowStock() {
    try {
      final sidebarController = Get.find<Siedbarcontroller>();
      sidebarController.currentPage.value = 7;
      sidebarController.expandedIndex.value = 7;
      sidebarController.changeSubPage(1, () => const LowStock());
    } catch (e) {
      Get.toNamed(Approutes.lowstock);
    }
  }

  gotoStockBalance() {
    if (filterController == null &&
        (customStartDate == null || customEndDate == null)) {
      showSnackbar("error".tr, "select_period_error".tr, Colors.red);
      return;
    }

    final currentFilter = filterController;
    final currentFrom = customStartDate;
    final currentTo = customEndDate;

    try {
      final sidebarController = Get.find<Siedbarcontroller>();
      sidebarController.currentPage.value = 7;
      sidebarController.expandedIndex.value = 7;
      if (Get.isRegistered<Stockbalancecontroller>()) {
        final ctrl = Get.find<Stockbalancecontroller>();
        ctrl.filter = currentFilter;
        ctrl.from = currentFrom;
        ctrl.to = currentTo;
        ctrl.getdata();
        sidebarController.changeSubPage(2, () => const StockBalance());
      } else {
        sidebarController.changeSubPage(2, () {
          Get.put(
            Stockbalancecontroller()
              ..filter = currentFilter
              ..from = currentFrom
              ..to = currentTo
              ..getdata(),
          );
          return const StockBalance();
        });
      }
    } catch (e) {
      Get.toNamed(
        Approutes.stockbalance,
        arguments: {
          "filter": currentFilter,
          "from": currentFrom,
          "to": currentTo,
        },
      );
    }
    _resetFilters();
  }

  gotoStockValue() {
    if (filterController == null &&
        (customStartDate == null || customEndDate == null)) {
      showSnackbar("error".tr, "select_period_error".tr, Colors.red);
      return;
    }

    final currentFilter = filterController;
    final currentFrom = customStartDate;
    final currentTo = customEndDate;

    try {
      final sidebarController = Get.find<Siedbarcontroller>();
      sidebarController.currentPage.value = 7;
      sidebarController.expandedIndex.value = 7;
      if (Get.isRegistered<Stockvaluecontroller>()) {
        final ctrl = Get.find<Stockvaluecontroller>();
        ctrl.filter = currentFilter;
        ctrl.from = currentFrom;
        ctrl.to = currentTo;
        ctrl.getdata();
        sidebarController.changeSubPage(3, () => const StockValue());
      } else {
        sidebarController.changeSubPage(3, () {
          Get.put(
            Stockvaluecontroller()
              ..filter = currentFilter
              ..from = currentFrom
              ..to = currentTo
              ..getdata(),
          );
          return const StockValue();
        });
      }
    } catch (e) {
      Get.toNamed(
        Approutes.stockvalue,
        arguments: {
          "filter": currentFilter,
          "from": currentFrom,
          "to": currentTo,
        },
      );
    }
    _resetFilters();
  }

  gotoCustomerSales() {
    if (filterController == null &&
        (customStartDate == null || customEndDate == null)) {
      showSnackbar("error".tr, "select_period_error".tr.tr, Colors.red);
      return;
    }

    final currentFilter = filterController;
    final currentFrom = customStartDate;
    final currentTo = customEndDate;

    try {
      final sidebarController = Get.find<Siedbarcontroller>();
      sidebarController.currentPage.value = 7;
      sidebarController.expandedIndex.value = 7;
      if (Get.isRegistered<ClientsAndSuppliersController>()) {
        final ctrl = Get.find<ClientsAndSuppliersController>();
        ctrl.filter = currentFilter;
        ctrl.from = currentFrom;
        ctrl.to = currentTo;
        ctrl.getdata();
        sidebarController.changeSubPage(6, () => const ClientsAndSuppliers());
      } else {
        sidebarController.changeSubPage(6, () {
          Get.put(
            ClientsAndSuppliersController()
              ..filter = currentFilter
              ..from = currentFrom
              ..to = currentTo
              ..getdata(),
          );
          return const ClientsAndSuppliers();
        });
      }
    } catch (e) {
      Get.toNamed(
        Approutes.customersales,
        arguments: {
          "filter": currentFilter,
          "from": currentFrom,
          "to": currentTo,
        },
      );
    }
    _resetFilters();
  }

  gotoSupplierReports() {
    if (filterController == null &&
        (customStartDate == null || customEndDate == null)) {
      showSnackbar("error".tr, "select_period_error".tr.tr, Colors.red);
      return;
    }

    final currentFilter = filterController;
    final currentFrom = customStartDate;
    final currentTo = customEndDate;

    try {
      final sidebarController = Get.find<Siedbarcontroller>();
      sidebarController.currentPage.value = 7;
      sidebarController.expandedIndex.value = 7;
      if (Get.isRegistered<Supplierreportscontroller>()) {
        final ctrl = Get.find<Supplierreportscontroller>();
        ctrl.filter = currentFilter;
        ctrl.from = currentFrom;
        ctrl.to = currentTo;
        ctrl.getdata();
        sidebarController.changeSubPage(4, () => const Center(child: Text("Supplier Reports")));
      } else {
        sidebarController.changeSubPage(4, () {
          Get.put(
            Supplierreportscontroller()
              ..filter = currentFilter
              ..from = currentFrom
              ..to = currentTo
              ..getdata(),
          );
          return const Center(child: Text("Supplier Reports"));
        });
      }
    } catch (e) {
      Get.toNamed(
        Approutes.supplierreports,
        arguments: {
          "filter": currentFilter,
          "from": currentFrom,
          "to": currentTo,
        },
      );
    }
    _resetFilters();
  }

  void _resetFilters() {
    filterController = null;
    customStartDate = null;
    customEndDate = null;
  }

  void showFilterDialog(BuildContext context, VoidCallback onConfirm) {
    String? tempFilter = filterController ?? "today";
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: 500,
              decoration: BoxDecoration(
                color: isDark ? AppColor.surfaceDark : AppColor.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 30,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.close,
                            color: isDark
                                ? AppColor.textSecondary
                                : AppColor.grey,
                          ),
                        ),
                        Text(
                          "select_time_period".tr,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColor.white : AppColor.black,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(width: 48), // Spacer to balance 'X'
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: isDark
                        ? Colors.white10
                        : Colors.grey.withOpacity(0.1),
                  ),

                  // Range List
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      children: ranges.entries.map((entry) {
                        bool isSelected = tempFilter == entry.key;
                        return ListTile(
                          onTap: () => setState(() => tempFilter = entry.key),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 4,
                          ),
                          tileColor: isSelected
                              ? (isDark
                                    ? AppColor.primaryPurple.withOpacity(0.2)
                                    : AppColor.primaryPurple.withOpacity(0.1))
                              : null,
                          title: Row(
                            children: [
                              Text(
                                entry.value,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? AppColor.primaryPurple
                                      : (isDark
                                            ? AppColor.white
                                            : AppColor.black),
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              const Spacer(),
                              Text(
                                rangesEn[entry.key]!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? AppColor.textSecondary
                                      : AppColor.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          trailing: Radio<String>(
                            value: entry.key,
                            groupValue: tempFilter,
                            activeColor: AppColor.primaryPurple,
                            onChanged: (val) =>
                                setState(() => tempFilter = val),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Custom Date Selection Box (Matching new design trigger)
                  InkWell(
                    onTap: () =>
                        _showCustomDateDialog(context, onConfirm, isDark),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: filterController == "custom"
                            ? (isDark
                                  ? AppColor.primaryPurple.withOpacity(0.15)
                                  : AppColor.primaryPurple.withOpacity(0.1))
                            : (isDark
                                  ? AppColor.sidebarDark.withOpacity(0.5)
                                  : const Color(0xFFF8FAFC)),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: filterController == "custom"
                              ? AppColor.primaryPurple
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.date_range_rounded,
                            size: 22,
                            color: AppColor.primaryPurple,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Custom Range",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "custom_period".tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryPurple,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            filterController == "custom"
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: AppColor.primaryPurple,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Footer Actions
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              filterController = tempFilter;
                              Get.back();
                              onConfirm();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryPurple,
                              foregroundColor: AppColor.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child:  Text(
                              "apply_changes".tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () => Get.back(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "cancel".tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark
                                  ? AppColor.textSecondary
                                  : AppColor.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCustomDateDialog(
    BuildContext context,
    VoidCallback onConfirm,
    bool isDark,
  ) {
    DateTime? startDate = customStartDate ?? DateTime.now();
    DateTime? endDate = customEndDate ?? DateTime.now();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: 450,
              decoration: BoxDecoration(
                color: isDark ? AppColor.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close),
                        ),
                        
                       Text(
                          "custom_period_title".tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildDateField(
                          label: "from_date".tr,
                          date: startDate,
                          isDark: isDark,
                          onTap: () async {
                            DateTime? picked = await _showStyledDatePicker(
                              context,
                              startDate!,
                              isDark,
                            );
                            if (picked != null)
                              setState(() => startDate = picked);
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildDateField(
                          label: "to_date".tr,
                          date: endDate,
                          isDark: isDark,
                          onTap: () async {
                            DateTime? picked = await _showStyledDatePicker(
                              context,
                              endDate!,
                              isDark,
                            );
                            if (picked != null)
                              setState(() => endDate = picked);
                          },
                        ),
                        const SizedBox(height: 32),
                        // Info Box
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColor.primaryPurple.withOpacity(0.1)
                                : const Color(0xFFF1F6FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColor.primaryPurple,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "filter_info_text".tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColor.textSecondary
                                        : Colors.grey.shade700,
                                    height: 1.5,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              customStartDate = startDate;
                              customEndDate = endDate;
                              filterController = "custom";
                              Get.close(2); // Close both dialogs
                              onConfirm();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "apply".tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextButton(
                            onPressed: () => Get.back(),
                            style: TextButton.styleFrom(
                              backgroundColor: isDark
                                  ? Colors.white10
                                  : const Color(0xFFE8EFFF),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "cancel".tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                color: AppColor.primaryPurple,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.grey.shade700,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : const Color(0xFFF1F6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColor.primaryPurple.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: AppColor.primaryPurple,
                  size: 20,
                ),
                const Spacer(),
                Text(
                  date != null
                      ? DateFormat('yyyy-MM-dd').format(date)
                      : "select_date".tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColor.white : AppColor.black,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 20), // Placeholder to center text
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<DateTime?> _showStyledDatePicker(
    BuildContext context,
    DateTime initial,
    bool isDark,
  ) {
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: AppColor.primaryPurple,
                    onPrimary: Colors.white,
                    surface: AppColor.surfaceDark,
                    onSurface: Colors.white,
                  ),
                  dialogBackgroundColor: AppColor.surfaceDark,
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColor.primaryPurple,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: AppColor.black,
                  ),
                ),
          child: child!,
        );
      },
    );
  }
}
