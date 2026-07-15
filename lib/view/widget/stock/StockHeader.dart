import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/items/ItemsController.dart';
import '../../../core/constant/Colorapp.dart';

class StockHeader extends StatelessWidget {
  const StockHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Siedbarcontroller>();
    
    return GetBuilder<Itemscontroller>(
      builder: (stockController) {
        return Obx(() {
          final isDark = controller.isDarkMode.value;
          final titleColor = isDark ? AppColor.textDark : const Color(0xFF2D2D2D);
          final subtitleColor =
              isDark ? AppColor.textSecondary : const Color(0xFF8E92BC);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.rtl,
              children: [
                // Right: Title and Subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'stock_management'.tr,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: titleColor,
                      ),
                    ),
                    Text(
                      'stock_subtitle'.tr,
                      style: TextStyle(
                        fontSize: 15,
                        color: subtitleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Left: Available/Out Stock and Categories
                Row(
                  children: [
                    _buildCategoryDropdown(isDark, titleColor, stockController),
                    const SizedBox(width: 16),
                    _buildTabButton(
                      'out_of_stock'.tr,
                      !stockController.isAvailableStock,
                      isDark,
                      onTap: () => stockController.setStockTab(false),
                    ),
                    const SizedBox(width: 8),
                    _buildTabButton(
                      'available_stock'.tr,
                      stockController.isAvailableStock,
                      isDark,
                      onTap: () => stockController.setStockTab(true),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      }
    );
  }

  Widget _buildTabButton(String label, bool isActive, bool isDark,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive
              ? (isDark ? Colors.white : Colors.white)
              : (isDark
                  ? Colors.white.withOpacity(0.05)
                  : const Color(0xFFF7F8FA)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? AppColor.primaryPurple
                : (isDark ? Colors.white30 : Colors.grey.shade600),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(
      bool isDark, Color textColor, Itemscontroller stockController) {
    
    // Add an "All categories" option at the beginning
    final items = [
      DropdownMenuItem<String>(
        value: "",
        child: Text(
          'all_categories'.tr, 
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColor.black,
            fontFamily: 'Cairo',
            fontSize: 14,
          ),
        ),
      ),
      ...stockController.categories.map((cat) => DropdownMenuItem<String>(
            value: cat.uuid ?? "",
            child: Text(
              cat.categorisName ?? "", 
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColor.black,
                fontFamily: 'Cairo',
                fontSize: 14,
              ),
            ),
          ))
    ];

    String selectedValue = stockController.selectedCategoryId;
    if (!items.any((item) => item.value == selectedValue)) {
      selectedValue = "";
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        value: selectedValue,
        items: items,
        onChanged: (String? newValue) {
          if (newValue != null) {
            stockController.selectCategory(newValue);
          }
        },
        buttonStyleData: ButtonStyleData(
          height: 48,
          width: 220,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColor.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
            ),
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark ? Colors.white70 : Colors.grey,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 250,
          width: 220,
          direction: DropdownDirection.right,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark ? AppColor.surfaceDark : Colors.white,
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
            ),
          ),
          offset: const Offset(0, -6),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
