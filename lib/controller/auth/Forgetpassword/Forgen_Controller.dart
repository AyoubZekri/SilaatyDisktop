import 'package:silaaty_desktop/core/class/Statusrequest.dart';
import 'package:silaaty_desktop/core/constant/routes.dart';
import 'package:silaaty_desktop/core/functions/handlingdatacontroller.dart';
import 'package:silaaty_desktop/data/datasource/Remote/Auth/Forgetpassword/checkemail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silaaty_desktop/view/widget/user_profile_dialog.dart';

import '../../../core/functions/Snacpar.dart';

abstract class ForgenController extends GetxController {
  // ignore: non_constant_identifier_names
  CheckEmail(String to);
}

class ForgenControllerImp extends ForgenController {
  late TextEditingController email;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  Checkemaildata checkemaildata = Checkemaildata(Get.find());
  Statusrequest statusrequest = Statusrequest.none;

  @override
  // ignore: non_constant_identifier_names
  CheckEmail(String to) async {
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();

      var response = await checkemaildata.postdata(email.text);
      if (response == Statusrequest.serverfailure) {
        showSnackbar("error".tr, "noInternet".tr, Colors.red);
      }

      // ignore: avoid_print
      print("==========================$response");

      statusrequest = handlingData(response);
      if (statusrequest == Statusrequest.success && response["status"] == 1) {
        if (to == "VerFiyCode") {
          Get.offNamed(Approutes.VerFiyCode, arguments: {
            "email": email.text,
          });
        } else if (to == "dialog") {
          Get.back();
          Get.dialog(VerifyCodeDialogWidget(email: email.text));
        } else {
          Get.offNamed(Approutes.verifiycodesetting, arguments: {
            "email": email.text,
          });
        }
      } else {
        showSnackbar("warning".tr, "Email Not Found".tr, Colors.orange);

        statusrequest = Statusrequest.failure;
      }

      update();
    }
  }

  @override
  onInit() {
    email = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }
}
