import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      margin: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColor.purpleGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "welcome_back".tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "dashboard_overview".tr,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon, {
    required bool isPrimary,
    required bool isDark,
  }) {
    final primaryColor = AppColor.primaryPurple;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isPrimary
            ? primaryColor
            : (isDark ? AppColor.surfaceDark : Colors.white),
        borderRadius: BorderRadius.circular(10),
        border: isPrimary
            ? null
            : Border.all(color: primaryColor.withOpacity(0.1)),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(
          icon,
          color: isPrimary ? Colors.white : primaryColor,
          size: 20,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isPrimary ? Colors.white : primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
