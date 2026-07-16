import 'package:silaaty_desktop/core/class/Statusrequest.dart';
import 'package:silaaty_desktop/core/constant/routes.dart';
import 'package:silaaty_desktop/core/services/Services.dart';
import 'package:silaaty_desktop/data/datasource/Remote/Categoris_data.dart';
import 'package:silaaty_desktop/data/datasource/Remote/Prodact/Prodact_data.dart';

import 'package:silaaty_desktop/data/model/Categoris_model.dart' hide Data;
// ignore: library_prefixes
import 'package:silaaty_desktop/data/model/Product_Model.dart' as Prodact;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:async';
import '../../core/functions/Snacpar.dart';
import '../../core/functions/dialogDelete.dart';
import '../../data/model/Product_Model.dart';

class Itemscontroller extends GetxController {
  int type = 0;
  int saleType = 1;
  CategorisData categorisData = CategorisData(Get.find());
  ProdactData prodactData = ProdactData(Get.find());
  Myservices myservices = Get.find();

  List<Catdata> categories = [];
  List<Prodact.Data> product = [];
  List<Prodact.Data> prodactSearch = [];

  TextEditingController searchController = TextEditingController();

  // Pagination
  int currentPage = 1;
  int itemsPerPage = 10;

  List<Prodact.Data> get filteredProducts {
    if (!isAvailableStock) {
      return product.where((e) => (double.tryParse(e.productQuantity?.toString() ?? '0') ?? 0) <= 0).toList();
    } else {
      return product.where((e) => (double.tryParse(e.productQuantity?.toString() ?? '0') ?? 0) > 0).toList();
    }
  }

  int get totalPages => (filteredProducts.isEmpty) ? 1 : (filteredProducts.length / itemsPerPage).ceil();

