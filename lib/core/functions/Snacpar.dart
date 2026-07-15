import 'dart:async';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:get/get.dart';

Flushbar? _currentFlushbar;
Future<void>? _snackbarQueue;

void showSnackbar(String titleKey, String messageKey, Color color) {
  IconData iconData;
  if (color == Colors.green) {
    iconData = Icons.check_circle;
  } else if (color == Colors.red) {
    iconData = Icons.error;
  } else if (color == Colors.orange) {
    iconData = Icons.warning;
  } else {
    iconData = Icons.info;
  }

  _snackbarQueue = (_snackbarQueue ?? Future.value()).then((_) async {
    final context = Get.context;
    if (context == null) return;

    // إزالة أي Flushbar حالية
    if (_currentFlushbar != null) {
      if (_currentFlushbar!.isShowing() || _currentFlushbar!.isAppearing()) {
        try {
          await _currentFlushbar!.dismiss();
        } catch (e) {
          // ignore
        }
      }
      _currentFlushbar = null;
    }

    _currentFlushbar = Flushbar(
      margin: const EdgeInsets.only(
        bottom: 20, // المسافة من الأسفل
        right: 20,
        left: 900, // المسافة من اليمين
      ),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: color.withOpacity(0.85),
      icon: Icon(iconData, color: Colors.white),
      titleText: Text(
        titleKey.tr,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        messageKey.tr,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.BOTTOM,
      isDismissible: true,
    );

    try {
      await _currentFlushbar?.show(context);
    } catch (e) {
      // ignore
    } finally {
      _currentFlushbar = null;
    }
  });
}
