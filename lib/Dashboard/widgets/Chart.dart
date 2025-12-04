import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
     final List<Color> gradientColors = [
    const Color(0xFF285A9B),
    const Color(0xFF285A9B).withOpacity(0.0),
  ];
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1C242E),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("\$89,450",
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 6.h),
          Text("+8.2% Last 30 Days",
              style: TextStyle(color: Colors.green, fontSize: 14.sp)),
          SizedBox(height: 20.h),

          SizedBox(
            height: 220.h,
            child: LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade800,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: false, // Hide all titles for a cleaner look as in the image
        ),
        borderData: FlBorderData(
          show: false, // Hide border
        ),
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 3),
              const FlSpot(1.5, 2.5),
              const FlSpot(2, 4),
              const FlSpot(3, 3),
              const FlSpot(4, 5),
              const FlSpot(5.5, 2.2),
              const FlSpot(6.5, 4.8),
              const FlSpot(7.5, 3.5),
              const FlSpot(8, 5.5),
              const FlSpot(9, 4),
              const FlSpot(10, 2.8),
              const FlSpot(11, 4.5),
            ],
            isCurved: true,
            color: const Color(0xFF285A9B), // Blue line color
            barWidth: 3.w,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
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
}


