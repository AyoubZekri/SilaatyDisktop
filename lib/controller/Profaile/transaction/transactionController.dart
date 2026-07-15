import 'package:silaaty_desktop/controller/Profaile/transaction/Edittransactioncontroller.dart';
import 'package:silaaty_desktop/core/class/Statusrequest.dart';
import 'package:silaaty_desktop/core/constant/routes.dart';
import 'package:silaaty_desktop/data/datasource/Remote/transactiondata.dart';
import 'package:silaaty_desktop/data/model/transaction_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Transactioncontroller extends GetxController {
  final Transactiondata transactiondata = Transactiondata(Get.find());
  String query = "";

  int get totalItems => transaction.length;

  void changeTab(int index) {
    type = index == -1 ? null : index;
    getTransactions();
  }

  void onSearch(String val) {
    query = val;
    getTransactions();
  }

  List<Data> transaction = [];
  Statusrequest statusrequest = Statusrequest.none;
  int? type;

  // Pagination
  int currentPage = 1;
  int itemsPerPage = 10;

  int get totalPages => (transaction.isEmpty) ? 1 : (transaction.length / itemsPerPage).ceil();

  List<Data> get paginatedTransactions {
    final startIndex = (currentPage - 1) * itemsPerPage;
    return transaction.skip(startIndex).take(itemsPerPage).toList();
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

  getTransactions() async {
    update();

    Map<String, Object?> data = {
      'transactions': type,
      "query": query,
    };
    var result = await transactiondata.showTransactions(data);
    print("============================================== $result");

    if (result.isNotEmpty) {
      transaction =
          result.map((e) => Data.fromJson(e as Map<String, dynamic>)).toList();
      statusrequest = Statusrequest.success;
    } else {
      transaction = [];
      statusrequest = Statusrequest.failure;
    }

    currentPage = 1;
    update();
  }

  deletetransaction(String uuid) async {
    Map<String, Object?> data = {'uuid': uuid};
    var result = await transactiondata.deletetransaction(data);

    print("============================================== $result");

    if (result == true) {
      await getTransactions();
    } else {
      statusrequest = Statusrequest.failure;
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
      update();
    }
  }

  Future<void> GotoAddDealer() async {
    final result =
        await Get.toNamed(Approutes.AddDealer, arguments: {"type": type});
    if (result == true) {
      getTransactions();
    }
  }

  Future<void> GotoAddConvict() async {
    final result =
        await Get.toNamed(Approutes.AddConvict, arguments: {"type": type});
    if (result == true) {
      getTransactions();
    }
  }

  Future<void> GotoEditDealer(String uuid) async {
    final trans = transaction.firstWhere(
      (t) => t.transaction!.uuid! == uuid,
      orElse: () => throw Exception("Transaction not found"),
    );
    final controller = Get.put(EditTransactionController());
    controller.initData(trans);
    final result = await Get.toNamed(Approutes.EditDealer);
    if (result == true) {
      getTransactions();
    }
  }

  Future<void> GotoEditConvist(String uuid) async {
    final trans = transaction.firstWhere(
      (t) => t.transaction!.uuid! == uuid,
      orElse: () => throw Exception("Transaction not found"),
    );
    final controller = Get.put(EditTransactionController());
    controller.initData(trans);
    final result = await Get.toNamed(Approutes.EditConvict);
    if (result == true) {
      getTransactions();
    }
  }

  Future<void> Gotoinvoiceconvist(String uuid) async {
    final result =
        await Get.toNamed(Approutes.invoice, arguments: {"uuid": uuid});
    if (result == true) {
      getTransactions();
    }
  }

  GotoBacksale(String uuid, String name, String famlyname) {
    print("Returning customer: $name $famlyname");
    Get.back(result: {"uuid": uuid, "name": name, "famlyname": famlyname});
  }

  @override
  void onInit() {
    type = Get.arguments?["type"];
    // إذا لم يتم تحديد النوع نجعله null ليعرض "الكل" أو 2 ليعرض "العملاء" كافتراضي
    if (type == 0) type = 2; // لتصحيح أي تحويلات قديمة لـ 0
    getTransactions();
    super.onInit();
  }

  refreshData() async {
    await getTransactions();
    update();
  }

  void showSnackbar(String title, String message, Color bgColor) {
    Get.snackbar(
      title,
      message,
      backgroundColor: bgColor,
      colorText: Colors.white,
      icon: const Icon(Icons.info, color: Colors.white),
      snackPosition: SnackPosition.TOP,
    );
  }
}
