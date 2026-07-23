import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/class/Statusrequest.dart';
import '../../core/constant/Colorapp.dart';
import '../../core/constant/routes.dart';
import '../../core/functions/Snacpar.dart';
import '../../core/functions/dialogDelete.dart';
import '../../data/datasource/Remote/SaleData.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../core/services/Services.dart';
import '../../data/datasource/Remote/transactiondata.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import '../../core/constant/imageassets.DART';
import '../../core/functions/valiedinput.dart';
import '../../view/widget/CustemTextField.dart';
import '../../data/datasource/Remote/Prodact/Prodact_data.dart';
import '../../core/class/Crud.dart';

class SaleController extends GetxController {
  int? type;
  RxInt saleType = 1.obs; // 1 = Retail, 2 = Half Wholesale, 3 = Wholesale
  RxBool isCashCustomer = true.obs;
  var discount = 0.0.obs;
  RxString selectedCustomer = ''.obs;
  List<String> get customers => [
    if (type != 1) "virtualCustomer".tr,
    type == 1 ? 'اختر مورد'.tr : 'اختر عميل'.tr,
    type == 1 ? 'مورد جديد'.tr : 'عميل جديد'.tr,
  ];

  var selectedUuid = ''.obs;

  TextEditingController searchController = TextEditingController();
  RxList<Map<String, dynamic>> customersList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredCustomersList =
      <Map<String, dynamic>>[].obs;

  void fetchCustomers() async {
    // type == 1 means purchase -> fetch suppliers (transactions = 1)
    // type != 1 means sale -> fetch customers (transactions = 0)
    int transType = type == 1 ? 1 : 2;
    var result = await transactiondata.showTransactions({
      "query": "",
      "transactions": transType,
    });
    customersList.assignAll(
      result.map((e) {
        var t = Map<String, dynamic>.from(e['transaction'] as Map);
        t['sum_price'] = e['sum_price'];
        return t;
      }).toList(),
    );
    filteredCustomersList.assignAll(customersList);
  }

  void searchCustomer(String query) {
    if (query.isEmpty) {
      filteredCustomersList.assignAll(customersList);
    } else {
      filteredCustomersList.assignAll(
        customersList.where((c) {
          final name = '${c['name']} ${c['family_name'] ?? ''}'.toLowerCase();
          final phone = c['phone_number']?.toString().toLowerCase() ?? '';
          return name.contains(query.toLowerCase()) ||
              phone.contains(query.toLowerCase());
        }).toList(),
      );
    }
  }

  var selectedName = ''.obs;
  var selectedFamilyName = ''.obs;

