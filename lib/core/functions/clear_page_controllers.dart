import 'package:get/get.dart';
import '../../controller/Dashpord/invoicesallcontroller.dart';
import '../../controller/HomeScreen/HomeController.dart';
import '../../controller/Profaile/transaction/transactionController.dart';
import '../../controller/categoris/ShwocatController.dart';
import '../../controller/items/ItemsController.dart';
import '../../controller/Dashpord/Salecontroller.dart';
import '../../controller/Statistice/StatisticeReportesController.dart';

void clearPageControllers() {
  Get.delete<Homecontroller>(force: true);
  Get.delete<Shwocatcontroller>(force: true);
  Get.delete<Itemscontroller>(force: true);
  Get.delete<Transactioncontroller>(force: true);
  Get.delete<SaleController>(force: true);
  Get.delete<Invoicesallcontroller>(force: true);
  Get.delete<Statisticereportescontroller>(force: true);
}
