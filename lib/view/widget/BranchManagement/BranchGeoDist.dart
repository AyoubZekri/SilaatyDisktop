import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';

class BranchGeoDist extends StatelessWidget {
  final bool isDark;
  const BranchGeoDist({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              Text("branch_geo_dist".tr, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  _buildLegendItem("central_region".tr, AppColor.primaryPurple),
                  const SizedBox(width: 24),
                  _buildLegendItem("western_region".tr, Colors.blue),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=2074&auto=format&fit=crop'),
                  fit: BoxFit.cover,
                  opacity: 0.6,
                ),
                color: isDark ? Colors.black38 : Colors.grey.shade100,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 100, right: 200,
                    child: _buildMapPin(AppColor.primaryPurple),
                  ),
                  Positioned(
                    bottom: 120, right: 400,
                    child: _buildMapPin(Colors.blue),
                  ),
                  Positioned(
                    top: 180, left: 300,
                    child: _buildMapPin(AppColor.primaryPurple),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Cairo')),
        const SizedBox(width: 8),
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      ],
    );
  }

  Widget _buildMapPin(Color color) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 15, spreadRadius: 5)]),
      child: Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    );
  }
}