  final Transactiondata transactiondata = Transactiondata(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  Saledata saledata = Saledata();
  RxList<Map<String, dynamic>> selectedProducts = <Map<String, dynamic>>[].obs;

  double totalallPrice = 0.0;
  int totalItems = 0;

  void addProducts(List<Map<String, dynamic>> products) {
    for (var product in products) {
      final exists = selectedProducts.any((p) => p['uuid'] == product['uuid']);
      if (!exists) {
        selectedProducts.add(product);
      }
    }

    _calculateTotals();
    update();
  }

  void updateQuantity(String uuid, num newQuantity) {
    final index = selectedProducts.indexWhere((item) => item['uuid'] == uuid);
    if (index != -1) {
      var item = selectedProducts[index];
      // Convert to num to safely compare
      num maxQty = num.tryParse(item["quantity_item"].toString()) ?? 0;

      if (newQuantity <= maxQty || type == 1) {
        item['quantity'] = newQuantity;

        final price = type == 1
            ? (item['price_Purchase'] ?? 0) as num
            : (item['price'] ?? 0) as num;
        item['total'] = price * newQuantity;

        selectedProducts[index] = Map<String, dynamic>.from(item);

        _calculateTotals();
        update();
      } else {
        showSnackbar("خطأ".tr, "الكمية غير متوفرة".tr, Colors.red);
        print("===========error");
      }
    }
  }

  void updateProductPrice(String uuid, double newPrice) {
    final index = selectedProducts.indexWhere((item) => item['uuid'] == uuid);
    if (index != -1) {
      var item = selectedProducts[index];
      if (type == 1) {
        item['price_Purchase'] = newPrice;
      } else {
        item['price'] = newPrice;
      }
      item['total'] = newPrice * item['quantity'];
      selectedProducts[index] = Map<String, dynamic>.from(item);
      _calculateTotals();
      update();
    }
  }

  void deleteProduct(String uuid) {
    final index = selectedProducts.indexWhere((item) => item['uuid'] == uuid);
    if (index != -1) {
      selectedProducts.removeAt(index);
      _calculateTotals();
      update();
    }
  }

  double getSalePrice(Map<String, dynamic> productData) {
    // Access observable to prevent Obx error when returning early for type == 1
    final _ = saleType.value;

    if (type == 1) {
      return double.tryParse(
            productData['product_price_purchase'].toString(),
          ) ??
          0.0;
    }

    double retailPrice =
        double.tryParse(productData['product_price'].toString()) ?? 0.0;

    if (saleType.value == 3) {
      double wholesalePrice =
          double.tryParse(productData['product_price_wholesale'].toString()) ??
          0.0;
      return wholesalePrice > 0 ? wholesalePrice : retailPrice;
    } else if (saleType.value == 2) {
      double halfWholesalePrice =
          double.tryParse(
            productData['product_price_half_wholesale'].toString(),
          ) ??
          0.0;
      return halfWholesalePrice > 0 ? halfWholesalePrice : retailPrice;
    }

    return retailPrice;
  }

  void _calculateTotals() {
    totalItems = selectedProducts.length;
    totalallPrice = selectedProducts.fold(
      0.0,
      (sum, item) =>
          sum +
          ((type == 1 ? item['price_Purchase'] : item['price']) *
              item['quantity']),
    );
  }

  void changeSaleType(int newType) {
    if (saleType.value == newType) return;
    saleType.value = newType;

    // Recalculate price for all selected products based on the new type
    for (var i = 0; i < selectedProducts.length; i++) {
      var item = selectedProducts[i];
      if (type != 1) {
        double newPrice = getSalePrice(item);
        item['price'] = newPrice;
        item['total'] = newPrice * item['quantity'];
        selectedProducts[i] = Map<String, dynamic>.from(item);
      }
    }

    _calculateTotals();
    update();
  }

  void showWeightDialog(
    Map<String, dynamic> productData, {
    int? existingIndex,
  }) {
    TextEditingController weightController = TextEditingController();
    TextEditingController totalPriceController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final unitPrice = getSalePrice(productData);

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.backgroundcolor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.balance_rounded,
                      size: 40,
                      color: AppColor.backgroundcolor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    "تحديد الوزن".tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColor.backgroundcolor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Product Name
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      productData['product_name'] ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Weight Input
                  CustemTextField(
                    controller: weightController,
                    hint: "الوزن (كغ)".tr,
                    icon: Icons.scale_rounded,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    validator: (val) =>
                        validInput(val ?? "", 100, 1, "decimal"),
                    onChanged: (val) {
                      if (unitPrice > 0) {
                        double? weight = double.tryParse(val);
                        if (weight != null) {
                          totalPriceController.text = (weight * unitPrice)
                              .toStringAsFixed(2)
                              .replaceAll(RegExp(r'0*$'), '')
                              .replaceAll(RegExp(r'\.$'), '');
                        } else {
                          totalPriceController.clear();
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Total Price Input
                  CustemTextField(
                    controller: totalPriceController,
                    hint: "السعر الإجمالي".tr,
                    icon: Icons.payments_rounded,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    validator: (val) =>
                        validInput(val ?? "", 10000000, 1, "decimal"),
                    onChanged: (val) {
                      if (unitPrice > 0) {
                        double? price = double.tryParse(val);
                        if (price != null) {
                          weightController.text = (price / unitPrice)
                              .toStringAsFixed(3);
                        } else {
                          weightController.clear();
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;
                            double? weight = double.tryParse(
                              weightController.text,
                            );
                            if (weight != null && weight > 0) {
                              final uuid =
                                  productData['uuid'] ??
                                  productData['id'] ??
                                  '';
                              final name = productData['product_name'] ?? '';
                              final price = getSalePrice(productData);

                              if (existingIndex != null) {
                                selectedProducts[existingIndex]['quantity'] +=
                                    weight;
                                selectedProducts[existingIndex]['total'] =
                                    (type == 1
                                        ? selectedProducts[existingIndex]['price_Purchase']
                                        : selectedProducts[existingIndex]['price']) *
                                    selectedProducts[existingIndex]['quantity'];
                                selectedProducts[existingIndex] =
                                    Map<String, dynamic>.from(
                                      selectedProducts[existingIndex],
                                    );
                              } else {
                                selectedProducts.add({
                                  "uuid": uuid,
                                  "name": name,
                                  "price": type == 1 ? 0.0 : price,
                                  "price_Purchase": type == 1
                                      ? price
                                      : double.tryParse(
                                              productData['product_price_purchase']
                                                  .toString(),
                                            ) ??
                                            0.0,
                                  "quantity": weight,
                                  "total": price * weight,
                                  "type_item": 2,
                                  "quantity_item":
                                      productData['product_quantity'],
                                  "product_price": productData['product_price'],
                                  "product_price_wholesale":
                                      productData['product_price_wholesale'],
                                  "product_price_half_wholesale":
                                      productData['product_price_half_wholesale'],
                                });
                              }
                              _calculateTotals();
                              update();
                              Get.back();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.backgroundcolor,
                            elevation: 8,
                            shadowColor: AppColor.backgroundcolor.withOpacity(
                              0.4,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            textDirection: TextDirection.rtl,
                            children: [
                              const Icon(
                                Icons.check_circle_outline_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "تأكيد".tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextButton(
                          onPressed: () => Get.back(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "إلغاء".tr,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double get totalPrice => selectedProducts.fold(
    0.0,
    (sum, p) =>
        sum +
        ((type == 1 ? p['price_Purchase'] : p['price']) * (p["quantity"] ?? 1)),
  );

  void selectCustomer(String value) async {
    selectedCustomer.value = value;

    if (value == 'اختر عميل'.tr || value == 'اختر مورد'.tr) {
      var result = await Get.toNamed(
        Approutes.client,
        arguments: {"type": type == 1 ? 1 : 2},
      );
      if (result != null) {
        selectedUuid.value = result['uuid'] ?? '';
        selectedName.value = result['name'] ?? '';
        selectedFamilyName.value = result['famlyname'] ?? '';
        selectedCustomer.value =
            '${selectedName.value} ${selectedFamilyName.value}';
        print("===================$selectedCustomer");
      }
    } else if (value == 'عميل جديد'.tr || value == 'مورد جديد'.tr) {
      var result = await Get.toNamed(
        type == 1 ? Approutes.AddDealer : Approutes.AddConvict,
        arguments: {"type": type == 1 ? 1 : 2},
      );
      print("===================$result");
      if (result != null) {
        selectedUuid.value = result['uuid'] ?? '';
        selectedName.value = result['name'] ?? '';
        selectedFamilyName.value = result['famlyname'] ?? '';

        selectedCustomer.value =
            '${selectedName.value} ${selectedFamilyName.value}';
      }
    } else {
      // Walk-in customer
      selectedUuid.value = '';
      selectedName.value = '';
      selectedFamilyName.value = '';
    }
  }

  search(String codepar) async {
    update();
    String cleaned = codepar.replaceAll(RegExp(r'[^\d]'), '');
    print(cleaned);
    
    String searchCode = cleaned;
    double? scaleWeight;

    // Logic for Scale Barcode (EAN-13 starting with 2)
    if (cleaned.length == 13 && cleaned.startsWith('25')) {
      searchCode = cleaned.substring(0, 7); // Extract prefix + product code (7 digits)
      String weightPart = cleaned.substring(7, 12); // Extract weight
      scaleWeight = double.tryParse(weightPart) != null
          ? double.parse(weightPart) / 1000.0 // Assuming grams to kg
          : null;
      print("⚖️  Scale Item Detected - Base Code: $searchCode, Weight: $scaleWeight kg");
    }

    Map<String, Object?> data = {
      "codepar": searchCode,
    };

    print("==================$cleaned");

    var result = await saledata.searchpro(data);
    print("🔍 Search Response: $result");

    if (result.isNotEmpty) {
      Map<String, dynamic> productData;
      productData = Map<String, dynamic>.from(result.first);

      final uuid = productData['uuid'] ?? productData['id'] ?? '';
      final name = productData['product_name'] ?? '';
      final price = getSalePrice(productData);
      int typeItem = int.tryParse(productData['type'].toString()) ?? 1;

      bool isScaleBarcode = cleaned.length == 13 && cleaned.startsWith('25');
      if (isScaleBarcode) {
        typeItem = 2; // Force to weighted item if a scale barcode is detected
      }

      final existingIndex = selectedProducts.indexWhere(
        (item) => item['uuid'] == uuid,
      );

      if (typeItem == 2 && scaleWeight == null) {
        showWeightDialog(
          productData,
          existingIndex: existingIndex != -1 ? existingIndex : null,
        );
        return;
      }

      double addedQuantity = (typeItem == 2 && scaleWeight != null)
          ? scaleWeight
          : 1.0;

      if (existingIndex != -1) {
        double newQty =
            selectedProducts[existingIndex]['quantity'] + addedQuantity;
        double maxQty =
            double.tryParse(
              productData['product_quantity']?.toString() ?? '0',
            ) ??
            0.0;
        if (newQty <= maxQty || type == 1) {
          selectedProducts[existingIndex]['quantity'] = newQty;
          selectedProducts[existingIndex]['total'] =
              (type == 1
                  ? selectedProducts[existingIndex]['price_Purchase']
                  : selectedProducts[existingIndex]['price']) *
              selectedProducts[existingIndex]['quantity'];
          selectedProducts[existingIndex] = Map<String, dynamic>.from(
            selectedProducts[existingIndex],
          );
        } else {
          showSnackbar("خطأ".tr, "الكمية غير متوفرة".tr, Colors.red);
          statusrequest = Statusrequest.success;
          update();
          return;
        }
      } else {
        selectedProducts.add({
          "uuid": uuid,
          "name": name,
          "price": type == 1 ? 0.0 : price,
          "price_Purchase": type == 1
              ? price
              : double.tryParse(
                      productData['product_price_purchase'].toString(),
                    ) ??
                    0.0,
          "quantity": addedQuantity,
          "total": price * addedQuantity,
          "type_item": typeItem,
          "quantity_item": productData['product_quantity'],
          "product_price": productData['product_price'],
          "product_price_wholesale": productData['product_price_wholesale'],
          "product_price_half_wholesale":
              productData['product_price_half_wholesale'],
        });
      }

      _calculateTotals();
      statusrequest = Statusrequest.success;
    } else {
      showSnackbar("تنبيه".tr, "المنتج غير موجود".tr, Colors.orange);
      statusrequest = Statusrequest.failure;
      update();
    }
    update();
  }

  void addProductFromCatalog(Map<String, dynamic> productData) {
    final uuid = productData['uuid'] ?? productData['id'] ?? '';
    final name = productData['product_name'] ?? '';
    final price = getSalePrice(productData);
    final typeItem = productData['type'];

    final existingIndex = selectedProducts.indexWhere(
      (item) => item['uuid'] == uuid,
    );

    if (typeItem == 2) {
      showWeightDialog(
        productData,
        existingIndex: existingIndex != -1 ? existingIndex : null,
      );
      return;
    }

    if (existingIndex != -1) {
      double newQty = selectedProducts[existingIndex]['quantity'] + 1.0;
      double maxQty =
          double.tryParse(productData['product_quantity']?.toString() ?? '0') ??
          0.0;
      if (newQty <= maxQty || type == 1) {
        selectedProducts[existingIndex]['quantity'] = newQty;
        selectedProducts[existingIndex]['total'] =
            (type == 1
                ? selectedProducts[existingIndex]['price_Purchase']
                : selectedProducts[existingIndex]['price']) *
            selectedProducts[existingIndex]['quantity'];
        selectedProducts[existingIndex] = Map<String, dynamic>.from(
          selectedProducts[existingIndex],
        );
      } else {
        showSnackbar("خطأ".tr, "الكمية غير متوفرة".tr, Colors.red);
        statusrequest = Statusrequest.success;
        update();
        return;
      }
    } else {
      selectedProducts.add({
        "uuid": uuid,
        "name": name,
        "price": type == 1 ? 0.0 : price,
        "price_Purchase": type == 1
            ? price
            : double.tryParse(
                    productData['product_price_purchase'].toString(),
                  ) ??
                  0.0,
        "quantity": 1.0,
        "total": price * 1.0,
        "type_item": typeItem,
        "quantity_item": productData['product_quantity'],
        "product_price": productData['product_price'],
        "product_price_wholesale": productData['product_price_wholesale'],
        "product_price_half_wholesale":
            productData['product_price_half_wholesale'],
      });
    }

    _calculateTotals();
    statusrequest = Statusrequest.success;
    update();
  }

  void addNewProductDialogAndAssign() async {
    // We open the AddProductDialog, wrapped or directly
    // Since AddProductDialog is a widget, we need to import it where it's used.
    // SaleController shouldn't ideally know about UI, but we can return the data from dialog.
    // Actually, SaleController handles showing dialogs like showWeightDialog.
    // However, AddProductDialog is in lib/view/widget/stock/AddProductDialog.dart
    // Since we don't want cyclic imports, it's better to implement this in the UI (purchase_screen)
    // and pass the result to `addProductWithQuantity` if successful.
    // So let's create `addProductWithQuantity` instead.
  }

  void addProductWithQuantity(Map<String, dynamic> productData, double addedQuantity, {Map<String, dynamic>? draftPayload}) {
    final uuid = productData['uuid'] ?? productData['id'] ?? '';
    final name = productData['product_name'] ?? '';
    final price = getSalePrice(productData);
    final typeItem = productData['type'];

    final existingIndex = selectedProducts.indexWhere((item) => item['uuid'] == uuid);

    if (existingIndex != -1) {
      double newQty = selectedProducts[existingIndex]['quantity'] + addedQuantity;
      selectedProducts[existingIndex]['quantity'] = newQty;
      selectedProducts[existingIndex]['total'] =
          (type == 1 ? selectedProducts[existingIndex]['price_Purchase'] : selectedProducts[existingIndex]['price']) *
          selectedProducts[existingIndex]['quantity'];
      if (draftPayload != null) {
        selectedProducts[existingIndex]['draft_payload'] = draftPayload;
      }
      selectedProducts[existingIndex] = Map<String, dynamic>.from(selectedProducts[existingIndex]);
    } else {
      selectedProducts.add({
        "uuid": uuid,
        "name": name,
        "price": type == 1 ? 0.0 : price,
        "price_Purchase": type == 1
            ? price
            : double.tryParse(productData['product_price_purchase'].toString()) ?? 0.0,
        "quantity": addedQuantity,
        "total": price * addedQuantity,
        "type_item": typeItem,
        "quantity_item": productData['product_quantity'],
        "product_price": productData['product_price'],
        "product_price_wholesale": productData['product_price_wholesale'],
        "product_price_half_wholesale": productData['product_price_half_wholesale'],
        if (draftPayload != null) "draft_payload": draftPayload,
      });
    }

    _calculateTotals();
    statusrequest = Statusrequest.success;
    update();
  }

  void gotoaddproductNewSale() async {
    final result = await Get.toNamed(
      Approutes.addProductSale,
      arguments: {
        "selectedProducts": selectedProducts,
        "type": type,
        "sale_type": saleType.value,
      },
    );
    if (result != null && result is List) {
      final updatedList = List<Map<String, dynamic>>.from(result);

      selectedProducts.clear();

      selectedProducts.addAll(updatedList);

      _calculateTotals();
      update();
    }
  }

  Future<void> saveSale(
    double paymentAmount, {
    bool printInvoice = false,
  }) async {
    if (selectedCustomer.isEmpty ||
        selectedCustomer.value ==
            (type == 1 ? 'اختر مورد'.tr : 'اختر عميل'.tr)) {
      showSnackbar(
        "تنبيه".tr,
        type == 1 ? "يرجى اختيار مورد أولاً".tr : "يرجى اختيار العميل أولاً".tr,
        Colors.orange,
      );
      return;
    }

    if (selectedProducts.isEmpty) {
      showSnackbar(
        "تنبيه".tr,
        "لا توجد منتجات حالياً، أضف منتج أولاً.".tr,
        Colors.orange,
      );
      return;
    }

    final String uuidinvoice = const Uuid().v4();
    int? userId = Get.find<Myservices>().sharedPreferences?.getInt("id");

    Map<String, Object?> data = {
      "uuid": uuidinvoice,
      'Transaction_uuid': selectedUuid.value,
      "user_id": userId,
      "invoies_numper": DateTime.now().millisecondsSinceEpoch
          .toString()
          .substring(0, 10),
      "invoies_date": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "discount": discount.value.toString(),
      "invoies_payment_date": DateTime.now().toIso8601String(),
      "created_at": DateTime.now().toIso8601String(),
      "Payment_price": paymentAmount.toString(),
      "sale_type": saleType.value,
      "seller_id": userId,
    };

    List<Map<String, Object?>> dataSale = selectedProducts.map((item) {
      final unitPrice = type == 1 ? item["price_Purchase"] : item["price"];
      return {
        "uuid": const Uuid().v4(),
        "product_uuid": item["uuid"],
        "quantity": item["quantity"],
        "unit_price": unitPrice,
        "subtotal": (item["quantity"] * unitPrice),
        "invoie_uuid": uuidinvoice,
        "type_sales": (type == 1 ? 1 : 2),
        "user_id": userId,
        "seller_id": userId,
        "created_at": DateTime.now().toIso8601String(),
        "product_price_purchase": item["price_Purchase"],
        "product_name": item["name"],
      };
    }).toList();

    Saledata saledata = Saledata();
    ProdactData prodactData = ProdactData(Get.find<Crud>());
    
    // Save drafted products first
    for (var item in selectedProducts) {
      if (item.containsKey('draft_payload')) {
        var draft = item['draft_payload'] as Map<String, dynamic>;
        var draftData = draft['draft_data'] as Map<String, Object?>;
        var draftSale = draft['draft_data_sale'] as Map<String, Object?>;
        var file = draft['file'] as File?;
        
        bool success = await prodactData.addProduct(draftData, draftSale, file);
        if (!success) {
          showSnackbar("error".tr, "error_adding_product".tr + ": ${draftData['product_name']}", Colors.red);
          return;
        }
      }
    }

    var result = await saledata.addSale(data, dataSale);

    if (result["status"] == 1) {
      if (printInvoice) {
        await printThermalInvoiceUsb(data, dataSale, paymentAmount);
      }
      Get.back(); // close dialog
      resetData();
      try {
        Get.find<RefreshService>().fire();
      } catch (e) {
        print(e);
      }
    } else {
      showSnackbar("error".tr, "operation_failed".tr, Colors.red);
    }
  }

  Future<void> printThermalInvoiceUsb(
    Map<String, Object?> invoiceData,
    List<Map<String, Object?>> items,
    double paymentAmount,
  ) async {
    try {
      final doc = pw.Document();

      // Custom width: 80mm
      final format = PdfPageFormat.roll80;

      // Font
      var dataFont = await rootBundle.load(
        "assets/fonts/static/Cairo-Regular.ttf",
      );
      var cairoFont = pw.Font.ttf(dataFont);
      var dataFontBold = await rootBundle.load(
        "assets/fonts/static/Cairo-Bold.ttf",
      );
      var cairoFontBold = pw.Font.ttf(dataFontBold);

      // Logo
      pw.Widget? logoWidget;
      String? logoPath = Get.find<Myservices>().sharedPreferences?.getString(
        "logo_stor",
      );
      try {
        if (logoPath != null &&
            logoPath.isNotEmpty &&
            logoPath.startsWith('http')) {
          final netImage = await networkImage(logoPath);
          logoWidget = pw.Image(netImage, width: 80, height: 80);
        } else if (logoPath != null &&
            logoPath.isNotEmpty &&
            File(logoPath).existsSync()) {
          final imageBytes = File(logoPath).readAsBytesSync();
          logoWidget = pw.Image(
            pw.MemoryImage(imageBytes),
            width: 80,
            height: 80,
          );
        } else {
          final defaultLogo = await rootBundle.load(Appimageassets.test2);
          logoWidget = pw.Image(
            pw.MemoryImage(defaultLogo.buffer.asUint8List()),
            width: 80,
            height: 80,
          );
        }
      } catch (_) {
        final defaultLogo = await rootBundle.load(Appimageassets.test2);
        logoWidget = pw.Image(
          pw.MemoryImage(defaultLogo.buffer.asUint8List()),
          width: 80,
          height: 80,
        );
      }

      double totalAmt = 0;
      for (var item in items) {
        totalAmt += double.tryParse(item['subtotal'].toString()) ?? 0;
      }
      double disc = double.tryParse(invoiceData['discount'].toString()) ?? 0.0;
      double finalTotal = totalAmt - disc;

      doc.addPage(
        pw.Page(
          pageFormat: format,
          margin: const pw.EdgeInsets.only(
              top: 5 * PdfPageFormat.mm,
              bottom: 7 * PdfPageFormat.mm,
              left: 2 * PdfPageFormat.mm,
              right: 2 * PdfPageFormat.mm),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                if (logoWidget != null) logoWidget,
                pw.SizedBox(height: 5),
                pw.Text(
                  "فاتورة بيع",
                  style: pw.TextStyle(font: cairoFontBold, fontSize: 14),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.Divider(thickness: 1, borderStyle: pw.BorderStyle.dashed),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      invoiceData['invoies_date'].toString(),
                      style: pw.TextStyle(font: cairoFont, fontSize: 9),
                    ),
                    pw.Text(
                      "التاريخ:",
                      style: pw.TextStyle(font: cairoFont, fontSize: 9),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      invoiceData['invoies_numper'].toString(),
                      style: pw.TextStyle(font: cairoFont, fontSize: 9),
                    ),
                    pw.Text(
                      "رقم:",
                      style: pw.TextStyle(font: cairoFont, fontSize: 9),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      selectedCustomer.value,
                      style: pw.TextStyle(font: cairoFont, fontSize: 9),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.Text(
                      "العميل:",
                      style: pw.TextStyle(font: cairoFont, fontSize: 9),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Divider(thickness: 1, borderStyle: pw.BorderStyle.dashed),
                pw.SizedBox(height: 2),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          "المنتج",
                          style: pw.TextStyle(font: cairoFontBold, fontSize: 9),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          "كمية",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(font: cairoFontBold, fontSize: 9),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          "مجموع",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(font: cairoFontBold, fontSize: 9),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Divider(thickness: 1, borderStyle: pw.BorderStyle.dashed),
                ...items.map((item) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                              item['product_name'].toString(),
                              style: pw.TextStyle(font: cairoFont, fontSize: 8),
                              textDirection: pw.TextDirection.rtl,
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              item['quantity'].toString(),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(font: cairoFont, fontSize: 8),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              double.parse(
                                item['subtotal'].toString(),
                              ).toStringAsFixed(2),
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(font: cairoFont, fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                pw.SizedBox(height: 2),
                pw.Divider(thickness: 1, borderStyle: pw.BorderStyle.dashed),
                pw.SizedBox(height: 2),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      totalAmt.toStringAsFixed(2),
                      style: pw.TextStyle(font: cairoFontBold, fontSize: 10),
                    ),
                    pw.Text(
                      "المجموع:",
                      style: pw.TextStyle(font: cairoFontBold, fontSize: 10),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
                if (disc > 0)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        disc.toStringAsFixed(2),
                        style: pw.TextStyle(font: cairoFont, fontSize: 10),
                      ),
                      pw.Text(
                        "الخصم:",
                        style: pw.TextStyle(font: cairoFont, fontSize: 10),
                        textDirection: pw.TextDirection.rtl,
                      ),
                    ],
                  ),
                pw.Divider(thickness: 1, borderStyle: pw.BorderStyle.dashed),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      finalTotal.toStringAsFixed(2),
                      style: pw.TextStyle(font: cairoFontBold, fontSize: 12),
                    ),
                    pw.Text(
                      "الصافي:",
                      style: pw.TextStyle(font: cairoFontBold, fontSize: 12),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      paymentAmount.toStringAsFixed(2),
                      style: pw.TextStyle(font: cairoFont, fontSize: 10),
                    ),
                    pw.Text(
                      "المدفوع:",
                      style: pw.TextStyle(font: cairoFont, fontSize: 10),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      (paymentAmount - finalTotal).toStringAsFixed(2),
                      style: pw.TextStyle(font: cairoFont, fontSize: 10),
                    ),
                    pw.Text(
                      "المتبقي:",
                      style: pw.TextStyle(font: cairoFont, fontSize: 10),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "شكراً لزيارتكم",
                  style: pw.TextStyle(font: cairoFont, fontSize: 10),
                  textDirection: pw.TextDirection.rtl,
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 5),
              ],
            );
          },
        ),
      );

      // جلب جميع الطابعات المثبتة على الجهاز
      final printers = await Printing.listPrinters();
      Printer? selectedPrinter;

      // 1. البحث التلقائي عن طابعة كاشير (حرارية) من خلال اسمها
      for (var printer in printers) {
        final name = printer.name.toLowerCase();
        if (name.contains('pos') ||
            name.contains('receipt') ||
            name.contains('thermal') ||
            name.contains('80') ||
            name.contains('58') ||
            name.contains('xp') ||
            name.contains('esc')) {
          selectedPrinter = printer;
          break;
        }
      }

      if (selectedPrinter == null) {
        showSnackbar(
          "تنبيه",
          "لم يتم العثور على طابعة حرارية (POS/Receipt) متصلة بالجهاز.",
          Colors.orange,
        );
        return;
      }

      // 2. طباعة مباشرة بدون نوافذ أو أسئلة
      await Printing.directPrintPdf(
        printer: selectedPrinter,
        onLayout: (PdfPageFormat _) async => doc.save(),
      );
    } catch (e) {
      print("Error printing: $e");
      showSnackbar("خطأ", "فشلت الطباعة: $e", Colors.red);
    }
  }

  void resetData() {
    selectedCustomer.value = type == 1 ? 'اختر مورد'.tr : 'اختر عميل'.tr;
    selectedUuid.value = '';
    selectedName.value = '';
    selectedFamilyName.value = '';
    selectedProducts.clear();
    saleType.value = 1;
    isCashCustomer.value = type != 1; // Force supplier selection for type 1
    discount.value = 0.0;
    totalallPrice = 0.0;
    totalItems = 0;
    update();
  }

  void changeSaleTypeAndClear(int newType) {
    if (saleType.value == newType) return;

    if (selectedProducts.isNotEmpty) {
      dialogDelete(
        title: "تنبيه".tr,
        content: "تغيير نوع البيع سيؤدي إلى إفراغ القائمة. هل توافق؟".tr,
        confirmText: "نعم".tr,
        cancelText: "لا".tr,
        onConfirm: () {
          saleType.value = newType;
          selectedProducts.clear();
          _calculateTotals();
          update();
        },
      );
    } else {
      saleType.value = newType;
      update();
    }
  }

  @override
  void onInit() {
    resetData();
    selectedCustomer.value = type == 1 ? 'اختر مورد'.tr : 'اختر عميل'.tr;
    isCashCustomer.value = type != 1; // Ensure this is also applied after type is passed
    print("=========================${selectedCustomer.value}");
    final arge = Get.arguments;
    print("=========================${arge}");
    if (arge != null) {
      selectedName.value = arge["name"];
      selectedFamilyName.value = arge["famlyname"];
      selectedUuid.value = arge["uuid"];
      type = arge["type"];
      selectedCustomer.value =
          '${selectedName.value} ${selectedFamilyName.value}';
    }

    print("================================${selectedCustomer.value}");
    fetchCustomers();
    super.onInit();
  }
}
