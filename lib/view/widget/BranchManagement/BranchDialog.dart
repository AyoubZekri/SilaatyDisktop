import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/functions/valiedinput.dart';
import '../../../controller/SellerController.dart';
import '../CustemTextField.dart';

class BranchDialog extends StatefulWidget {
  final bool isDark;
  final SellerController controller;
  final int? sellerId;
  const BranchDialog({
    super.key,
    required this.isDark,
    required this.controller,
    this.sellerId,
  });

  @override
  State<BranchDialog> createState() => _BranchDialogState();
}

class _BranchDialogState extends State<BranchDialog> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColor.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: widget.controller.formState,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildDialogHeader(),
                const SizedBox(height: 48),
                _buildFieldLabel("seller_name".tr),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: widget.controller.nameController,
                  hint: "seller_name_hint".tr,
                  icon: Icons.person_outline,
                  isDark: widget.isDark,
                  validator: (val) => validInput(val!, 50, 3, 'text'),
                ),
                const SizedBox(height: 24),
                _buildFieldLabel("seller_email".tr),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: widget.controller.emailController,
                  hint: "example@gmail.com",
                  icon: Icons.email_outlined,
                  isDark: widget.isDark,
                  validator: (val) => validInput(val!, 100, 5, 'email'),
                ),
                const SizedBox(height: 24),
                _buildFieldLabel("seller_password".tr),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: widget.controller.passwordController,
                  hint: "........",
                  icon: Icons.lock_outline,
                  isDark: widget.isDark,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onTogglePassword: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  validator: (val) {
                    if (widget.sellerId == null &&
                        (val == null || val.isEmpty)) {
                      return "Can't be Empty".tr;
                    }
                    if (val != null && val.isNotEmpty) {
                      return validInput(val, 50, 4, 'password');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 48),
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: widget.isDark
                ? AppColor.primaryPurple.withOpacity(0.2)
                : const Color(0xFFEDE9FE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.add_business_outlined,
            color: AppColor.primaryPurple,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.sellerId == null
                    ? "add_new_seller".tr
                    : "edit_seller".tr,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: widget.isDark ? Colors.white : const Color(0xFF1E293B),
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "seller_registry_desc".tr,
                style: TextStyle(
                  fontSize: 14,
                  color: widget.isDark
                      ? AppColor.textSecondary
                      : Colors.grey.shade500,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: widget.isDark ? Colors.white70 : Colors.grey.shade700,
        fontFamily: 'Cairo',
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDark,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    return CustemTextField(
      controller: controller,
      hint: hint,
      icon: icon,
      obscureText: obscureText,
      validator: validator,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: Colors.grey,
              ),
              onPressed: onTogglePassword,
            )
          : null,
    );
  }

  Widget _buildActions() {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (widget.sellerId == null) {
                widget.controller.addSeller();
              } else {
                widget.controller.updateSeller(widget.sellerId!);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              "save".tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: widget.isDark ? Colors.white24 : Colors.grey.shade300,
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "cancel".tr,
              style: TextStyle(
                color: widget.isDark ? Colors.white70 : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
