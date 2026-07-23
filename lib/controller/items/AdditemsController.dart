import 'dart:io';
import 'dart:math';
import 'package:silaaty_desktop/core/class/Statusrequest.dart';
import 'package:silaaty_desktop/data/datasource/Remote/Categoris_data.dart';
import 'package:silaaty_desktop/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:silaaty_desktop/data/model/Categoris_model.dart';
import 'package:get/get.dart';
import 'package:silaaty_desktop/core/functions/uploudfiler.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uuid/uuid.dart';

import '../../core/constant/Colorapp.dart';
import '../../core/functions/Snacpar.dart';
import '../../core/services/Services.dart';
import 'ItemsController.dart';

class Additemscontroller extends GetxController {
  File? file;
  int? barcodeMode; // 0: Auto, 1: Manual, 2: Scan
  int? selectedCategoryId = 1;
  String? selectedCategory;
  String? selectedtypeuuid;
  String? selectedtype;
  int type = 1;

  final nameController = TextEditingController();
  final barcodeController = TextEditingController();
  final descriptionController = TextEditingController();
  final priseController = TextEditingController();
  final priseHalfWholesaleController = TextEditingController();
  final priseWholesaleController = TextEditingController();
  final pricePurchaseController = TextEditingController();
  final quantityController = TextEditingController();

  double priceTotal = 0.0;
  double priceTotalPurchase = 0.0;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  CategorisData categorisData = CategorisData(Get.find());
  ProdactData prodactData = ProdactData(Get.find());
  int? id = Get.find<Myservices>().sharedPreferences?.getInt("id");

  // Myservices myServices = Get.find();
  List<Catdata> categories = [];
  Statusrequest statusrequest = Statusrequest.none;

  void toggleBarcodeMode(int mode, BuildContext context) {
    barcodeMode = mode;
    if (mode == 0) {
      barcodeController.text = generateBarcode();
    } else if (mode == 1) {
      barcodeController.clear();
    } else if (mode == 2) {
      barcodeController.clear();
      scanBarcode(context);
    }
    update();
  }

  bool isDraftMode = false;

  void typeProduct(int types) {
    type = types;
    if (type == 2) {
      if (barcodeMode == 0) {
        barcodeController.text = generateBarcode();
      } else if (barcodeController.text.length != 5) {
        barcodeController.text = '';
      }
    }
    update();
  }

  String generateBarcode() {
    final random = Random();
    if (type == 2) {
      return List.generate(5, (_) => random.nextInt(10)).join();
    }
    return '1' + List.generate(10, (_) => random.nextInt(10)).join();
  }

  addProduct() async {
    if (formstate.currentState!.validate()) {
      if (type == 2
          ? double.parse(quantityController.text) < 0
          : int.parse(quantityController.text) < 0) {
        showSnackbar(
          "error".tr,
          "لا يمكن أن تكون الكمية أقل من 1".tr,
          Colors.red,
        );
        return;
      }

      if (type == 2 && barcodeController.text.length != 5) {
        showSnackbar("error".tr, "يجب أن يتكون باركود الميزان من 5 أرقام", Colors.red);
        return;
      }

      final String newProductUuid = Uuid().v4();
      
      Map<String, Object?> data = {
        "uuid": newProductUuid,
        "user_id": id,
        'product_name': nameController.text,
        'product_description': descriptionController.text,
        'product_quantity': quantityController.text,
        'product_price': priseController.text,
        'product_price_half_wholesale':
            (priseHalfWholesaleController.text.isNotEmpty
            ? priseHalfWholesaleController.text
            : "0"),
        'product_price_wholesale': (priseWholesaleController.text.isNotEmpty
            ? priseWholesaleController.text
            : "0"),
        'categorie_id': selectedCategoryId.toString(),
        'categoris_uuid': selectedtypeuuid,
        'product_price_total': priceTotal.toString(),
        'product_price_total_purchase': priceTotalPurchase.toString(),
        'product_price_purchase': pricePurchaseController.text,
        'type': type,
        'codepar': (type == 2 && !barcodeController.text.startsWith('25')) ? '25' + barcodeController.text : barcodeController.text,
        "created_at": DateTime.now().toIso8601String(),
      };

      Map<String, Object?> dataSale = {
        "uuid": Uuid().v4(),
        "quantity": quantityController.text,
        "unit_price": pricePurchaseController.text,
        "subtotal":
            (double.tryParse(quantityController.text) ?? 0.0) *
            (double.tryParse(pricePurchaseController.text) ?? 0.0),
        "type_sales": 3, // 1 = in 2 = out 3
        "user_id": id,
        "created_at": DateTime.now().toIso8601String(),
        "product_name": data["product_name"],
        "product_price_purchase": data["product_price_purchase"],
      };

      try {
        print("========================$selectedtypeuuid");

        if (isDraftMode) {
          final draftPayload = {
            'draft_data': data,
            'draft_data_sale': dataSale,
            'file': file,
          };
          Get.back(result: draftPayload);
          return;
        }

        /// ندخل المنتج في SQLite مع الصورة + uuid + sync_queue
        final result = await prodactData.addProduct(data, dataSale, file);

        if (result == true) {
          Get.find<RefreshService>().fire();

          Get.back(result: data);
          Future.delayed(Duration(milliseconds: 300), () {
            if (selectedCategoryId == 1) {
              Get.back(result: data);
            }
            if (Get.isRegistered<Itemscontroller>()) {
              Get.find<Itemscontroller>().refreshProductsList();
            }
          });
        } else {
          showSnackbar("error".tr, "error_adding_product".tr, Colors.red);
          statusrequest = Statusrequest.failure;
        }
      } catch (e) {
        showSnackbar("error".tr, "db_error".tr, Colors.red);
        print("DB Error: $e");
        statusrequest = Statusrequest.failure;
      }
    }
  }

