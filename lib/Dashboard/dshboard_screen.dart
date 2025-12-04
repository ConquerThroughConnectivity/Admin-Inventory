import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart'; // Used for the Line Chart

// --- Main Application Setup ---



// --- Status Indicator Widget ---

class StatusIndicator extends StatelessWidget {
  final String status;
  const StatusIndicator({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    Color dotColor;

    switch (status) {
      case 'Completed':
        dotColor = const Color(0xFF38977F); // Green
        break;
      case 'Striped': // Assuming 'Striped' is a typo and should be a different status like 'Shipped' or 'Processing'
      case 'Shipped':
        dotColor = const Color(0xFF285A9B); // Blue
        break;
      case 'Pending':
        dotColor = const Color(0xFFF5A623); // Yellow/Orange
        break;
      default:
        dotColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: dotColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 14.sp,
          color: dotColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// --- Main Screen Widget ---

class DashboardMainScreen extends StatelessWidget {
  const DashboardMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive padding: uses a percentage of the screen width for horizontal padding
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
                // 1. Header and Nav Bar
                const TopHeaderBar(),
                SizedBox(height: 30.h),

                // 2. Main Responsive Grid Content
                DashboardGrid(constraints: constraints),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- 1. Top Header Bar (Title, Search, Admin) ---

class TopHeaderBar extends StatelessWidget {
  const TopHeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Welcome back, Admin!',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[400]),
                ),
              ],
            ),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.palette_outlined, size: 20.sp, color: Colors.grey[400]),
                  label: Text('Customize', style: TextStyle(fontSize: 16.sp, color: Colors.grey[400])),
                ),
                SizedBox(width: 20.w),
                // Search Bar
                Container(
                  width: 200.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF28303C),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextField(
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                      prefixIcon: Icon(Icons.search, size: 18.sp, color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                Icon(Icons.notifications_none, size: 24.sp, color: Colors.grey[400]),
                SizedBox(width: 20.w),
                // Admin Profile
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.grey.shade700,
                      child: Text('AD', style: TextStyle(fontSize: 14.sp)),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admin Name', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                        Text('Administrator', style: TextStyle(fontSize: 12.sp, color: Colors.grey[500])),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Divider(color: Colors.grey.shade800, height: 40.h),
      ],
    );
  }
}

// --- 2. Main Responsive Grid Layout ---

class DashboardGrid extends StatelessWidget {
  final BoxConstraints constraints;
  const DashboardGrid({required this.constraints, super.key});

  @override
  Widget build(BuildContext context) {
    // Determine the layout based on screen width
    // Desktop: 4 columns for stats, 2 columns for main content
    // Tablet: 2 columns for stats, 1 column for main content
    // Mobile: 1 column for everything

    int getCrossAxisCount(double width) {
      if (width > 1200) return 4; // Large desktop: 4 stat cards per row
      if (width > 768) return 2; // Tablet: 2 stat cards per row
      return 1; // Mobile: 1 card per row
    }

    // Determine the aspect ratio (height / width) of grid items
    // Wider screens use taller cards for stats
    double getChildAspectRatio(double width) {
      if (width > 1200) return 2.8;
      if (width > 768) return 2.8;
      return 3.5;
    }

    final int statColumns = getCrossAxisCount(constraints.maxWidth);
    final double aspectRatio = getChildAspectRatio(constraints.maxWidth);

    return Column(
      children: [
        // A. Stats Cards (Using GridView.builder)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4, // Total Revenue, Total Orders, New Customers, Low in Stock
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: statColumns,
            crossAxisSpacing: 20.w,
            mainAxisSpacing: 20.h,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            return StatCard(index: index);
          },
        ),
        SizedBox(height: 30.h),

        // B. Sales Overview and Top Selling Items (Dynamic Column/Row)
        if (constraints.maxWidth > 768)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: SalesOverviewCard()), // Line Chart
              SizedBox(width: 30.w),
              Expanded(flex: 1, child: TopSellingCard()), // Top Selling
            ],
          )
        else
          Column(
            children: [
              SalesOverviewCard(),
              SizedBox(height: 30.h),
              TopSellingCard(),
            ],
          ),
        SizedBox(height: 30.h),

        // C. Recent Orders Table (Full Width)
        const RecentOrdersCard(),
      ],
    );
  }
}

// --- Shared Card Component ---

class CustomCard extends StatelessWidget {
  final String title;
  final Widget child;
  final bool hasMenu;

