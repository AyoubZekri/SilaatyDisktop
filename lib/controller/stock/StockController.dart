import 'package:get/get.dart';

class StockController extends GetxController {
  // Observable state for filters
  RxString selectedCategory = 'all_categories'.obs;
  RxBool isAvailableStock = true.obs; // true: Available, false: Out of stock
  RxInt currentPage = 1.obs;
  RxString searchQuery = "".obs;

  void changeCategory(String category) {
    selectedCategory.value = category;
    update();
  }

  // Toggle between Available/Out of Stock
  void setStockTab(bool isAvailable) {
    isAvailableStock.value = isAvailable;
    update();
  }

  // Change pagination page
  void setPage(int page) {
    currentPage.value = page;
    update();
  }

  // Handle search
  void onSearch(String query) {
    searchQuery.value = query;
    update();
  }

  // Categories list (Mock)
  final List<String> categories = [
    'all_categories',
    'electronics',
    'fashion',
    'furniture',
  ];
}
