import 'dart:async';
import 'package:get/get.dart';
import 'package:silaaty_desktop/core/class/SyncServer.dart';
import 'package:silaaty_desktop/core/functions/CheckInternat.dart';
import 'package:silaaty_desktop/core/services/Services.dart';

class SyncForegroundService extends GetxService {
  final SyncService syncService = SyncService();
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    start();
  }

  void start() {
    syncService.initSyncListener();

    _timer?.cancel();
    // 1. مزامنة عند الدخول للتطبيق
    _runSync();

    // 2. مزامنة كل 15 دقيقة
    _timer = Timer.periodic(const Duration(minutes: 15), (_) {
      _runSync();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    print("Sync Timer stopped");
  }

  Future<void> triggerSyncNow() async {
    await _runSync();
  }

  Future<void> _runSync() async {
    try {
      Myservices myServices = Get.find();
      String? token = myServices.sharedPreferences?.getString("token");
      // التحقق من تسجيل الدخول
      if (token != null && token.isNotEmpty) {
        if (await checkInternet()) {
          print("🔔 تنفيذ مهمة مزامنة دورية...");
          await syncService.syncAll();
        }
      } else {
        print("⚠️ تخطي المزامنة، المستخدم غير مسجل الدخول.");
      }
    } catch (e) {
      print("❌ خطأ أثناء المزامنة: $e");
    }
  }

  @override
  void onClose() {
    stop();
    super.onClose();
  }
}

void syncCallback() async {}