  List<Prodact.Data> get paginatedProducts {
    final startIndex = (currentPage - 1) * itemsPerPage;
    return filteredProducts.skip(startIndex).take(itemsPerPage).toList();
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
  Map<String, List<Data>> _cachedSearch = {};
  Map<String, List<Data>> _cachedProducts = {};
  bool isSearching = false;
  bool isAvailableStock = true;

  void setStockTab(bool isAvailable) {
    isAvailableStock = isAvailable;
    update();
  }

  final RxSet<String> selectedUuids = <String>{}.obs;

  final RxMap<String, num> quantities = <String, num>{}.obs;

  bool isSelected(String uuid) =>
      selectedUuids.contains(uuid) && getQuantity(uuid) > 0;

  num getQuantity(String uuid) => quantities[uuid] ?? 0;

  void toggleSelect(String uuid, num maxQuantity) {
    if (selectedUuids.contains(uuid) || (maxQuantity == 0 && type == 0)) {
      // showSnackbar("error".tr, "غير متوفر", Colors.red);
      selectedUuids.remove(uuid);
      quantities[uuid] = 0;
    } else {
      selectedUuids.add(uuid);
      quantities[uuid] = 1;
    }
    update();
  }

  void increment(String uuid, num maxQuantity, {num? val}) {
    final currentQty = getQuantity(uuid);
    if (currentQty < maxQuantity || type == 1) {
      quantities[uuid] = currentQty + (val ?? 1);
    }
    selectedUuids.add(uuid);
    update();
  }

  void decrement(String uuid) {
    final q = getQuantity(uuid);
    if (q <= 1) {
      quantities[uuid] = 0;
      selectedUuids.remove(uuid);
    } else {
      quantities[uuid] = q - 1;
    }
    update();
  }

  void clearSelection() {
    selectedUuids.clear();
    quantities.clear();
    update();
  }

  Statusrequest statusrequest = Statusrequest.none;
  Statusrequest statusrequestcat = Statusrequest.none;

  // late int catid;

  // ignore: non_constant_identifier_names
  Future<void> GotoIformationItem(String? uuid) async {
    final result = await Get.toNamed(
      Approutes.informationitem,
      arguments: {"uuid": uuid},
    );

    if (result == true) {
      print("======$selectedCategoryId");
      _cachedProducts.clear();
      await getProdactnotcat();
    }
  }

  List<Map> getSelectedProducts() {
    return selectedUuids
        .map((uuid) {
          final item = product.firstWhereOrNull((e) => e.uuid == uuid);
          if (item != null) {
            return {
              "uuid": item.uuid,
              "name": item.productName,
              "price": getSalePrice(item),
              "price_Purchase": item.productPricePurchase,
              "quantity": quantities[uuid] ?? 1,
              "quantity_item": item.productQuantity,
              "type_item": item.type,
              "product_price": item.productPrice,
              "product_price_wholesale": item.productPriceWholesale,
              "product_price_half_wholesale": item.productPriceHalfWholesale,
            };
          }
          return {};
        })
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Gotoback() {
    final selected = getSelectedProducts();
    print("==============================$selected");
    Get.back(result: selected);
  }

  double getSalePrice(Prodact.Data item) {
    if (type == 1) {
      return item.productPricePurchase?.toDouble() ?? 0.0;
    }

    double retailPrice = item.productPrice?.toDouble() ?? 0.0;

    if (saleType == 3) {
      double wholesalePrice = item.productPriceWholesale?.toDouble() ?? 0.0;
      return wholesalePrice > 0 ? wholesalePrice : retailPrice;
    } else if (saleType == 2) {
      double halfWholesalePrice = item.productPriceHalfWholesale?.toDouble() ?? 0.0;
      return halfWholesalePrice > 0 ? halfWholesalePrice : retailPrice;
    }

    return retailPrice;
  }

  getCategoris() async {
    try {
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

  getProdact(String? uuid) async {
    String cacheKey = "${uuid ?? 'default'}";
    if (_cachedProducts.containsKey(cacheKey)) {
      product = _cachedProducts[cacheKey]!;
      statusrequest = Statusrequest.success;
      update();
      return;
    }

    Map<String, Object?> data = {
      "Categoris_uuid": uuid,
    };

    var result = await prodactData.getCatProdactbytype(data);
    print("============================================== $result");

    if (result.isNotEmpty) {
      product =
          result.map((e) => Data.fromJson(e as Map<String, dynamic>)).toList();

      _cachedProducts[cacheKey] = product;

      statusrequest =
          product.isNotEmpty ? Statusrequest.success : Statusrequest.failure;
    } else {
      product = [];
      statusrequest = Statusrequest.failure;
    }

    currentPage = 1;
    update();
  }

  searchBarcode(String codepar) async {
    Get.back();
    await Future.delayed(const Duration(milliseconds: 200));
    update();

    String cleaned = codepar.replaceAll(RegExp(r'[^\d]'), '');

    // if (cleaned.length <= 9) {
    //   cleaned = cleaned.substring(1);
    // }
    print("====== CLEANED: $cleaned");

    Map<String, Object?> data = {
      "codepar": cleaned,
    };

    var result = await prodactData.searchpro(data);
    print("🔍 Search Response: $result");

    if (result.isNotEmpty) {
      final res = await Get.toNamed(
        Approutes.informationitem,
        arguments: {"uuid": result.first['uuid']},
      );

      if (res == true) {
        print("======$selectedCategoryId");
        _cachedProducts.clear();
        await getProdactnotcat();
      }
      statusrequest = Statusrequest.success;
    } else {
      showSnackbar("تنبيه".tr, "المنتج غير موجود".tr, Colors.orange);
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  Timer? _searchDebounce;

  search(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 100), () async {
      if (query.isEmpty) {
        isSearching = false;
        product = [];
        _cachedSearch.clear();
        selectedCategoryId.isNotEmpty
            ? getProdact(selectedCategoryId)
            : getProdactnotcat();
        return;
      }

      if (_cachedSearch.containsKey(query)) {
        product = _cachedSearch[query]!;
        isSearching = true;
        statusrequest = Statusrequest.success;
        update();
        return;
      }

      isSearching = true;
      prodactSearch.clear;
      update();

      Map<String, Object?> data = {
        "query": query,
        'Categoris_uuid': selectedCategoryId,
      };

      var result = await prodactData.search(data);
      print("🔍 Search Response: $result");

      if (result.isNotEmpty) {
        product =
            result.map((e) => Data.fromJson(e as Map<String, dynamic>)).toList();

        _cachedSearch[query] = product;

        statusrequest =
            product.isNotEmpty ? Statusrequest.success : Statusrequest.failure;
      } else {
        product = [];
        statusrequest = Statusrequest.failure;
      }

      currentPage = 1;
      update();
    });
  }

  getProdactnotcat() async {
    String cacheKey = "no_category";

    if (_cachedProducts.containsKey(cacheKey)) {
      print("=======================ok");
      product = _cachedProducts[cacheKey]!;
      statusrequest = Statusrequest.success;
      update();
      return;
    }
    update();
    Map<String, Object?> data = {};
    var result = await prodactData.getProdactnotcat(data);
    print("============================================== $result");
    if (result.isNotEmpty) {
      product =
          result.map((e) => Data.fromJson(e as Map<String, dynamic>)).toList();

      _cachedProducts[cacheKey] = product;

      statusrequest =
          product.isNotEmpty ? Statusrequest.success : Statusrequest.failure;
    } else {
      product = [];
      statusrequest = Statusrequest.failure;
    }

    currentPage = 1;
    update();
  }

  double get totalSaleValue {
    double total = 0;
    for (var item in product) {
      double price = item.productPrice?.toDouble() ?? 0.0;
      double qty = double.tryParse(item.productQuantity?.toString() ?? '0') ?? 0;
      total += price * qty;
    }
    return total;
  }

  double get totalPurchaseValue {
    double total = 0;
    for (var item in product) {
      double price = item.productPricePurchase?.toDouble() ?? 0.0;
      double qty = double.tryParse(item.productQuantity?.toString() ?? '0') ?? 0;
      total += price * qty;
    }
    return total;
  }

  int get totalProductsCount {
    return product.length;
  }

  int get lowStockCount {
    return product.where((e) {
      double qty = double.tryParse(e.productQuantity?.toString() ?? '0') ?? 0;
      return qty < 10;
    }).length;
  }

  @override
  void onInit() {
    selectedCategoryId = "";
    getCategoris();
    print("==========================================");
    getProdactnotcat();
    print(
        "==========================================Product=====================");
    final args = Get.arguments;
    if (args != null && args['selectedProducts'] != null) {
      final List<Map<String, dynamic>> selected =
          List<Map<String, dynamic>>.from(args['selectedProducts']);
      type = args["type"] ?? 0;
      saleType = args["sale_type"] ?? 1;
      print("=============================type$type, saleType$saleType");
      for (var p in selected) {
        final uuid = p['uuid'];
        final qty = p['quantity'] ?? 1;
        selectedUuids.add(uuid);
        quantities[uuid] = qty is int ? qty : (qty as num);
      }
    }
    super.onInit();
  }

  String selectedCategoryId = "";

  selectCategory(String uuid) {
    selectedCategoryId = uuid;
    if (uuid.isEmpty) {
      getProdactnotcat();
    } else {
      getProdact(uuid);
    }
    update();
  }

  refreshData() async {
    selectedCategoryId = "";
    await getCategoris();
    await getProdactnotcat();
  }

  Future<void> GotoAddaitems(int? id) async {
    final result =
        await Get.toNamed(Approutes.Additem, arguments: {"catid": id});
    if (result == true) {
      await refreshProductsList();
    }
  }

  Future<void> refreshProductsList() async {
    _cachedProducts.clear();
    if (selectedCategoryId.isNotEmpty) {
      await getProdact(selectedCategoryId);
    } else {
      await getProdactnotcat();
    }
  }

  Future<void> addQuantity(Prodact.Data item, double addedQty) async {
    if (addedQty <= 0) return;
    double currentQty = double.tryParse(item.productQuantity?.toString() ?? '0') ?? 0;
    double newQty = currentQty + addedQty;
    
    Map<String, Object?> data = item.toJson();
    data["product_quantity"] = newQty;
    data["updated_at"] = DateTime.now().toIso8601String();
    
    // Create new sale row for added stock
    final String saleUuid = DateTime.now().millisecondsSinceEpoch.toString(); // basic uuid fallback
    final double unitPrice = item.productPricePurchase?.toDouble() ?? 0;
    
    Map<String, Object?> sale = {
      "uuid": saleUuid,
      "product_uuid": item.uuid,
      "product_name": item.productName,
      "quantity": addedQty,
      "unit_price": unitPrice,
      "product_price_purchase": unitPrice,
      "subtotal": addedQty * unitPrice,
      "type_sales": 3,
      "user_id": myservices.sharedPreferences?.getInt("id"),
      "created_at": DateTime.now().toIso8601String(),
      "updated_at": DateTime.now().toIso8601String(),
    };
    
    bool result = await prodactData.updateQuantityProduct(data, sale);
    if (result) {
      showSnackbar("success".tr, "تم تحديث الكمية بنجاح".tr, Colors.green);
      await refreshProductsList();
    } else {
      showSnackbar("error".tr, "فشل تحديث الكمية".tr, Colors.red);
    }
  }


  Future<void> deleteProduct(Prodact.Data item) async {
    dialogDelete(
      title: 'confirm_deletion'.tr,
      content: 'confirm_delete_product_msg'.tr,
      confirmText: 'yes'.tr,
      cancelText: 'cancel'.tr,
      onConfirm: () async {
        Map<String, Object?> data = {"uuid": item.uuid};
        bool success = await prodactData.deleteProdact(data);
        if (success) {
          showSnackbar('success'.tr, 'product_deleted_success'.tr, Colors.green);
          await refreshProductsList();
        } else {
          showSnackbar('error'.tr, 'product_delete_failed'.tr, Colors.red);
        }
      },
    );
  }
}
