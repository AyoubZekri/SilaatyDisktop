import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:silaaty_desktop/core/constant/Colorapp.dart';
import 'package:silaaty_desktop/core/constant/imageassets.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../controller/HomeScreen/SiedBarController.dart';
import 'package:silaaty_desktop/view/widget/CustemTextField.dart';
import '../../controller/auth/Forgetpassword/ResetPasswordcontroler.dart';
import '../../controller/auth/Forgetpassword/Forgen_Controller.dart';
import '../../controller/auth/Forgetpassword/VeriFycodecontroller.dart';
import '../../controller/Setteng/updateUserController.dart';
import 'package:silaaty_desktop/core/class/Statusrequest.dart';

import '../../core/functions/valiedinput.dart';


class UserProfileDialog extends StatelessWidget {
  const UserProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Siedbarcontroller>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color textColor = isDark ? AppColor.white : AppColor.deepPurple;
    Color subtitleColor = isDark
        ? AppColor.textSecondary
        : Colors.grey.shade700;
    Color cardColor = isDark ? AppColor.surfaceDark : Colors.white;
    Color statusBgColor = isDark
        ? AppColor.deepPurple.withOpacity(0.2)
        : AppColor.primaryPurple.withOpacity(0.08);

    return Obx(() {
      String formattedDate = 'unspecified'.tr;
      if (controller.dateExperiment.value != null &&
          controller.dateExperiment.value!.isNotEmpty) {
        try {
          DateTime date = DateTime.parse(controller.dateExperiment.value!);
          formattedDate = DateFormat('dd MMMM yyyy', 'ar').format(date);
        } catch (e) {
          formattedDate = controller.dateExperiment.value!;
        }
      }

      String statusText = (controller.status.value ?? 0) >= 1
          ? 'status_active'.tr
          : 'status_inactive'.tr;

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: cardColor,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cover Image & Avatar Stack
              SizedBox(
                height: 180,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Cover Image
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColor.purpleGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    // Close Button
                    Positioned(
                      top: 10,
                      right: 10,
                      child: InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    // Avatar
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: () {
                            final path = controller.imagePath.value;
                            if (path != null &&
                                path.isNotEmpty &&
                                !path.startsWith('http') &&
                                File(path).existsSync()) {
                              return FileImage(File(path)) as ImageProvider;
                            }
                            return const AssetImage(Appimageassets.logo);
                          }(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Info Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Text(
                      controller.hallname.value.isEmpty
                          ? 'hall_name_label'.tr
                          : controller.hallname.value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.name.value.isEmpty
                          ? 'ahmed_alsultan'.tr
                          : controller.name.value,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColor.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.emailofuser.value.isEmpty
                              ? "owner@luxvenue.com"
                              : controller.emailofuser.value,
                          style: TextStyle(fontSize: 14, color: subtitleColor),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.email_outlined,
                          size: 16,
                          color: subtitleColor,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Account Status Card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Right Side: Details
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryPurple.withOpacity(
                                    0.2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.verified_user_outlined,
                                  color: AppColor.deepPurple,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                textDirection: TextDirection.rtl,
                                children: [
                                  Text(
                                    statusText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${'activation_end_date'.tr}: $formattedDate',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: subtitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                     
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        // Edit Account Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Get.back();
                              Get.dialog(const EditProfileDialog());
                            },
                            icon: Icon(
                              Icons.person_outline,
                              size: 18,
                              color: textColor,
                            ),
                            label: Text(
                              'edit_account'.tr,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(
                                color: isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Edit Password Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Get.back();
                              Get.dialog(const SettingsPasswordDialog());
                            },
                            icon: Icon(
                              Icons.lock_outline,
                              size: 18,
                              color: textColor,
                            ),
                            label: Text(
                              'edit_password'.tr,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(
                                color: isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          controller.logout();
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: Text(
                          'logout'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryPurple,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class EditProfileDialog extends StatelessWidget {
  const EditProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Updateusercontroller());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColor.surfaceDark : AppColor.white;
    final inputBgColor = isDark ? AppColor.surfaceDark : AppColor.primarycolor;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: GetBuilder<Updateusercontroller>(
        builder: (controller) {
          return Container(
            width: 700,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: controller.formstate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Premium Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColor.primaryPurple.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: AppColor.primaryPurple.withOpacity(0.2),
                          width: 1,
                        )
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColor.primaryPurple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.edit_document,
                                color: AppColor.primaryPurple,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'edit_account'.tr,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDark 
                                    ? AppColor.white 
                                    : AppColor.deepPurple,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Get.back(),
                          splashRadius: 24,
                          color: AppColor.grey,
                        ),
                      ],
                    ),
                  ),
                  
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Picture Section
                          Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColor.primaryPurple.withOpacity(0.3),
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.primaryPurple.withOpacity(0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: controller.file != null
                                        ? Image.file(controller.file!, fit: BoxFit.cover)
                                        : Container(
                                            color: inputBgColor,
                                            child: const Icon(Icons.person, size: 60, color: AppColor.grey),
                                          ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => controller.imageupload(),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColor.primaryPurple,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: cardColor, width: 3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColor.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        )
                                      ],
                                    ),
                                    child: const Icon(Icons.camera_alt_rounded, color: AppColor.white, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Form Fields Section
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: inputBgColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColor.grey.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "معلومات المتجر",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primaryPurple,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustemTextField(
                                        controller: controller.nameController,
                                        label: 'اسم المتجر',
                                        hint: 'اسم المتجر',
                                        icon: Icons.store_outlined,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: CustemTextField(
                                        controller: controller.PhoneController,
                                        label: 'رقم الهاتف',
                                        hint: 'رقم الهاتف',
                                        icon: Icons.phone_outlined,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustemTextField(
                                        controller: controller.adresseController,
                                        label: 'العنوان',
                                        hint: 'العنوان',
                                        icon: Icons.location_on_outlined,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Get.back(),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: Text(
                                  'cancel'.tr,
                                  style: const TextStyle(
                                    color: AppColor.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {
                                  controller.updateuser();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primaryPurple,
                                  foregroundColor: AppColor.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  elevation: 2,
                                  shadowColor: AppColor.primaryPurple.withOpacity(0.5),
                                ),
                                child: controller.statusrequest == Statusrequest.loadeng
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(color: AppColor.white, strokeWidth: 3),
                                      )
                                    : Text(
                                        'save'.tr,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SettingsPasswordDialog extends StatelessWidget {
  const SettingsPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ResetpasswordcontrolerImp());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? AppColor.white : AppColor.deepPurple;
    Color bgColor = isDark ? AppColor.surfaceDark : AppColor.white;
    Color inputBgColor = isDark ? AppColor.surfaceDark : AppColor.primarycolor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: GetBuilder<ResetpasswordcontrolerImp>(
        builder: (controller) {
          return Container(
            width: 500,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Form(
              key: controller.formstate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'edit_password'.tr,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close, color: textColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustemTextField(
                    label: 'كلمة المرور القديمة',
                    hint: 'أدخل كلمة المرور القديمة',
                    icon: Icons.lock_outline,
                    controller: controller.OldPassword,
                    obscureText: controller.obscureText3,
                    suffixIcon: IconButton(
                      icon: Icon(controller.obscureText3 ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () => controller.showPasswored3(),
                    ),
                    validator: (val) => validInput(val!, 100, 4, "password"),
                  ),
                  const SizedBox(height: 16),
                  CustemTextField(
                    label: 'new_password_label'.tr,
                    hint: 'new_password_hint'.tr,
                    icon: Icons.lock_reset,
                    controller: controller.Passwoed,
                    obscureText: controller.obscureText,
                    suffixIcon: IconButton(
                      icon: Icon(controller.obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () => controller.showPassword(),
                    ),
                    validator: (val) => validInput(val!, 100, 6, "password"),
                  ),
                  const SizedBox(height: 16),
                  CustemTextField(
                    label: 'confirm_password_label'.tr,
                    hint: 'password_hint'.tr,
                    icon: Icons.verified_user_outlined,
                    controller: controller.RePasswoed,
                    obscureText: controller.obscureText2,
                    suffixIcon: IconButton(
                      icon: Icon(controller.obscureText2 ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () => controller.showPasswored2(),
                    ),
                    validator: (val) {
                      if (val != controller.Passwoed.text) return "password_mismatch".tr;
                      return validInput(val!, 100, 6, "password");
                    },
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                        Get.dialog(const ForgetPasswordDialogWidget());
                      },
                      child: Text(
                        'forget_password_title'.tr,
                        style: const TextStyle(color: AppColor.primaryPurple, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('cancel'.tr, style: const TextStyle(color: AppColor.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => controller.Resetpasswordsetting(), // Uses OldPassword
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryPurple,
                          foregroundColor: AppColor.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: controller.statusrequest == Statusrequest.loadeng
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColor.white, strokeWidth: 2))
                            : Text('save'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ForgetPasswordDialogWidget extends StatelessWidget {
  const ForgetPasswordDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ForgenControllerImp());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? AppColor.white : AppColor.deepPurple;
    Color bgColor = isDark ? AppColor.surfaceDark : AppColor.white;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: GetBuilder<ForgenControllerImp>(
        builder: (controller) {
          return Container(
            width: 500,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(24)),
            child: Form(
              key: controller.formstate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('forget_password_title'.tr, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                      IconButton(onPressed: () => Get.back(), icon: Icon(Icons.close, color: textColor)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('forget_password_subtitle'.tr, style: TextStyle(color: AppColor.textSecondary, fontSize: 14)),
                  const SizedBox(height: 24),
                  CustemTextField(
                    label: 'email_label'.tr,
                    hint: 'email_hint'.tr,
                    icon: Icons.email_outlined,
                    controller: controller.email,
                    validator: (val) => validInput(val!, 100, 5, "email"),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                           Get.back();
                           Get.dialog(const SettingsPasswordDialog());
                        },
                        child: Text('cancel'.tr, style: const TextStyle(color: AppColor.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => controller.CheckEmail("dialog"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryPurple,
                          foregroundColor: AppColor.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: controller.statusrequest == Statusrequest.loadeng
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColor.white, strokeWidth: 2))
                            : Text('send_code_btn'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VerifyCodeDialogWidget extends StatelessWidget {
  final String email;
  const VerifyCodeDialogWidget({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VeriFyCodeControllerImp());
    controller.email = email;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? AppColor.white : AppColor.deepPurple;
    Color bgColor = isDark ? AppColor.surfaceDark : AppColor.white;
    TextEditingController otpController = TextEditingController();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: GetBuilder<VeriFyCodeControllerImp>(
        builder: (controller) {
          return Container(
            width: 500,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('رمز التفعيل المكون من 5 أرقام', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                    IconButton(onPressed: () => Get.back(), icon: Icon(Icons.close, color: textColor)),
                  ],
                ),
                const SizedBox(height: 24),
                Text('الرجاء إدخال الرمز المكون من 5 أرقام المرسل إلى بريدك الإلكتروني', style: TextStyle(color: AppColor.textSecondary, fontSize: 14)),
                const SizedBox(height: 24),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: OtpTextField(
                    numberOfFields: 5,
                    autoFocus: true,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    borderColor: Colors.grey.shade300,
                    focusedBorderColor: AppColor.primaryPurple,
                    showFieldAsBox: true,
                    fieldWidth: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    borderRadius: BorderRadius.circular(8),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    onSubmit: (String verificationCode) {
                      otpController.text = verificationCode;
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                         Get.back();
                         Get.dialog(const ForgetPasswordDialogWidget());
                      },
                      child: Text('cancel'.tr, style: const TextStyle(color: AppColor.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (otpController.text.length == 5) {
                          controller.GoToresetPasswored(otpController.text, "dialog");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryPurple,
                        foregroundColor: AppColor.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: controller.statusrequest == Statusrequest.loadeng
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColor.white, strokeWidth: 2))
                          : const Text('تأكيد الرمز', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ResetPasswordDialogWidget extends StatelessWidget {
  final String email;
  const ResetPasswordDialogWidget({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetpasswordcontrolerImp());
    controller.email = email;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? AppColor.white : AppColor.deepPurple;
    Color bgColor = isDark ? AppColor.surfaceDark : AppColor.white;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: GetBuilder<ResetpasswordcontrolerImp>(
        builder: (controller) {
          return Container(
            width: 500,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(24)),
            child: Form(
              key: controller.formstate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('reset_password_title'.tr, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                      IconButton(onPressed: () => Get.back(), icon: Icon(Icons.close, color: textColor)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('أدخل كلمة المرور الجديدة', style: TextStyle(color: AppColor.textSecondary, fontSize: 14)),
                  const SizedBox(height: 24),
                  CustemTextField(
                    label: 'new_password_label'.tr,
                    hint: 'new_password_hint'.tr,
                    icon: Icons.lock_reset,
                    controller: controller.Passwoed,
                    obscureText: controller.obscureText,
                    suffixIcon: IconButton(
                      icon: Icon(controller.obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () => controller.showPassword(),
                    ),
                    validator: (val) => validInput(val!, 100, 6, "password"),
                  ),
                  const SizedBox(height: 16),
                  CustemTextField(
                    label: 'confirm_password_label'.tr,
                    hint: 'password_hint'.tr,
                    icon: Icons.verified_user_outlined,
                    controller: controller.RePasswoed,
                    obscureText: controller.obscureText2,
                    suffixIcon: IconButton(
                      icon: Icon(controller.obscureText2 ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () => controller.showPasswored2(),
                    ),
                    validator: (val) {
                      if (val != controller.Passwoed.text) return "password_mismatch".tr;
                      return validInput(val!, 100, 6, "password");
                    },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('cancel'.tr, style: const TextStyle(color: AppColor.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => controller.Resetpassword("dialog"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryPurple,
                          foregroundColor: AppColor.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: controller.statusrequest == Statusrequest.loadeng
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColor.white, strokeWidth: 2))
                            : Text('reset_btn'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

