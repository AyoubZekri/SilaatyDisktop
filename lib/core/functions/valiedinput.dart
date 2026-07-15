import 'package:silaaty_desktop/core/functions/Snacpar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

validInput(String val, int max, int min, String type) {
  if (val.isEmpty) {
    return "لا يمكن أن يكون الحقل فارغاً".tr;
  }

  if (type == 'username') {
    if (!GetUtils.isUsername(val)) {
      return "اسم المستخدم غير صالح".tr;
    }
  }
  if (type == 'Email' || type == 'email') {
    if (!GetUtils.isEmail(val)) {
      return "البريد الإلكتروني غير صالح".tr;
    }
  }
  if (type == 'phone') {
    if (!GetUtils.isPhoneNumber(val)) {
      return "رقم الهاتف غير صالح".tr;
    }
  }
  if (type == 'number' || type == 'int') {
    if (!GetUtils.isNumericOnly(val)) {
      return "يجب أن يكون رقماً صحيحاً".tr;
    }
  }
  if (type == 'decimal' || type == 'double') {
    if (double.tryParse(val) == null) {
      return "يجب أن يكون رقماً (يمكن أن يحتوي على فواصل)".tr;
    }
  }
  if (type == 'text') {
    // Basic text check if needed, mostly handled by min/max
  }

  if (val.length < min) {
    return "${"لا يمكن أن يكون أقل من".tr} $min";
  }
  
  if (val.length > max) {
    return "${"لا يمكن أن يكون أكبر من".tr} $max";
  }

  return null;
}

bool validInputsnak(String val, int min, int max, String type) {
  if (val.isEmpty) {
    showSnackbar("error".tr, "لا يمكن أن يكون الحقل فارغًا".tr, Colors.red);
    return false;
  }

  if (val.length > max) {
    showSnackbar(
      "error".tr,
      "${'لا يمكن أن يكون حقل'.tr} $type ${'أطول من'.tr} $max ${'حرف'.tr}",
      Colors.red,
    );
    return false;
  }

  if (val.length < min) {
    showSnackbar(
      "error".tr,
      "${'لا يمكن أن يكون حقل'.tr} $type ${'أقل من'.tr}  $min ${'حرف'.tr}",
      Colors.red,
    );
    return false;
  }

  if (type == 'username' && !GetUtils.isUsername(val)) {
    showSnackbar("error".tr, "اسم المستخدم غير صالح".tr, Colors.red);
    return false;
  }

  if ((type == 'email' || type == 'Email') && !GetUtils.isEmail(val)) {
    showSnackbar("error".tr, "البريد الإلكتروني غير صالح".tr, Colors.red);
    return false;
  }

  if (type == 'phone' && !GetUtils.isPhoneNumber(val)) {
    showSnackbar("error".tr, "رقم الهاتف غير صالح".tr, Colors.red);
    return false;
  }

  if (type == 'number' || type == 'int') {
    if (!GetUtils.isNumericOnly(val)) {
      showSnackbar("error".tr, "يجب أن يكون رقماً صحيحاً".tr, Colors.red);
      return false;
    }
  }

  if (type == 'decimal' || type == 'double') {
    if (double.tryParse(val) == null) {
      showSnackbar("error".tr, "يجب أن يكون رقماً (يمكن أن يحتوي على فواصل)".tr, Colors.red);
      return false;
    }
  }

  return true;
}
