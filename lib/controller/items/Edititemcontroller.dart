import 'dart:io';
import 'package:silaaty_desktop/core/functions/uploudfiler.dart';
import 'package:silaaty_desktop/data/datasource/Remote/Prodact/Prodact_data.dart';
import 'package:silaaty_desktop/data/model/Product_Model.dart' as Prodact;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import 'package:silaaty_desktop/core/class/Statusrequest.dart';
import 'package:silaaty_desktop/core/services/Services.dart';
import 'package:silaaty_desktop/data/datasource/Remote/Categoris_data.dart';
import 'package:silaaty_desktop/data/model/Categoris_model.dart';

import '../../core/constant/Colorapp.dart';
import '../../core/functions/Snacpar.dart';

class Edititemcontroller extends GetxController {
  File? file;
  String? imageUrl;
  int? barcodeMode; // 0: Auto, 1: Manual, 2: Scan
  int? selectedCategoryId = 1;
  String? oldquantity;
  String? selectedCategory;
  String? selectedtypeuuId;
  String? selectedtype;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priseController = TextEditingController();
  final priseHalfWholesaleController = TextEditingController();
  final priseWholesaleController = TextEditingController();
  final barcodeController = TextEditingController();
  final pricePurchaseController = TextEditingController();
  final quantityController = TextEditingController();

  double priceTotal = 0.0;
  double priceTotalPurchase = 0.0;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  CategorisData categorisData = CategorisData(Get.find());
  ProdactData prodactData = ProdactData(Get.find());

  // Myservices myServices = Get.find();
  List<Catdata> categories = [];
  Statusrequest statusrequest = Statusrequest.none;
  String? uuid;
  int? type;

  Myservices myservices = Get.find();
  late int? id = myservices.sharedPreferences?.getInt("id");

  void toggleBarcodeMode(int mode, BuildContext context) {
    barcodeMode = mode;
    if (mode == 2) {
      scanBarcode(context);
    }
    update();
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

  EditProduct() async {
    if (!formstate.currentState!.validate()) return;

    final newQty = double.tryParse(quantityController.text) ?? 0;
    final oldQty = double.tryParse(oldquantity!) ?? 0.0;

    if (newQty < 0) {
      showSnackbar("error".tr, "كمية غير صالحة".tr, Colors.red);
      return;
    }

    final data = {
      "uuid": uuid,
      'product_name': nameController.text,
      'product_description': descriptionController.text,
      'product_quantity': newQty,
      'product_price': priseController.text,
      'product_price_half_wholesale': (priseHalfWholesaleController.text.isNotEmpty ? priseHalfWholesaleController.text : "0"),
      'product_price_wholesale': (priseWholesaleController.text.isNotEmpty ? priseWholesaleController.text : "0"),
      'categorie_id': 1,
      'categoris_uuid': selectedtypeuuId,
      'product_price_total': priceTotal.toString(),
      'product_price_total_purchase': priceTotalPurchase.toString(),
      'product_price_purchase': pricePurchaseController.text,
      "codepar": barcodeController.text,
      'type': type,
    };

    final result = await prodactData.updateProduct(data, oldQty, newQty, file);
    if (result) {
      Get.find<RefreshService>().fire();
      Get.back(result: true);
    } else {
      showSnackbar("error".tr, "error_updating_product".tr, Colors.red);
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCategoris();
    });
    super.onInit();
    quantityController.addListener(calculateTotalPrice);
    priseController.addListener(calculateTotalPrice);
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

  String _formatNum(dynamic value) {
    if (value == null) return "0";
    double? d = double.tryParse(value.toString());
    if (d == null) return value.toString();
    if (d == d.toInt()) return d.toInt().toString();
    return d.toString();
  }

  void initData(Prodact.Data product) {
    nameController.text = product.productName ?? "";
    descriptionController.text = product.productDescription ?? "";
    priseController.text = _formatNum(product.productPrice);
    priseHalfWholesaleController.text = _formatNum(
      product.productPriceHalfWholesale,
    );
    priseWholesaleController.text = _formatNum(product.productPriceWholesale);
    pricePurchaseController.text = _formatNum(product.productPricePurchase);
    barcodeController.text = product.codepar?.toString() ?? "";
    quantityController.text = _formatNum(product.productQuantity);
    selectedtypeuuId = product.categorisuuId;
    uuid = product.uuid;
    imageUrl = product.productImage ?? "";
    oldquantity = product.productQuantity ?? "0";
    type = product.type ?? 1;

    print("============================$selectedtypeuuId");
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

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priseController.dispose();
    priseHalfWholesaleController.dispose();
    priseWholesaleController.dispose();
    quantityController.dispose();
    super.onClose();
  }
}
