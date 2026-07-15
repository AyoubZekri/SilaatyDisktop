import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silaaty_desktop/core/functions/callback.dart';
import 'package:silaaty_desktop/core/class/Sqldb.dart';

class Myservices extends GetxService {
  SharedPreferences? sharedPreferences;

  Future<Myservices> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }
}

class RefreshService extends GetxService {
  var refreshTrigger = false.obs;

  void fire() {
    refreshTrigger.value = !refreshTrigger.value;
  }
}

initialServices() async {
  print("initialServices running");
  await Get.putAsync(() => Myservices().init());

  Get.put(SyncForegroundService(), permanent: true);
  print("initialServices done");
}
