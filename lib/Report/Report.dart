import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

// --- Mock Data ---

class StatData {
  final String title;
  final double value;
  final double change;

  StatData(this.title, this.value, this.change);
}

class CategoryData {
  final String name;
  final double percentage;
  final Color color;

  CategoryData(this.name, this.percentage, this.color);
}

final List<StatData> mockStats = [
  StatData('Total Revenue', 1250450, 0.054), // 5.4%
  StatData('Net Profit', 340890, 0.082), // 8.2%
  StatData('Total Expenses', 909560, -0.021), // -2.1%
  StatData('Profit Margin', 0.2726, 0.015), // 27.26%, 1.5%
];

final List<CategoryData> mockCategories = [
  CategoryData('Salaries', 0.60, const Color(0xFF38977F)), // Green
  CategoryData('Marketing', 0.30, const Color(0xFFE54A4A)), // Red
  CategoryData('Operations', 0.10, const Color(0xFF285A9B)), // Blue
];



// --- Main Screen ---

class FinancialReportsScreen extends StatelessWidget {
  const FinancialReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive padding: use a percentage of the screen width for horizontal padding
          final horizontalPadding = constraints.maxWidth * 0.04;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              30.h,
              horizontalPadding,
              30.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header (Title and Export Button)
                const HeaderSection(),
                SizedBox(height: 24.h),

                // 2. Filter Row
                const FilterRow(),
                SizedBox(height: 30.h),

                // 3. Stats Grid (Responsive layout)
                StatsGrid(constraints: constraints),
                SizedBox(height: 30.h),

                // 4. Charts Section (Responsive layout)
                ChartSection(constraints: constraints),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- 1. Header Section ---

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Financial Reports',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.download, size: 18.sp),
          label: Text('Export Reports', style: TextStyle(fontSize: 14.sp)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF232D3B), // Dark blue/grey background
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            elevation: 0,
            side: const BorderSide(color: Color(0xFF285A9B)), // Light blue border
          ),
        ),
      ],
    );
  }
}

// --- 2. Filter Row ---

class FilterRow extends StatelessWidget {
  const FilterRow({super.key});

  Widget _buildDropdown(String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF232D3B),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade800, width: 1.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: null,
          hint: Text(hint, style: TextStyle(fontSize: 14.sp, color: Colors.white)),
          icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 20.sp),
          dropdownColor: const Color(0xFF232D3B),
          items: const [], // Placeholder items
          onChanged: (String? newValue) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      children: [
        _buildDropdown('Report Period: Last 30 Days'),
        _buildDropdown('All Categories'),
        _buildDropdown('All Products'),
        _buildDropdown('More Filters'),
      ],
    );
  }
}

// --- 3. Stats Grid ---

class StatsGrid extends StatelessWidget {
  final BoxConstraints constraints;
  const StatsGrid({required this.constraints, super.key});

  @override
  Widget build(BuildContext context) {
    // Determine the cross-axis count based on screen width
    int crossAxisCount = (constraints.maxWidth / 300.w).floor().clamp(1, 4);

    // Calculate item width based on the available space
    double itemWidth = (constraints.maxWidth - 2 * constraints.maxWidth * 0.04) / crossAxisCount;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20.w,
        mainAxisSpacing: 20.h,
        // Adjust the aspect ratio to make the cards slightly taller
        childAspectRatio: itemWidth / 150.h,
      ),
      itemCount: mockStats.length,
      itemBuilder: (context, index) {
        return StatsCard(data: mockStats[index]);
      },
    );
  }
}

class StatsCard extends StatelessWidget {
  final StatData data;
  const StatsCard({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isPositive = data.change >= 0;
    final color = isPositive ? const Color(0xFF38977F) : const Color(0xFFE54A4A); // Green or Red

    // Format value as Currency or Percentage
    String formattedValue;
    if (data.title == 'Profit Margin') {
      formattedValue = '${(data.value * 100).toStringAsFixed(2)}%';
    } else {
      formattedValue = '\$${data.value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    }

    // Format change as Percentage
    final formattedChange = '${isPositive ? '+' : ''}${(data.change * 100).toStringAsFixed(1)}%';
    return Container(
      padding: EdgeInsets.only(left: 30.w, top: 10.h, bottom: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF141A25),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data.title,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[400]),
            ),
            SizedBox(height: 8.h),
            Text(
              formattedValue,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8.h),
            Text(
              formattedChange,
              style: TextStyle(fontSize: 14.sp, color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      
    );
  }
}

// --- 4. Chart Section ---

class ChartSection extends StatelessWidget {
  final BoxConstraints constraints;
  const ChartSection({required this.constraints, super.key});

  @override
  Widget build(BuildContext context) {
    // Breakpoint for switching from Row (desktop) to Column (mobile/tablet)
    bool isMobileLayout = constraints.maxWidth < 900;

    if (isMobileLayout) {
      return Column(
        children: const [
          RevenueChartCard(),
          SizedBox(height: 20),
          ExpensesChartCard(),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(child: RevenueChartCard()),
          SizedBox(width: 20),
          Expanded(child: ExpensesChartCard()),
        ],
      );
    }
  }
}

// --- Line Chart Card (Revenue vs. Profit Over Time) ---

class RevenueChartCard extends StatelessWidget {
  const RevenueChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141A25),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue vs. Profit Over Time',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          Text(
            'Last 30 Days +8.2%',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF38977F)),
          ),
          SizedBox(height: 16.h),
          // Placeholder for the Line Chart
          SizedBox(
            height: 250.h,
            child: CustomPaint(
              painter: LineChartPainter(),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for the Wavy Line Chart (Placeholder)
class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = const Color(0xFF285A9B) // Blue line color
      ..strokeWidth = 3.w
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = const Color(0xFF285A9B).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw a wavy path for the line chart
    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.3,
      size.width * 0.4,
      size.height * 0.9,
      size.width * 0.6,
      size.height * 0.4,
    );
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.1,
      size.width,
      size.height * 0.7,
      size.width,
      size.height * 0.7,
    );

    // Draw the fill area (under the curve)
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, wavePaint);

    // Draw simple Y-axis and X-axis lines (optional)
    final axisPaint = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 0.5.w;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axisPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- Donut Chart Card (Expenses by Category) ---

class ExpensesChartCard extends StatelessWidget {
  const ExpensesChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141A25),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expenses by Category',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 300;
              if (isMobile) {
                return Column(
                  children: [
                    // Donut Chart
                    SizedBox(
                      width: 120.w,
                      height: 190.w,
                      child: CustomPaint(
                        painter: DonutChartPainter(mockCategories),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Legend
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: mockCategories.map((category) => _buildLegendItem(category)).toList(),
                    ),
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Donut Chart
                    SizedBox(
                      width: 150.w,
                      height: 190.w,
                      child: CustomPaint(
                        painter: DonutChartPainter(mockCategories),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    // Legend
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: mockCategories.map((category) => _buildLegendItem(category)).toList(),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(CategoryData category) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: category.color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                category.name,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[300]),
              ),
            ],
          ),
          Text(
            '${(category.percentage * 100).toStringAsFixed(0)}%',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for the Donut Chart (Placeholder)
class DonutChartPainter extends CustomPainter {
  final List<CategoryData> data;
  DonutChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 30.0; // The thickness of the donut ring

    double startAngle = -math.pi / 2; // Start from 12 o'clock

    for (var item in data) {
      final sweepAngle = 2 * math.pi * item.percentage;
      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) => false;
}