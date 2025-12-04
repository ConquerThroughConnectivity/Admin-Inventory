import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesReportScreen extends StatelessWidget {
  const SalesReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: ListView(
          children: [
            /// HEADER
            Row(
              children: [
                Text(
                  "Sales Reports",
                  style: TextStyle(
                    fontSize: 32.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                filterButton("Last 30 Days"),
                SizedBox(width: 12.w),
                actionButton("Export Data"),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              "Track and analyze your sales performance.",
              style: TextStyle(color: Colors.white60, fontSize: 16.sp),
            ),
            SizedBox(height: 30.h),

            /// TOP METRIC CARDS
            LayoutBuilder(builder: (_, constraints) {
              final isMobile = constraints.maxWidth < 900;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isMobile ? 1 : 4,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: isMobile ? 4 : 3.2,
                children: [
                  metricCard(
                    title: "Total Revenue",
                    value: "\$1,250,345",
                    change: "+2.5%",
                    positive: true,
                  ),
                  metricCard(
                    title: "Units Sold",
                    value: "8,921",
                    change: "-1.2%",
                    positive: false,
                  ),
                  metricCard(
                    title: "Average Order Value",
                    value: "\$140.15",
                    change: "+0.8%",
                    positive: true,
                  ),
                  metricCard(
                    title: "New Customers",
                    value: "312",
                    change: "+5.0%",
                    positive: true,
                  ),
                ],
              );
            }),

            SizedBox(height: 30.h),

            /// CHART + TOP ITEMS
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 48.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// REVENUE TREND
                    Expanded(
                      flex: 2,
                      child: bigChartCard(),
                    ),
                    SizedBox(width: 20.w),

                    /// TOP SELLING ITEMS
                    Expanded(
                      flex: 1,
                      child: topItemsCard(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  /// FILTER BUTTON
  Widget filterButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
          SizedBox(width: 6.w),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white),
        ],
      ),
    );
  }

  /// EXPORT BUTTON
  Widget actionButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.upload, color: Colors.white),
          SizedBox(width: 6.w),
          Text(text, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
        ],
      ),
    );
  }

  /// METRIC CARD
  Widget metricCard({
    required String title,
    required String value,
    required String change,
    required bool positive,
  }) {
    return Container(
            padding: EdgeInsets.only(left: 15.w, top: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1C242E),
        borderRadius: BorderRadius.circular(20.r),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,
              style: TextStyle(color: Colors.white60, fontSize: 13.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 3.h),
          Text(
            change,
            style: TextStyle(
              fontSize: 12.sp,
              color: positive ? Colors.green : Colors.red,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// REVENUE TREND CARD
  Widget bigChartCard() {
    return Container(
      height: 280.h,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1C242E),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Revenue Trend",
              style: TextStyle(color: Colors.white, fontSize: 20.sp)),
          SizedBox(height: 10.h),
          Text("\$280,450",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
              )),
          Text("Last 30 Days +12.5%",
              style: TextStyle(color: Colors.green, fontSize: 14.sp)),
          SizedBox(height: 20.h),

          /// LINE CHART
          Expanded(
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const weeks = ['W1', 'W2', 'W3', 'W4'];
                        if (value.toInt() >= 0 && value.toInt() < weeks.length) {
                          return Text(
                            weeks[value.toInt()],
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11.sp,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${(value / 1000).toStringAsFixed(0)}K',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 9.sp,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 30000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 60000),
                      FlSpot(1, 75000),
                      FlSpot(2, 90000),
                      FlSpot(3, 85000),
                    ],
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.2),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blue,
                          strokeWidth: 2,
                          strokeColor: Colors.blue.withOpacity(0.3),
                        );
                      },
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

  /// TOP SELLING ITEMS
  Widget topItemsCard() {
    return Container(
      height: 280.h,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1C242E),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Top Selling Items",
              style: TextStyle(color: Colors.white, fontSize: 20.sp)),
          SizedBox(height: 10.h),
          Text("1,245 Units",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              )),
          Text("Last 30 Days +8.2%",
              style: TextStyle(color: Colors.green, fontSize: 14.sp)),
          SizedBox(height: 20.h),

          Expanded(
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const items = ['Item A', 'Item B', 'Item C', 'Item D', 'Item E'];
                        if (value.toInt() >= 0 && value.toInt() < items.length) {
                          return Text(
                            items[value.toInt()],
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10.sp,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 9.sp,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(toY: 450, color: Colors.blue, width: 18),
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(toY: 380, color: Colors.blue, width: 18),
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(toY: 320, color: Colors.blue, width: 18),
                  ]),
                  BarChartGroupData(x: 3, barRods: [
                    BarChartRodData(toY: 250, color: Colors.blue, width: 18),
                  ]),
                  BarChartGroupData(x: 4, barRods: [
                    BarChartRodData(toY: 180, color: Colors.blue, width: 18),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
