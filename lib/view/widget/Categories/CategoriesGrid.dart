import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/categoris/ShwocatController.dart';
import '../../../data/model/Categoris_Model.dart';
import '../../../LinkApi.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/class/handlingview.dart';
import './AddCategoryDialog.dart';
import '../../../core/functions/dialogDelete.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Siedbarcontroller>();
    Get.put(Shwocatcontroller());

    return Obx(() {
      final isDark = controller.isDarkMode.value;
      return GetBuilder<Shwocatcontroller>(
        builder: (catController) {
          return Handlingview(
            statusrequest: catController.statusrequest,
            widget: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 5;
                double screenWidth = constraints.maxWidth;

                if (screenWidth < 800) {
                  crossAxisCount = 3;
                } else if (screenWidth < 1100) {
                  crossAxisCount = 4;
                } else if (screenWidth < 1400) {
                  crossAxisCount = 4;
                }

                double aspectRatio = 0.9;
                if (crossAxisCount <= 2) aspectRatio = 1.1;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: aspectRatio,
                    ),
                    itemCount: catController.Categoris.length + 1,
                    itemBuilder: (context, index) {
                      if (index == catController.Categoris.length) {
                        return _buildAddCategoryCard(isDark);
                      }
                      return _buildCategoryCard(
                        isDark,
                        catController.Categoris[index],
                        catController,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      );
    });
  }

  Widget _buildCategoryCard(
    bool isDark,
    Catdata category,
    Shwocatcontroller catController,
  ) {
    String imagePath = category.categorisImage ?? '';
    String imageUrl =
        imagePath.startsWith('http') || imagePath.startsWith('/data')
        ? imagePath
        : '${Applink.image}storage/$imagePath';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image with overlay
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              image: DecorationImage(
                image:
                    (imagePath.startsWith('/data') ||
                        imagePath.startsWith('C:') ||
                        imagePath.startsWith('D:'))
                    ? FileImage(File(imagePath)) as ImageProvider
                    : imagePath.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : const AssetImage('assets/images/Logo.png')
                          as ImageProvider,
                fit: BoxFit.fill,
                onError: (exception, stackTrace) {},
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Text(
                category.categorisName ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Actions and Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.dialog(
                            AddCategoryDialog(
                              isEdit: true,
                              initialData: category,
                            ),
                          );
                        },
                        child: _buildActionButton(
                          'edit'.tr,
                          Icons.edit_outlined,
                          isDark ? Colors.white10 : const Color(0xFFF3F4F9),
                          const Color(0xFF034D82),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        dialogDelete(
                          title: 'delete'.tr + ' ' + 'categories'.tr,
                          content: 'delete_message'.tr,
                          onConfirm: () {
                            catController.deletecat(category.uuid ?? '');
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: _buildDeleteButton(isDark),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCategoryCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.dialog(const AddCategoryDialog(isEdit: false));
          },
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.primaryPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColor.primaryPurple,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'add_category_placeholder'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryPurple,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'add_category_desc'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColor.textSecondary
                      : const Color(0xFF8E92BC),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color bg,
    Color iconColor,
  ) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: TextDirection.rtl,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3D1F1F) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: Color(0xFFEF5350),
        size: 20,
      ),
    );
  }
}
