import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/home/HeaderSection.dart';
import '../widget/home/StatsCards.dart';
import '../widget/home/AnalyticsSection.dart';
import '../widget/home/TransactionsTable.dart';
import '../../controller/HomeScreen/HomeController.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Homecontroller());
    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by MainLayout
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeaderSection(),
            StatsSection(),
            AnalyticsSection(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
