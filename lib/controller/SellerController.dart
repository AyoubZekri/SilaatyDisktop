import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silaaty_desktop/core/class/Statusrequest.dart';
import 'package:silaaty_desktop/core/functions/Snacpar.dart';
import 'package:silaaty_desktop/data/datasource/Remote/SellerData.dart';

import '../core/class/Crud.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';

class SellerController extends GetxController {
  SellerData sellerData = SellerData(Get.find<Crud>());
  Myservices myServices = Get.find();
  Statusrequest statusrequest = Statusrequest.none;

  List sellers = [];
  List filteredSellers = [];

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController searchController;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isPasswordHidden = true;

  showPassword() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  @override
  void onInit() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    searchController = TextEditingController();
    getSellers();
    super.onInit();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    searchController.dispose();
    super.dispose();
  }

  getSellers() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await sellerData.getSellers();
    statusrequest = handlingData(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 1) {
        sellers = response['data']['sellers'] ?? [];
        filteredSellers = sellers;
      } else {
        sellers = [];
        filteredSellers = [];
      }
    }
    update();
  }

  addSeller() async {
    if (!formState.currentState!.validate()) return;

    int maxSellers = myServices.sharedPreferences!.getInt("max_sellers") ?? 0;
    if (sellers.length >= maxSellers) {
      showSnackbar("تنبيه".tr, "عذراً، لقد وصلت للحد الأقصى لعدد البائعين المسموح به".tr, Colors.orange);
      return;
    }

    statusrequest = Statusrequest.loadeng;
    update();

    var response = await sellerData.addSeller(
      nameController.text,
      emailController.text,
      passwordController.text,
    );

    statusrequest = handlingData(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 1) {
        Get.back();
        getSellers();
        nameController.clear();
        emailController.clear();
        passwordController.clear();
      } else {
        statusrequest = Statusrequest.failure;
        showSnackbar("خطأ".tr, "لم يتم إضافة البائع".tr, Colors.red);
      }
    }
    update();
  }

  updateSeller(int id) async {
    if (!formState.currentState!.validate()) return;

    statusrequest = Statusrequest.loadeng;
    update();

    var response = await sellerData.updateSeller(
      id,
      nameController.text,
      emailController.text,
      passwordController.text,
    );

    statusrequest = handlingData(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 1) {
        Get.back();
        getSellers();
      } else {
        statusrequest = Statusrequest.failure;
        showSnackbar("خطأ".tr, "لم يتم التعديل".tr, Colors.red);
      }
    }
    update();
  }

  deleteSeller(int id) async {
    statusrequest = Statusrequest.loadeng;
    update();

    var response = await sellerData.deleteSeller(id);

    statusrequest = handlingData(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 1) {
        getSellers();
      } else {
        statusrequest = Statusrequest.failure;
        showSnackbar("خطأ".tr, "لم يتم حذف البائع".tr, Colors.red);
      }
    }
    update();
  }

  void openAddDialog() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    // Usually triggered in UI, but controller handles state reset
  }

  void openEditDialog(Map seller) {
    nameController.text = seller['name'];
    emailController.text = seller['email'];
    passwordController.clear(); // Ensure password is clear for edit
  }

  void searchSellers(String query) {
    if (query.isEmpty) {
      filteredSellers = sellers;
    } else {
      filteredSellers = sellers.where((seller) {
        final name = seller['name']?.toString().toLowerCase() ?? '';
        final email = seller['email']?.toString().toLowerCase() ?? '';
        final search = query.toLowerCase();
        return name.contains(search) || email.contains(search);
      }).toList();
    }
    update();
  }
}
