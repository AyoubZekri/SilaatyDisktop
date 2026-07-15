import 'package:silaaty_desktop/view/screen/sale/InvoiceDetails.dart';
import 'package:silaaty_desktop/core/class/Statusrequest.dart';
import 'package:silaaty_desktop/core/constant/routes.dart';
import 'package:silaaty_desktop/data/datasource/Remote/invoiceData.dart';
import 'package:silaaty_desktop/data/model/InvoiceModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/functions/Snacpar.dart';
import '../../../core/services/Services.dart';

class InvoicesController extends GetxController {
  int selectedIndex = 3;
  String? uuid;
  int filterType = 0; // 0 = All, 1 = Paid, 2 = Unpaid
  late TextEditingController dateController;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  Statusrequest statusrequest = Statusrequest.none;
  Invoicedata invoicedata = Invoicedata(Get.find());
  InvoiceData? invoice;

  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  addInvoice() async {
    if (formstate.currentState!.validate()) {
      final String uuidinvoice = Uuid().v4();
      update();
      Map<String, Object?> data = {
        "uuid": uuidinvoice,
        'Transaction_uuid': uuid,
        'invoies_payment_date': dateController.text,
        "user_id": id,
        "invoies_numper":
            DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10),
        "invoies_date": DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
        "created_at": DateTime.now().toIso8601String(),
      };
      var result = await invoicedata.addinvoice(data);

      print("==================================================$result");

      if (result["status"] == 1) {
        dateController.clear();
        Get.back();
        showInvoice();
        Get.find<RefreshService>().fire();
        // showSnackbar("success".tr, "add_success".tr, Colors.green);
      } else {
        showSnackbar("error".tr, "operation_failed".tr, Colors.red);
        statusrequest = Statusrequest.failure;
      }
    }
  }

  EditInvoice(String invuuid) async {
    if (formstate.currentState!.validate()) {
      Map<String, Object?> data = {
        "uuid": invuuid,
        'invoies_payment_date': dateController.text,
      };
      var result = await invoicedata.Editinvoise(data);

      print("==================================================$result");

      if (result) {
        dateController.clear();
        Get.back();
        Get.find<RefreshService>().fire();
        showInvoice();
        // showSnackbar("success".tr, "edit_success".tr, Colors.green);
      } else {
        showSnackbar("error".tr, "operation_failed".tr, Colors.red);
        statusrequest = Statusrequest.failure;
      }
    }
  }

  deleteInvoice(String invuuid) async {
    Map<String, Object?> data = {
      "uuid": invuuid,
    };
    var result = await invoicedata.deleteinvoice(data);
    print("==================================================$result");

    if (result["status"] == 1) {
      Get.back();
      showInvoice();
      Get.find<RefreshService>().fire();
      // showSnackbar("success".tr, "delete_success".tr, Colors.green);
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }
  }

  showInvoice() async {
    update();
    Map<String, Object?> data = {'transaction_uuid': uuid};
    var rseult = await invoicedata.getMyInvoicesByTransaction(data);
    print("==================================================$rseult");

    if (rseult.isNotEmpty) {
      final model = InvoiceData.fromJson(rseult['data']);
      invoice = model;
      statusrequest = Statusrequest.success;
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  switchtransactions(int idtrn) async {
    update();
    Map<String, Object?> data = {'uuid': uuid};
    var result = await invoicedata.switchStatus(data);
    print("==================================================$result");

    if (result["status"] == 1) {
      // showSnackbar("success".tr, "switchSuccess".tr, Colors.green);
      showInvoice();
    } else {
      showSnackbar("error".tr, "switchFailed".tr, Colors.red);
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  gotoNewSale() {
    Get.toNamed(Approutes.newSale, arguments: {
      "type": invoice!.transaction!.transactions,
      "uuid": invoice!.transaction!.uuid,
      "name": invoice!.transaction!.name,
      "famlyname": invoice!.transaction!.familyName,
    });
  }

  Future<void> gotoShowInvoice(InvoiceItem invoice) async {
    Get.dialog(
      barrierColor: Colors.black.withValues(alpha: 0.5),
      InvoiceDetailsScreen(
        invoiceNo: invoice.number ?? "",
        invoiceData: invoice,
      ),
    );
  }

  @override
  void onInit() {
    dateController = TextEditingController();
    if (Get.arguments != null && Get.arguments["uuid"] != null) {
      uuid = Get.arguments["uuid"];
      showInvoice();
    }
    super.onInit();
  }

  void setFilter(int type) {
    filterType = type;
    update();
  }

  List<InvoiceItem> get filteredInvoices {
    if (invoice == null || invoice!.invoices == null) return [];
    if (filterType == 0) return invoice!.invoices!;

    return invoice!.invoices!.where((inv) {
      final double invSum = inv.invoiceSum ?? 0.0;
      final double invPaid = inv.paymentPrice ?? 0.0;
      final double discount = inv.discount ?? 0.0;
      final double remaining = invSum - invPaid - discount;
      bool isPaid = remaining <= 0;

      if (filterType == 1) return isPaid; // Paid
      if (filterType == 2) return !isPaid; // Unpaid
      return true;
    }).toList();
  }

  String getRemainingAmount() {
    final total = invoice?.sumPrice ?? 0.0;
    final paid = invoice?.sumPaymentPrice ?? 0.0;
    final remaining = total - paid;
    return remaining.toStringAsFixed(2);
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  void changeSelectedIndex(int index) {
    selectedIndex = index;
    update();
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

  refreshData() async {
    await showInvoice();
    update();
  }
}
