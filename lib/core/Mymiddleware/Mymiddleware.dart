import 'package:silaaty_desktop/core/services/Services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:silaaty_desktop/core/constant/routes.dart';

class Mymiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  final Myservices myServices = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (myServices.sharedPreferences?.getString("step") == "2") {
      return const RouteSettings(name: Approutes.HomeScreen);
    }
    return const RouteSettings(name: Approutes.Login);
  }
}