  getCategoris() async {
    try {
      update();

      var response = await categorisData.viewdata();

      print("============================================== $response");

      if (response.isNotEmpty) {
        categories = (response as List)
            .map((e) => Catdata.fromJson(e as Map<String, dynamic>))
            .toList();
        statusrequest = Statusrequest.success;
      } else {
        statusrequest = Statusrequest.failure;
      }
    } catch (e) {
      print("❌ getcat error: $e");
      statusrequest = Statusrequest.serverfailure;
    }

    update();
  }

  @override
  void onInit() {
    getCategoris();
    if (Get.arguments != null) {
      final args = Get.arguments as Map<String, dynamic>;
      selectedCategoryId = args["catid"];
    }
    super.onInit();
    quantityController.addListener(calculateTotalPrice);
    priseController.addListener(calculateTotalPrice);
    pricePurchaseController.addListener(calculateTotalPrice);
  }

  void calculateTotalPrice() {
    final quantity = type == 2
        ? double.tryParse(quantityController.text) ?? 0.0
        : int.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(priseController.text) ?? 0.0;
    final pricePurchase = double.tryParse(pricePurchaseController.text) ?? 0.0;

    priceTotal = quantity * price;
    priceTotalPurchase = quantity * pricePurchase;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  void onQuantityChanged(num value) {
    calculateTotalPrice();
  }

  void imageupload() {
    uploadimagefile();
  }

  Future<void> uploadimagefile() async {
    file = await fileuploadGallery(false);
    update();
  }

  bool _isScanning = false;
  void scanBarcode(BuildContext context) {
    if (_isScanning) return;
    _isScanning = true;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          height: 400,
          child: Column(
            children: [
              AppBar(
                title: Text(
                  "امسح الباركود".tr,
                  style: const TextStyle(color: AppColor.backgroundcolor),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: AppColor.primarycolor,
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColor.backgroundcolor,
                    ),
                    onPressed: () {
                      _isScanning = false;
                      Get.back();
                    },
                  ),
                ],
              ),
              Expanded(
                child: MobileScanner(
                  onDetect: (capture) {
                    final barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty && _isScanning) {
                      final scannedCode = barcodes.first.rawValue;
                      if (scannedCode != null) {
                        _isScanning = false;
                        barcodeController.text = scannedCode;
                        update();
                        if (Get.isDialogOpen!) {
                          Get.back();
                        }
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      _isScanning = false;
    });
  }

  void resetForm() {
    nameController.clear();
    priseController.clear();
    priseHalfWholesaleController.clear();
    priseWholesaleController.clear();
    pricePurchaseController.clear();
    quantityController.text = "1";
    getCategoris();
    selectedtypeuuid = null;
    file = null;

    priceTotal = 0.0;
    priceTotalPurchase = 0.0;

    update();
  }
}
