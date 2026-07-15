import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/categoris/Addcatcontroller.dart';
import '../../../controller/categoris/Editcatcontroller.dart';
import '../../../controller/categoris/ShwocatController.dart';
import '../../../data/model/Categoris_Model.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../LinkApi.dart';
import '../../../core/functions/valiedinput.dart';
import '../CustemTextField.dart';

class AddCategoryDialog extends StatelessWidget {
  final bool isEdit;
  final Catdata? initialData;

  const AddCategoryDialog({super.key, this.isEdit = false, this.initialData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Siedbarcontroller>();

    Addcatcontroller? addController;
    Editcatcontroller? editController;

    if (isEdit) {
      editController = Get.put(Editcatcontroller());
      if (initialData != null) {
        // use Future.microtask or just call it directly since it doesn't call update() in initData
        editController?.initData(initialData!);
      }
    } else {
      addController = Get.put(Addcatcontroller());
    }

    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final titleColor = isDark ? AppColor.textDark : const Color(0xFF2D2D2D);
      final subtitleColor = isDark
          ? AppColor.textSecondary
          : const Color(0xFF8E92BC);
      final bgColor = isDark ? AppColor.surfaceDark : Colors.white;

      return Dialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 550,
          padding: const EdgeInsets.all(32),
          child: Form(
            key: isEdit ? editController!.formstate : addController!.formstate,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        isEdit
                            ? 'edit_category_dialog_title'.tr
                            : 'add_category_dialog_title'.tr,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close,
                          color: isDark ? Colors.white30 : Colors.black26,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Name Fields Row
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: _buildInputField(
                          controller: isEdit
                              ? editController!.nameController
                              : addController!.nameController,
                          label: 'cat_name_ar'.tr,
                          placeholder: 'cat_name_ar_placeholder'.tr,
                          isDark: isDark,
                          titleColor: titleColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // French Name
                      Expanded(
                        child: _buildInputField(
                          controller: isEdit
                              ? editController!.nameFrController
                              : addController!.nameFrController,
                          label: 'cat_name_fr'.tr,
                          placeholder: 'cat_name_fr_placeholder'.tr,
                          isDark: isDark,
                          titleColor: titleColor,
                          isRtl: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Photo Upload Section
                  Text(
                    'cat_image'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      if (isEdit) {
                        editController?.imageupload();
                      } else {
                        addController?.imageupload();
                      }
                    },
                    child: isEdit
                        ? GetBuilder<Editcatcontroller>(
                            init: editController,
                            builder: (ctrl) => _buildUploadBox(
                              isDark,
                              subtitleColor,
                              ctrl.file,
                              ctrl.imageUrl,
                            ),
                          )
                        : GetBuilder<Addcatcontroller>(
                            init: addController,
                            builder: (ctrl) => _buildUploadBox(
                              isDark,
                              subtitleColor,
                              ctrl.file,
                              null,
                            ),
                          ),
                  ),
                  // const SizedBox(height: 16),

                  // // Preview Box
                  // _buildPreviewSection(isDark, titleColor, subtitleColor),
                  const SizedBox(height: 32),

                  // Actions
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      _buildActionButton(
                        label: isEdit ? 'edit'.tr : 'save'.tr,
                        icon: Icons.save_rounded,
                        onPressed: () async {
                          if (isEdit) {
                            await editController!.Editcat();
                          } else {
                            await addController!.addcat();
                          }
                          Get.find<Shwocatcontroller>().getcat();
                        },
                        isPrimary: true,
                      ),
                      const SizedBox(width: 12),
                      _buildActionButton(
                        label: 'cancel'.tr,
                        icon: Icons.close_rounded,
                        onPressed: () => Get.back(),
                        isPrimary: false,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    required bool isDark,
    required Color titleColor,
    bool isRtl = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 8),
        CustemTextField(
          controller: controller,
          hint: placeholder,
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
          validator: (value) => validInput(value ?? "", 100, 1, "text"),
        ),
      ],
    );
  }

  Widget _buildUploadBox(
    bool isDark,
    Color subtitleColor,
    dynamic file,
    String? imageUrl,
  ) {
    Widget content;

    if (file != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Image.file(
          file,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
        ),
      );
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      ImageProvider imageProvider;
      if (imageUrl.startsWith('http')) {
        imageProvider = NetworkImage(imageUrl);
      } else if (imageUrl.contains(r':\') || imageUrl.contains(':/') || imageUrl.startsWith('/')) {
        imageProvider = FileImage(File(imageUrl));
      } else {
        imageProvider = NetworkImage("${Applink.image}/$imageUrl");
      }

      content = ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Image(
          image: imageProvider,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
        ),
      );
    } else {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.cloud_upload_outlined,
              color: Colors.blue,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'upload_image_hint'.tr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'upload_limit'.tr,
            style: TextStyle(fontSize: 12, color: subtitleColor),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark
              ? Colors.blue.withOpacity(0.2)
              : Colors.blue.withOpacity(0.1),
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: content,
    );
  }

  Widget _buildPreviewSection(
    bool isDark,
    Color titleColor,
    Color subtitleColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.03)
            : const Color(0xFFF3F6F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.image_outlined,
              color: Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'visual_preview'.tr,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'preview_desc'.tr,
                  style: TextStyle(fontSize: 11, color: subtitleColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
    bool isDark = false,
  }) {
    final bgColor = isPrimary
        ? AppColor.primaryPurple
        : (isDark ? Colors.white10 : const Color(0xFFF3F6F9));
    final textColor = isPrimary ? Colors.white : AppColor.primaryPurple;

    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: AppColor.primaryPurple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