  const CustomCard({
    required this.title,
    required this.child,
    this.hasMenu = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF28303C),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              if (hasMenu) Icon(Icons.more_vert, size: 24.sp, color: Colors.grey[500]),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

// --- A. Stat Card ---

class StatCard extends StatelessWidget {
  final int index;
  const StatCard({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for the 4 stat cards
    final List<Map<String, dynamic>> stats = [
      {
        'title': 'Total Revenue',
        'value': '\$125,640',
        'change': '+12.5%',
        'period': 'vs last month',
        'icon': Icons.monetization_on_outlined,
        'changeColor': const Color(0xFF38977F),
      },
      {
        'title': 'Total Orders Today',
        'value': '1,205',
        'change': '-2.1%',
        'period': 'vs yesterday',
        'icon': Icons.shopping_cart_outlined,
        'changeColor': const Color(0xFFE54A4A),
      },
      {
        'title': 'New Customers',
        'value': '89',
        'change': '+5.0%',
        'period': 'this month',
        'icon': Icons.person_add_alt_outlined,
        'changeColor': const Color(0xFF38977F),
      },
      {
        'title': 'Low in Stock',
        'value': '12',
        'change': 'A items need restock',
        'period': '',
        'icon': Icons.inventory_2_outlined,
        'changeColor': Colors.white, // No change color needed for this text
        'isWarning': true,
      },
    ];

    final stat = stats[index];
    final bool isWarning = stat['isWarning'] ?? false;

    return Container(
      padding: EdgeInsets.all(20.w),

      decoration: BoxDecoration(
        color: isWarning ? const Color(0xFF28303C).withOpacity(0.9) : const Color(0xFF28303C),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  stat['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                ),
              ),
              SizedBox(width: 8.w),
              Icon(stat['icon'], size: 20.sp, color: Colors.grey[400]),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            stat['value'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  stat['change'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isWarning ? Colors.yellow : stat['changeColor'],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (!isWarning) ...[
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    stat['period'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}

// --- B. Sales Overview Card (Chart) ---

class SalesOverviewCard extends StatelessWidget {
  const SalesOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Sales Overview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$89,450',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10.w),
              Text(
                '8.2%',
                style: TextStyle(fontSize: 16.sp, color: const Color(0xFF38977F), fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 10.w),
              Text(
                'Last 30 Days',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Placeholder for the Line Chart
          SizedBox(
            height: 250.h,
            child: LineChartWidget(),
          ),
        ],
      ),
    );
  }
}

// --- Line Chart Widget (using fl_chart) ---

class LineChartWidget extends StatelessWidget {
  LineChartWidget({super.key});

  final List<Color> gradientColors = [
    const Color(0xFF285A9B),
    const Color(0xFF285A9B).withOpacity(0.0),
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
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
    );
  }
}

// --- B. Top Selling Items Card ---

class TopSellingCard extends StatelessWidget {
  const TopSellingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topItems = [
      {'name': 'Modern Black T-Shirt', 'sold': '1,230 sold'},
      {'name': 'Classic Blue Jeans', 'sold': '980 sold'},
      {'name': 'Leather Wallet', 'sold': '750 sold'},
      {'name': 'Running Sneakers', 'sold': '610 sold'},
      {'name': 'Sunglasses', 'sold': '420 sold'},
    ];

    return CustomCard(
      title: 'Top Selling Items',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...topItems.map((item) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['name']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      item['sold']!,
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey[500]),
                    ),
                  ],
                ),
              )),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: TextStyle(fontSize: 16.sp, color: const Color(0xFF285A9B)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- C. Recent Orders Table ---

class RecentOrdersCard extends StatelessWidget {
  const RecentOrdersCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orders = [
      {'id': '#12548', 'customer': 'John Doe', 'date': '2 min ago', 'amount': '\$128.50', 'status': 'Completed'},
      {'id': '#12547', 'customer': 'Jane Smith', 'date': '15 min ago', 'amount': '\$45.00', 'status': 'Striped'},
      {'id': '#12546', 'customer': 'Mike Johnson', 'date': '1 hour ago', 'amount': '\$250.00', 'status': 'Pending'},
    ];

    return CustomCard(
      title: 'Recent Orders',
      hasMenu: true,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All Orders',
                  style: TextStyle(fontSize: 16.sp, color: const Color(0xFF285A9B)),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade800)),
            ),
            child: Row(
              children: [
                _buildTableHeader('ORDER ID', flex: 1),
                _buildTableHeader('CUSTOMER', flex: 2),
                _buildTableHeader('DATE', flex: 1),
                _buildTableHeader('AMOUNT', flex: 1),
                _buildTableHeader('STATUS', flex: 1),
              ],
            ),
          ),
          // Table Rows
          ...orders.map((order) => Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Row(
                  children: [
                    _buildTableData(order['id']!, flex: 1, isBold: true),
                    _buildTableData(order['customer']!, flex: 2),
                    _buildTableData(order['date']!, flex: 1, color: Colors.grey[500]),
                    _buildTableData(order['amount']!, flex: 1, isBold: true),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: StatusIndicator(status: order['status']!),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildTableData(String text, {int flex = 1, Color? color, bool isBold = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          color: color ?? Colors.white,
          fontWeight: isBold ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }
}