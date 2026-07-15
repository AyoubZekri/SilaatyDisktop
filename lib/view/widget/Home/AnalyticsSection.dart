import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../../../controller/HomeScreen/SiedBarController.dart';
import '../../../controller/HomeScreen/HomeController.dart';
import '../../../core/constant/Colorapp.dart';

class AnalyticsSection extends StatelessWidget {
  const AnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Siedbarcontroller>();
    return GetBuilder<Homecontroller>(
      builder: (homeController) {
        return Obx(() {
          final isDark = controller.isDarkMode.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            child: Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildChartCard(isDark, homeController),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: _buildBestSellersCard(isDark, homeController),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildChartCard(bool isDark, Homecontroller homeController) {
    final titleColor = isDark ? AppColor.textDark : const Color(0xFF5D596C);

    int filter = homeController.selectedFilter;
    int expectedPoints = filter == 1
        ? 24
        : (filter == 2 ? 7 : (filter == 3 ? 4 : 12));

    List<Map<String, dynamic>> displayData = [];
    for (int i = 0; i < expectedPoints; i++) {
      var match = homeController.chartData.firstWhere(
        (e) => int.parse(e['x'].toString()) == i,
        orElse: () => {'x': i, 'y': 0},
      );
      displayData.add(match);
    }

    // Find the max Y for the chart scale
    double maxY = 8;
    if (displayData.isNotEmpty) {
      double maxVal = displayData
          .map((e) => ((e['y'] ?? 0) as num).toDouble())
          .reduce((a, b) => a > b ? a : b);
      if (maxVal > maxY) maxY = maxVal * 1.2;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                'إحصائيات الدخل',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: titleColor,
                ),
              ),
              _buildChartFilter(isDark, homeController),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'مقارنة أداء المبيعات عبر الفترات الزمنية',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColor.textSecondary : const Color(0xFF8E92BC),
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: maxY,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) =>
                        isDark ? const Color(0xFF333333) : Colors.blueGrey,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toInt()} د.ج',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final style = TextStyle(
                          color: isDark
                              ? AppColor.textSecondary
                              : const Color(0xFF8E92BC),
                          fontSize: 10,
                          fontFamily: 'Cairo',
                        );
                        if (value != value.toInt())
                          return const SizedBox.shrink();
                        int index = value.toInt();
                        String text = '$index';
                        if (index >= 0 && index < displayData.length) {
                          if (homeController.selectedFilter == 1) {
                            if (index % 4 != 0) return const SizedBox.shrink();
                            text =
                                '${index.toString().padLeft(2, '0')}:00'; // Hours
                          } else if (homeController.selectedFilter == 2) {
                            List<String> days = [
                              'الأحد',
                              'الاثنين',
                              'الثلاثاء',
                              'الأربعاء',
                              'الخميس',
                              'الجمعة',
                              'السبت',
                            ];
                            text = days[index % 7];
                          } else if (homeController.selectedFilter == 3) {
                            text = 'أسبوع ${index + 1}'; // Weeks
                          } else if (homeController.selectedFilter == 4) {
                            if (index % 2 != 0) return const SizedBox.shrink();
                            List<String> months = [
                              'جانفي',
                              'فيفري',
                              'مارس',
                              'أفريل',
                              'ماي',
                              'جوان',
                              'جويلية',
                              'أوت',
                              'سبتمبر',
                              'أكتوبر',
                              'نوفمبر',
                              'ديسمبر',
                            ];
                            text = months[index % 12]; // Months
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: maxY > 0 ? (maxY / 6) : 1,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '${value.toInt()}',
                            style: TextStyle(
                              color: isDark
                                  ? AppColor.textSecondary
                                  : const Color(0xFF8E92BC),
                              fontSize: 10,
                              fontFamily: 'Cairo',
                            ),
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY > 0 ? (maxY / 6) : 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.05),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: displayData.isEmpty
                        ? []
                        : List.generate(displayData.length, (index) {
                            final point = displayData[index];
                            return FlSpot(
                              index.toDouble(),
                              ((point['y'] ?? 0) as num).toDouble(),
                            );
                          }),
                    isCurved: true,
                    preventCurveOverShooting: true,
                    color: AppColor.primaryPurple,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColor.primaryPurple.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartFilter(bool isDark, Homecontroller homeController) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFFF3F4F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFilterTab(
            'اليوم',
            isActive: homeController.selectedFilter == 1,
            isDark: isDark,
            onTap: () => homeController.changeChartFilter(1),
          ),
          _buildFilterTab(
            'الأسبوع',
            isActive: homeController.selectedFilter == 2,
            isDark: isDark,
            onTap: () => homeController.changeChartFilter(2),
          ),
          _buildFilterTab(
            'الشهر',
            isActive: homeController.selectedFilter == 3,
            isDark: isDark,
            onTap: () => homeController.changeChartFilter(3),
          ),
          _buildFilterTab(
            'العام',
            isActive: homeController.selectedFilter == 4,
            isDark: isDark,
            onTap: () => homeController.changeChartFilter(4),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(
    String label, {
    required bool isActive,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark ? AppColor.surfaceDark : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? AppColor.primaryPurple
                : (isDark ? AppColor.textSecondary : const Color(0xFF8E92BC)),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }

  Widget _buildBestSellersCard(bool isDark, Homecontroller homeController) {
    final titleColor = isDark ? AppColor.textDark : const Color(0xFF5D596C);

    return Container(
      padding: const EdgeInsets.all(24),
      height: 420,
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'الأكثر مبيعاً',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: titleColor,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...homeController.bestSellers.map((item) {
                    return _buildBestSellerItem(
                      item['product_name']?.toString() ?? 'فئة',
                      (item['percentage'] as num?)?.toInt() ?? 0,
                      AppColor.primaryPurple,
                      Icons.category_outlined,
                      isDark,
                    );
                  }).toList(),
                  if (homeController.bestSellers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: Text(
                          'لا توجد مبيعات مسجلة',
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black54,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (homeController.bestSellers.isNotEmpty) ...[
            Divider(
              height: 30,
              color: isDark ? Colors.white10 : Colors.black12,
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'إجمالي المخزون النشط',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColor.textSecondary
                          : const Color(0xFF8E92BC),
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    '2,482',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E3A20)
                      : const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'مستقر',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellerItem(
    String title,
    int progress,
    Color color,
    IconData icon,
    bool isDark,
  ) {
    final titleColor = isDark ? AppColor.textDark : const Color(0xFF5D596C);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                          color: titleColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$progress%',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColor.textSecondary
                            : const Color(0xFF8E92BC),
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: isDark
                        ? Colors.white.withOpacity(0.05)
                        : const Color(0xFFEEEEF5),
                    color: color,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
