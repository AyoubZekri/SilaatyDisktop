import 'package:silaaty_desktop/controller/StartpageContrller.dart';
import 'package:silaaty_desktop/core/class/Statusrequest.dart';
import 'package:silaaty_desktop/core/constant/routes.dart';
import 'package:silaaty_desktop/data/datasource/Remote/StatisticsData.dart';
import 'package:silaaty_desktop/data/model/StatisticHomeModel.dart';
import 'package:get/get.dart';

import '../../core/class/SyncServer.dart';
import '../../core/functions/callback.dart';
import '../../core/services/Services.dart';

class Homecontroller extends GetxController {
  Statisticsdata statisticsdata = Statisticsdata();
  Statusrequest staticrequest = Statusrequest.none;
  StatisticsHomeModel? statisticsHome;
  List<Map<String, dynamic>> chartData = [];
  List<Map<String, dynamic>> recentTransactions = [];
  List<Map<String, dynamic>> bestSellers = [];

  bool showExpirationWarning = false;
  Myservices myServices = Get.find();

  gotoAddclients() {
    Get.toNamed(Approutes.AddConvict);
  }

  gotoclients() {
    Get.toNamed(Approutes.Convicts, arguments: {"type": 2});
  }

  gotoAddproduct() {
    Get.toNamed(Approutes.Additem);
  }

  gotoproduct() {
    Get.toNamed(Approutes.item);
  }

  gotoInvoicesall() {
    Get.toNamed(Approutes.invoicesall);
  }

  gotoLowStoke() {
    Get.toNamed(Approutes.lowstock);
  }

  gotoNewSale() {
    Get.toNamed(Approutes.newSale);
  }

  gotoMore() {
    Get.toNamed(Approutes.profailedata);
  }

  int selectedFilter = 1;

  changeChartFilter(int filter) async {
    selectedFilter = filter;
    await getstatistics();
  }

  getstatistics() async {
    try {
      update();
      var result = await statisticsdata.statisticsHome();

      // Fetch recent transactions (dummy or real if we add to StatisticsData)
      // For now, I'll fetch recent sales directly if Statisticsdata has a method or I can write a query using db.
      var rawStats = await statisticsdata.getChartStats(selectedFilter);
      if (rawStats.isNotEmpty && rawStats[0]['chart'] != null) {
        chartData = List<Map<String, dynamic>>.from(rawStats[0]['chart']);
      } else {
        chartData = [];
      }

      recentTransactions = await statisticsdata.getRecentTransactions();
      bestSellers = await statisticsdata.getBestSellers();

      print("===============get Statistics==================$result");

      if (result.isNotEmpty) {
        statisticsHome = StatisticsHomeModel.fromJson(result);
        staticrequest = Statusrequest.success;
      }
    } catch (e) {
      print("===============Error get Statistics===================$e");
      staticrequest = Statusrequest.serverfailure;
    }
    update();
  }

  Future<void> _handleLoginSync() async {
    try {
      final startController = Get.find<Startpagecontrller>();
      await startController.getUser();

      await Get.find<SyncForegroundService>().triggerSyncNow();
      reloadStats();
    } catch (e, s) {
      print("❌ خطأ أثناء المزامنة بعد تسجيل الدخول");
      print(e);
      print(s);
    }
  }

  Future<void> _handleAppStartSync() async {
    try {
      await Get.find<SyncForegroundService>().triggerSyncNow();
      reloadStats();
    } catch (e) {
      print("❌ خطأ أثناء المزامنة عند بداية التطبيق: $e");
    }
  }

  Future<void> reloadStats() async {
    await getstatistics();
    update();
  }

  void checkExpirationDate() {
    final status = myServices.sharedPreferences!.getInt("Status");
    if (status == 5 || status == 6) {
      showExpirationWarning = false;
      return;
    }

    final dateStr = myServices.sharedPreferences!.getString("date_experiment");
    if (dateStr != null && dateStr.isNotEmpty) {
      try {
        final expDate = DateTime.parse(dateStr);
        final now = DateTime.now();
        final difference = expDate.difference(now).inDays;

        if (difference >= 0 && difference <= 30) {
          showExpirationWarning = true;
        }
      } catch (e) {
        // ignore parsing error
      }
    }
  }

  void dismissWarning() {
    showExpirationWarning = false;
    update();
  }

  @override
  void onInit() {
    final refreshService = Get.find<RefreshService>();
    ever(refreshService.refreshTrigger, (_) {
      reloadStats();
    });
    Future.delayed(Duration.zero, () {
      Get.find<RefreshService>().fire();
    });

    final args = Get.arguments;
    final fromLogin = args != null && args['fromlogin'] == 1;

    if (fromLogin) {
      _handleLoginSync();
    } else {
      _handleAppStartSync();
    }

    checkExpirationDate();

    super.onInit();
  }
}
