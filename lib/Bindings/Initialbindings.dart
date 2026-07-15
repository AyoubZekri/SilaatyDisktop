import 'package:silaaty_desktop/controller/StartpageContrller.dart';
import 'package:silaaty_desktop/controller/auth/Logincontroller.dart';
import 'package:silaaty_desktop/core/class/Crud.dart';
import 'package:silaaty_desktop/core/services/Services.dart';
import 'package:get/get.dart';

import '../controller/HomeScreen/HomeController.dart';

class Initialbindings extends Bindings {
  @override
  void dependencies() {
    Get.put(Crud());
    Get.put(Myservices());
    Get.lazyPut(() => Logincontroller(), fenix: true);
    Get.lazyPut(() => Startpagecontrller(), fenix: true);
    // Get.lazyPut(() => HomescreencontrollerImp());
    Get.lazyPut(() => Homecontroller());
  }
}
