import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

import 'package:silaaty_desktop/Bindings/Initialbindings.dart';
import 'package:silaaty_desktop/core/localizations/ChengeLocal.dart';
import 'package:silaaty_desktop/core/localizations/Translation.dart';
import 'package:silaaty_desktop/core/services/Services.dart';
import 'package:silaaty_desktop/routes.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

/// 👇 Listener باش نراقبو resize
class MyWindowListener extends WindowListener {
  @override
  void onWindowResize() async {
    final size = await windowManager.getSize();

    if (size.width < 1000 || size.height < 800) {
      await windowManager.setSize(const Size(1000, 800));
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await initialServices();

  /// 👇 تهيئة window_manager
  await windowManager.ensureInitialized();

  /// 👇 إضافة listener
  windowManager.addListener(MyWindowListener());

  /// 👇 إعدادات النافذة
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 800),
    minimumSize: Size(1000, 800), // الحد الأدنى
    center: true,
    title: "silaaty_desktop Desktop",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocalController controller = Get.put(LocalController());
    Get.put(RefreshService());
    return GetMaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      navigatorObservers: [routeObserver],
      translations: MyTranslation(),
      debugShowCheckedModeBanner: false,
      title: 'silaaty_desktop',
      theme: controller.themeData,
      locale: controller.language,
      initialBinding: Initialbindings(),
      getPages: routes,

      /// 👇 نحبسو تكبير الخط فقط
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
