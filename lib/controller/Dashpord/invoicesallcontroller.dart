import 'package:silaaty_desktop/view/screen/sale/InvoiceDetails.dart';
import 'package:silaaty_desktop/core/constant/routes.dart';
import 'package:silaaty_desktop/data/datasource/Remote/invoiceData.dart';
import 'package:silaaty_desktop/data/model/InvoiceModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/class/Statusrequest.dart';
import '../../core/functions/Snacpar.dart';
import '../../core/services/Services.dart';

class Invoicesallcontroller extends GetxController {
  int selectedIndex = 1;

  Invoicedata invoicedata = Invoicedata(Get.find());

  Statusrequest statusrequest = Statusrequest.none;
  List<InvoiceItem> invoices = [];
  List<InvoiceItem> filteredInvoices = [];
  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  // Filtering & Stats
  int filterIndex = 0; // 0: All, 1: Paid, 2: Unpaid, 3: Partial
  String currentQuery = '';
  double totalCollected = 0.0;
  double totalPending = 0.0;
  int totalOverdue = 0;

  // Pagination
  int currentPage = 1;
  int itemsPerPage = 10;

  int get totalPages => (filteredInvoices.isEmpty) ? 1 : (filteredInvoices.length / itemsPerPage).ceil();

  List<InvoiceItem> get paginatedInvoices {
    final startIndex = (currentPage - 1) * itemsPerPage;
    return filteredInvoices.skip(startIndex).take(itemsPerPage).toList();
  }

  void nextPage() {
    if (currentPage < totalPages) {
      currentPage++;
      update();
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      update();
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      currentPage = page;
      update();
    }
  }

  void changeSelectedIndex(int index) {
    selectedIndex = index;
    update();
  }

  showInvoice() async {
    var result = await invoicedata.allinvoise();
    print("==================================================$result");

    if (result.isNotEmpty) {
      final invoicesJson = result['data']['invoices'] as List<dynamic>;
      invoices =
          invoicesJson.map((json) => InvoiceItem.fromJson(json)).toList();
      _calculateStats();
      applyFilters();
      statusrequest = Statusrequest.success;
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  void _calculateStats() {
    totalCollected = 0.0;
    totalPending = 0.0;
    totalOverdue = 0;

    for (var inv in invoices) {
      totalCollected += inv.paymentPrice ?? 0.0;
      totalPending += inv.remaining;
      if (inv.remaining > 0) {
        totalOverdue++;
      }
    }
  }

  void setFilterIndex(int index) {
    filterIndex = index;
    applyFilters();
  }

  void searchInvoices(String query) {
    currentQuery = query;
    applyFilters();
  }

  void applyFilters() {
    final lowerQuery = currentQuery.toLowerCase();

    filteredInvoices = invoices.where((invoiceData) {
      // Apply Search Query
      final name = invoiceData.name?.toLowerCase() ?? '';
      final family = invoiceData.familyName?.toLowerCase() ?? '';
      final data = invoiceData.date?.toLowerCase() ?? '';
      final numper = invoiceData.number?.toLowerCase() ?? '';

      final matchesQuery = lowerQuery.isEmpty ||
          name.contains(lowerQuery) ||
          family.contains(lowerQuery) ||
          numper.contains(lowerQuery) ||
          data.contains(lowerQuery);

      if (!matchesQuery) return false;

      // Apply Filter Index
      // 0: All, 1: Paid, 2: Unpaid, 3: Partial
      if (filterIndex == 1) {
        return invoiceData.isPaid;
      } else if (filterIndex == 2) {
        return invoiceData.remaining > 0 && (invoiceData.paymentPrice == 0 || invoiceData.paymentPrice == null);
      } else if (filterIndex == 3) {
        return invoiceData.remaining > 0 && (invoiceData.paymentPrice ?? 0) > 0;
      }

      return true;
    }).toList();

    currentPage = 1; // Reset pagination when filter changes
    update();
  }

  deleteInvoice(String invuuid) async {
    Map<String, Object?> data = {
      "uuid": invuuid,
    };
    var result = await invoicedata.deleteinvoice(data);
    print("==================================================$result");

    if (result["status"] == 1) {
      // showSnackbar("${"success".tr}", "delete_success".tr, Colors.green);
      Get.find<RefreshService>().fire();
      showInvoice();
    } else {
      showSnackbar("❌ ${"error".tr}", "operation_failed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  void gotoSaleNew() {
    Get.toNamed(Approutes.newSale);
  }

  void gotoShowInvoice(InvoiceItem invoice) {
    Get.dialog(
      barrierColor: Colors.black.withValues(alpha: 0.5),
      InvoiceDetailsScreen(
        invoiceNo: invoice.number ?? "",
        invoiceData: invoice,
      ),
    );
  }

  String getMonthAbbreviation(String? date) {
    if (date == null || date.length < 7) return '';
    final month = date.substring(5, 7);
    const months = {
      '01': 'Jan',
      '02': 'Feb',
      '03': 'Mar',
      '04': 'Apr',
      '05': 'May',
      '06': 'Jun',
      '07': 'Jul',
      '08': 'Aug',
      '09': 'Sep',
      '10': 'Oct',
      '11': 'Nov',
      '12': 'Dec',
    };
    return months[month] ?? '';
  }

  @override
  void onInit() {
    showInvoice();
    super.onInit();
  }
}
