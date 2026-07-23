import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/Services.dart';
import '../../core/functions/clear_page_controllers.dart';
import '../../core/constant/routes.dart';

import '../../view/screen/Categories.dart';
import '../../view/screen/Home.dart';
import '../../view/screen/sale/sale.dart';
import '../../view/screen/sale/purchase_screen.dart';
import '../../view/screen/stock.dart';
import '../../view/screen/C&S/customers_screen.dart';
import '../../view/screen/C&S/suppliers_screen.dart';

import '../../view/screen/sale/InvoiceList.dart';
import '../../view/screen/Statistic/Statistic.dart';
import '../../view/screen/Statistic/PublicFinance.dart';
import '../../view/screen/BranchManagement.dart';
import '../../view/screen/Settings/Notifications.dart';

class Siedbarcontroller extends GetxController {
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController confirmPassword;

  bool issobscureText = true;
  bool issobscureText2 = true;
  RxInt currentPage = 0.obs;
  RxnInt expandedIndex = RxnInt();
  RxnInt currentSubIndex = RxnInt();
  Rx<Widget Function()?> currentSubPage = Rx<Widget Function()?>(null);
  Myservices myservices = Get.find();

  RxString name = "".obs;
  RxString emailofuser = "".obs;
  RxString hallname = "".obs;
  RxnString imagePath = RxnString();
  RxnInt status = RxnInt();
  RxnString dateExperiment = RxnString();

  RxBool isDarkMode = false.obs;
  RxBool isSidebarExpanded = true.obs;

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    myservices.sharedPreferences!.setBool("isDarkMode", isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    update();
  }

  void toggleSidebarSize() {
    isSidebarExpanded.value = !isSidebarExpanded.value;
    myservices.sharedPreferences!.setBool("isSidebarExpanded", isSidebarExpanded.value);
    update();
  }

  final List<Map<String, dynamic>> screens = [
    {
      'name': 'dashboard',
      'icon': Icons.grid_view_rounded,
      'page': () => const Home(),
      'subPages': [],
    },
    {
      'name': 'categories',
      'icon': Icons.category_outlined,
      'page': () => const Categories(),
      'subPages': [],
    },
    {
      'name': 'inventory',
      'icon': Icons.inventory_2_outlined,
      'page': () => const StockScreen(),
      'subPages': [],
    },
    {
      'name': 'customers',
      'icon': Icons.people_outline,
      'page': () => const CustomersScreen(),
      'subPages': [],
    },
    {
      'name': 'suppliers',
      'icon': Icons.local_shipping_outlined,
      'page': () => const SuppliersScreen(),
      'subPages': [],
    },
    {
      'name': 'sale',
      'icon': Icons.point_of_sale_rounded,
      'page': () => const SaleScreen(),
      'subPages': [],
    },
    {
      'name': 'purchase',
      'icon': Icons.shopping_cart_checkout_rounded,
      'page': () => const PurchaseScreen(),
      'subPages': [],
    },
    {
      'name': 'branches',
      'icon': Icons.store_rounded,
      'page': () => const BranchManagement(),
      'subPages': [],
    },
    {
      'name': 'invoice_history',
      'icon': Icons.receipt_long_rounded,
      'page': () => const InvoiceList(),
      'subPages': [],
    },
    {
      'name': 'reports',
      'icon': Icons.bar_chart_rounded,
      'page': () => const StatisticScreen(),
      'subPages': [],
    },
    // {
    //   'name': 'settings',
    //   'icon': Icons.settings_outlined,
    //   'page': null,
    //   'subPages': [
    //     {
    //       'name': 'notifications',
    //       'icon': Icons.notifications_none_outlined,
    //       'page': () => const NotificationsScreen(),
    //     },
    //   ],
    // },
  ];
  void changePage(int index) {
    if (currentPage.value != index) {
      clearPageControllers();
    }
    currentPage.value = index;
    currentSubIndex.value = null;
    currentSubPage.value = null;
    update();
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? null : index;
    update();
  }

  void changeSubPage(int subIndex, Widget Function() page) {
    currentSubIndex.value = subIndex;
    currentSubPage.value = page;
    update();
  }

  void showPassword() {
    issobscureText = issobscureText == true ? false : true;
    update();
  }

  void showPassword2() {
    issobscureText2 = issobscureText2 == true ? false : true;
    update();
  }

  void logout() {
    myservices.sharedPreferences?.clear();
    Get.offAllNamed(Approutes.Login);
    update();
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
    
    bool? savedSidebarState = myservices.sharedPreferences!.getBool("isSidebarExpanded");
    if (savedSidebarState != null) {
      isSidebarExpanded.value = savedSidebarState;
    }
    
    name.value = myservices.sharedPreferences!.getString("name") ?? "";
    emailofuser.value = myservices.sharedPreferences!.getString("email") ?? "";
    hallname.value = myservices.sharedPreferences!.getString("adresse") ?? "";
    imagePath.value = myservices.sharedPreferences!.getString("logo_stor");
    status.value = myservices.sharedPreferences!.getInt("Status");
    dateExperiment.value = myservices.sharedPreferences!.getString("date_experiment");

    super.onInit();
  }
}
