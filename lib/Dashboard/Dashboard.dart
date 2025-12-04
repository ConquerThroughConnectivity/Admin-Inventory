import 'package:adminiventory/Customer/Customer.dart';
import 'package:adminiventory/Dashboard/dshboard_screen.dart';
import 'package:adminiventory/Dashboard/widgets/Chart.dart';
import 'package:adminiventory/Dashboard/widgets/Header.dart';
import 'package:adminiventory/Dashboard/widgets/InfoCards.dart';
import 'package:adminiventory/Dashboard/widgets/Recentorders.dart';
import 'package:adminiventory/Dashboard/widgets/TopSelling.dart';
import 'package:adminiventory/Dashboard/widgets/sidemenu.dart';
import 'package:adminiventory/Inventory/Inventory.dart';
import 'package:adminiventory/Orders/Orders.dart';
import 'package:adminiventory/Products/Products.dart';
import 'package:adminiventory/Report/Report.dart';
import 'package:adminiventory/Sales/Sales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onMenuItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Menu
          SidebarMenu(onMenuItemTapped: _onMenuItemTapped),

          // Page View Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                // Page changed, update sidebar if needed
              },
              children: [
                // Dashboard Page
                _buildDashboardPage(),
                // Sales Page
                _buildSalesPage(),
                // Orders Page
                _buildOrdersPage(),
                // Inventory Page
                _buildInventoryPage(),
                // Products Page
                _buildProductsPage(),
                // Customers Page
                _buildCustomersPage(),
                // Reports Page
                _buildReportsPage(),
                // Settings Page
                _buildSettingsPage(),
                // Logout Page (placeholder)
                _buildLogoutPage(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDashboardPage() {
    // return DashboardMainScreen();
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardHeader(),
          SizedBox(height: 20.h),
          const InfoCards(),
          SizedBox(height: 20.h),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1100) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: const SalesChart()),
                    SizedBox(width: 20.w),
                    Expanded(flex: 1, child: const TopSellingItems()),
                  ],
                );
              }
              return Column(
                children: const [
                  SalesChart(),
                  SizedBox(height: 20),
                  TopSellingItems(),
                ],
              );
            },
          ),
          SizedBox(height: 20.h),
          const RecentOrdersTable(),
        ],
      ),
    );
  }

  Widget _buildSalesPage() {
    return SalesReportScreen();
  }

  Widget _buildOrdersPage() {
    return OrderManagementScreen();
  }

  Widget _buildInventoryPage() {
    return InventoryDashboardScreen();
  }

  Widget _buildProductsPage() {
    return ManageItemsScreen();
  }

  Widget _buildCustomersPage() {
    return CustomerManagementScreen();
  }

  Widget _buildReportsPage() {
    return FinancialReportsScreen();
  }

  Widget _buildSettingsPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Settings",
              style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1C242E),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: Text("Settings content coming soon",
                  style: TextStyle(fontSize: 18.sp, color: Colors.white70)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, size: 64.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text("Logout",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          Text("Click to confirm logout",
              style: TextStyle(fontSize: 16.sp, color: Colors.white70)),
        ],
      ),
    );
  }
}
