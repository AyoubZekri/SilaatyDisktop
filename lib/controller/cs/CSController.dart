import 'package:get/get.dart';

class CSController extends GetxController {
  RxInt activeTab = 0.obs; // 0 for Customers, 1 for Suppliers
  RxInt currentPage = 1.obs;
  RxInt totalItems = 1248.obs;
  RxString searchQuery = ''.obs;

  void changeTab(int index) {
    activeTab.value = index;
    // Reset data or fetch new list based on tab
  }

  void onSearch(String query) {
    searchQuery.value = query;
  }
}
