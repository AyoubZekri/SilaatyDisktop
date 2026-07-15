import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/class/Statusrequest.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/Profaile/transaction/Addtransactioncontroller.dart';
import '../../../controller/Profaile/transaction/Edittransactioncontroller.dart';
import '../../../controller/Profaile/transaction/transactionController.dart';
import '../../../core/functions/valiedinput.dart';
import '../CustemTextField.dart';

class AddCSDialog extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? data;

  const AddCSDialog({super.key, this.isEdit = false, this.data});

  @override
  State<AddCSDialog> createState() => _AddCSDialogState();
}

class _AddCSDialogState extends State<AddCSDialog> {
  AddTransactionController? addCtrl;
  EditTransactionController? editCtrl;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      editCtrl = Get.put(EditTransactionController());
      editCtrl!.uuid = widget.data?['uuid'];
      editCtrl!.type = widget.data?['type'] ?? 2;
      editCtrl!.nameController.text = widget.data?['name'] ?? '';
      editCtrl!.familyNameController.text = widget.data?['lastName'] ?? '';
      editCtrl!.phoneController.text = widget.data?['phone'] ?? '';
    } else {
      addCtrl = Get.put(AddTransactionController());
      addCtrl!.type = widget.data?['type'] ?? (Get.isRegistered<Transactioncontroller>() ? Get.find<Transactioncontroller>().type ?? 2 : 2);
      addCtrl!.nameController.clear();
      addCtrl!.familyNameController.clear();
      addCtrl!.phoneController.clear();
    }
  }

  int get activeType => widget.isEdit ? (editCtrl!.type ?? 2) : (addCtrl!.type ?? 2);

  void setActiveType(int val) {
    setState(() {
      if (widget.isEdit) {
        editCtrl!.type = val;
      } else {
        addCtrl!.type = val;
      }
    });
  }

  Future<void> _handleSave() async {
    if (widget.isEdit) {
      await editCtrl!.editTransaction();
      if (editCtrl!.statusrequest != Statusrequest.failure) {
        if (Get.isRegistered<Transactioncontroller>()) {
          Get.find<Transactioncontroller>().getTransactions();
        }
      }
    } else {
      await addCtrl!.addTransaction();
      if (addCtrl!.statusRequest != Statusrequest.failure) {
        if (Get.isRegistered<Transactioncontroller>()) {
          Get.find<Transactioncontroller>().getTransactions();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.find<Siedbarcontroller>();
    const blueColor = AppColor.primaryPurple;

    return Obx(() {
      final isDark = sidebarController.isDarkMode.value;
      final surfaceColor = isDark ? AppColor.surfaceDark : Colors.white;
      final fieldColor = isDark
          ? Colors.white.withOpacity(0.05)
          : const Color(0xFFF2F5FF);
      final textColor = isDark ? AppColor.textDark : AppColor.textLight;

      return Form(
        key: widget.isEdit ? editCtrl!.formKey : addCtrl!.formKey,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: surfaceColor,
          child: Container(
            width: 550,
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.isEdit
                              ? 'edit_contact'.tr
                              : 'add_new_contact'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'add_contact_desc'.tr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Type Switcher (Customer / Supplier)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: fieldColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTypeButton(
                          label: 'supplier'.tr,
                          icon: Icons.local_shipping_outlined,
                          isActive: activeType == 1,
                          isDark: isDark,
                          onTap: () => setActiveType(1),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTypeButton(
                          label: 'customer'.tr,
                          icon: Icons.person_outline_rounded,
                          isActive: activeType == 2,
                          isDark: isDark,
                          onTap: () => setActiveType(2),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Fields: Name and Last Name
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'customer_supplier_name'.tr,
                        hint: 'مثال: أحمد',
                        fieldColor: fieldColor,
                        textColor: textColor,
                        controller: widget.isEdit ? editCtrl!.nameController : addCtrl!.nameController,
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'last_name'.tr,
                        hint: 'مثال: العلي',
                        fieldColor: fieldColor,
                        textColor: textColor,
                        controller: widget.isEdit ? editCtrl!.familyNameController : addCtrl!.familyNameController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Phone Number Field
                _buildTextField(
                  label: 'mobile_number'.tr,
                  hint: '05XXXXXXXX',
                  fieldColor: fieldColor,
                  textColor: textColor,
                  controller: widget.isEdit ? editCtrl!.phoneController : addCtrl!.phoneController,
                  prefixIcon: Icons.phone_outlined,
                  isRequired: true,
                ),
                const SizedBox(height: 24),

                // Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColor.accentPurple.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Icon(Icons.info_rounded, color: blueColor, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'contact_save_info'.tr,
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 11,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Actions
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _handleSave,
                        icon: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          'save'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blueColor,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: fieldColor,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'cancel'.tr,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  Widget _buildTypeButton({
    required String label,
    required IconData icon,
    required bool isActive,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final activeColor = AppColor.primaryPurple;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: isActive ? Colors.white : Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required Color fieldColor,
    required Color textColor,
    required TextEditingController controller,
    IconData? prefixIcon,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isRequired)
              const Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CustemTextField(
          controller: controller,
          hint: hint,
          textAlign: TextAlign.right,
          keyboardType: prefixIcon == Icons.phone_outlined ? TextInputType.phone : TextInputType.text,
          validator: isRequired ? (val) {
            String type = prefixIcon == Icons.phone_outlined ? "phone" : "text";
            int min = prefixIcon == Icons.phone_outlined ? 8 : 2;
            int max = prefixIcon == Icons.phone_outlined ? 15 : 50;
            return validInput(val ?? "", max, min, type);
          } : null,
          suffixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey, size: 20) : null,
        ),
      ],
    );
  }
}
