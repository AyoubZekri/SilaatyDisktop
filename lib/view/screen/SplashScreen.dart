import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../../controller/StartpageContrller.dart';
import '../../core/constant/imageassets.DART';
import '../../core/constant/routes.dart';
import '../../core/services/Services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Startpagecontrller contrller = Get.put(Startpagecontrller());
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  final Myservices myServices = Get.find();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();

    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    String? token = myServices.sharedPreferences?.getString("token");

    if (token != null && token.isNotEmpty) {
      await contrller.getUser();
    }

    _controller.forward();

    await Future.delayed(const Duration(seconds: 3));


    if (token != null && token.isNotEmpty) {
      String? experimentDateString =
          myServices.sharedPreferences!.getString("date_experiment") ?? "";
      print("=========================$experimentDateString");
      int? status = myServices.sharedPreferences!.getInt("Status");
      print("==========================status = $status  =================");
      if (status == 3 || status == 4 || status == 5 || status == 6) {
        Get.offAllNamed(Approutes.subscriptionExpiredPage);
        return;
      } else if (status == 9 || status == 10 || status == 13 || status == 14) {
        Get.offAllNamed(Approutes.HomeScreen);
        return;
      } else if (status == 0 || status == 1) {
        String email = myServices.sharedPreferences!.getString("email") ?? "";
        Get.offAllNamed(Approutes.VerifiycodeSignUp, arguments: {"email": email});
        return;
      }

      if (experimentDateString.isNotEmpty) {
        DateTime experimentDate = DateTime.parse(experimentDateString);
        DateTime currentDate = DateTime.now();
        DateTime today = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        );

        if (status == 2 || [7, 8, 11, 12].contains(status)) {
          if (today.isAfter(experimentDate) ||
              today.isAtSameMomentAs(experimentDate)) {
            Get.offAllNamed(Approutes.subscriptionExpiredPage);
          } else {
            Get.offAllNamed(Approutes.HomeScreen);
          }
          return;
        } else {
          Get.offAllNamed(Approutes.subscriptionExpiredPage);
          return;
        }
      } else {
        Get.offAllNamed(Approutes.subscriptionExpiredPage);
        return;
      }
    } else {
      Get.offAllNamed(Approutes.Login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Subtle watermark background
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: Image.asset(
                  Appimageassets.logo,
                  repeat: ImageRepeat.repeat,
                  scale: 3.0,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 50,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Image.asset(Appimageassets.logo, height: 160),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 25),
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: const Text(
                    "SILAATY - سلعتي",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A00E0),
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A00E0)),
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
