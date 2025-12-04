import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// --- Mock Data Structures ---

class Customer {
  final String name;
  final String email;
  final String avatarUrl;
  final DateTime dateJoined;
  final double lifetimeValue;
  final String status;

  Customer({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.dateJoined,
    required this.lifetimeValue,
    required this.status,
  });
}

final List<Customer> mockCustomers = [
  Customer(
    name: 'Eleanor Vance',
    email: 'eleanor.v@example.com',
    avatarUrl: 'https://placehold.co/40x40/285A9B/FFFFFF?text=EV',
    dateJoined: DateTime(2023, 1, 15),
    lifetimeValue: 2450.00,
    status: 'Active',
  ),
  Customer(
    name: 'Marcus Thorne',
    email: 'm.thorne@example.com',
    avatarUrl: 'https://placehold.co/40x40/38977F/FFFFFF?text=MT',
    dateJoined: DateTime(2023, 2, 20),
    lifetimeValue: 1820.50,
    status: 'Active',
  ),
  Customer(
    name: 'Clara Oswald',
    email: 'clara.o@example.com',
    avatarUrl: 'https://placehold.co/40x40/E54A4A/FFFFFF?text=CO',
    dateJoined: DateTime(2023, 3, 10),
    lifetimeValue: 980.00,
    status: 'Suspended',
  ),
  Customer(
    name: 'Julian Frost',
    email: 'julian.f@example.com',
    avatarUrl: 'https://placehold.co/40x40/4E3A86/FFFFFF?text=JF',
    dateJoined: DateTime(2023, 4, 5),
    lifetimeValue: 5130.75,
    status: 'Active',
  ),
  Customer(
    name: 'Seraphina Moon',
    email: 'seraphina.m@example.com',
    avatarUrl: 'https://placehold.co/40x40/F5A623/FFFFFF?text=SM',
    dateJoined: DateTime(2023, 5, 21),
    lifetimeValue: 320.00,
    status: 'Pending',
  ),
];



// --- Status Indicator Widget ---

class StatusIndicator extends StatelessWidget {
  final String status;
  const StatusIndicator({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    Color textColor;

    switch (status) {
      case 'Active':
        dotColor = const Color(0xFF38977F); // Green
        textColor = const Color(0xFF38977F);
        break;
      case 'Suspended':
        dotColor = const Color(0xFFE54A4A); // Red
        textColor = const Color(0xFFE54A4A);
        break;
      case 'Pending':
        dotColor = const Color(0xFFF5A623); // Yellow/Orange
        textColor = const Color(0xFFF5A623);
        break;
      default:
        dotColor = Colors.grey;
        textColor = Colors.grey;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        SizedBox(width: 8.w),
        Text(
          status,
          style: TextStyle(
            fontSize: 14.sp,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// --- Main Screen Widget ---

class CustomerManagementScreen extends StatelessWidget {
  const CustomerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive padding: use a percentage of the screen width for horizontal padding
          final horizontalPadding = constraints.maxWidth * 0.04;
          // Set a minimum width for the table view to ensure proper scaling
          // Below this, the table will be scrollable horizontally.
          final minTableWidth = 1000.w;

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
                // 1. Header Section
                const HeaderSection(),
                SizedBox(height: 30.h),

                // 2. Toolbar (Search, Filter, Export)
                ToolbarSection(minTableWidth: minTableWidth),
                SizedBox(height: 20.h),

                // 3. Customer Data Table
                CustomerTable(minTableWidth: minTableWidth, constraints: constraints),
                SizedBox(height: 20.h),

                // 4. Pagination
                const PaginationSection(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Management',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 4.h),
            Text(
              'View, search, and manage customer accounts.',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[400]),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.add, size: 20.sp),
          label: Text('Add New Customer', style: TextStyle(fontSize: 16.sp)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF285A9B), // Blue background
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            elevation: 0,
          ),
        ),
      ],
    );
  }
}

// --- 2. Toolbar Section (Search, Filter, Export) ---

class ToolbarSection extends StatelessWidget {
  final double minTableWidth;
  const ToolbarSection({required this.minTableWidth, super.key});

  Widget _buildSearchField(double width) {
    return Container(
      width: width,
      height: 50.h,
      decoration: BoxDecoration(
        color: const Color(0xFF141A25),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade800, width: 1.w),
      ),
      child: TextField(
        style: TextStyle(fontSize: 16.sp, color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search by name, email, or ID...',
          hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, size: 24.sp, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141A25),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade800, width: 1.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: 'All', // Default value shown in the screenshot
          hint: Text(hint, style: TextStyle(fontSize: 16.sp, color: Colors.white)),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 24.sp),
          dropdownColor: const Color(0xFF141A25),
          items: const [
            DropdownMenuItem(value: 'All', child: Text('Status: All')),
            DropdownMenuItem(value: 'Active', child: Text('Status: Active')),
            DropdownMenuItem(value: 'Suspended', child: Text('Status: Suspended')),
            DropdownMenuItem(value: 'Pending', child: Text('Status: Pending')),
          ],
          onChanged: (String? newValue) {},
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildExportButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(Icons.download, size: 18.sp),
      label: Text('Export', style: TextStyle(fontSize: 16.sp)),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(0, 50.h),
        backgroundColor: const Color(0xFF141A25),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(color: Colors.grey.shade800, width: 1.w),
        ),
        elevation: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search bar takes up most of the space
        Expanded(
          child: _buildSearchField(minTableWidth * 0.4),
        ),
        SizedBox(width: 16.w),
        // Filter dropdown
        _buildDropdown('Status: All'),
        SizedBox(width: 16.w),
        // Export button
        _buildExportButton(),
      ],
    );
  }
}

// --- 3. Customer Data Table ---

class CustomerTable extends StatelessWidget {
  final double minTableWidth;
  final BoxConstraints constraints;
  const CustomerTable({
    required this.minTableWidth,
    required this.constraints,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the width of the table content.
    // Use the maximum width between the available screen width and the minimum required table width.
    double tableContentWidth = constraints.maxWidth < minTableWidth
        ? minTableWidth - (constraints.maxWidth * 0.08) // Account for padding
        : constraints.maxWidth - (constraints.maxWidth * 0.08);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141A25),
        borderRadius: BorderRadius.circular(12.r),
      ),
      // Use SingleChildScrollView for horizontal scrolling if the screen is too narrow
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: tableContentWidth),
          child: DataTable(
            // Adjust density for visual appearance
            columnSpacing: 30.w,
            dataRowMinHeight: 70.h,
            dataRowMaxHeight: 70.h,
            headingRowHeight: 50.h,
            // Header Styling
            headingRowColor: MaterialStateProperty.all(const Color(0xFF141A25)),
            headingTextStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[400],
            ),
            // Data Row Styling
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey.shade800, width: 1.w),
              top: BorderSide(color: Colors.grey.shade800, width: 1.w), // Top border for header
            ),

            columns: [
              DataColumn(label: Container(width: 24.w, child: Checkbox(value: false, onChanged: (v) {}))),
              DataColumn(
                label: Text('CUSTOMER NAME', style: TextStyle(fontSize: 14.sp)),
              ),
              DataColumn(
                label: Text('DATE JOINED', style: TextStyle(fontSize: 14.sp)),
              ),
              DataColumn(
                label: Text('LIFETIME VALUE', style: TextStyle(fontSize: 14.sp)),
              ),
              DataColumn(
                label: Text('STATUS', style: TextStyle(fontSize: 14.sp)),
              ),
              DataColumn(
                label: Text('ACTIONS', style: TextStyle(fontSize: 14.sp)),
              ),
            ],
            rows: mockCustomers.map((customer) {
              return DataRow(
                cells: [
                  DataCell(Checkbox(value: false, onChanged: (v) {})),
                  DataCell(
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundImage: NetworkImage(customer.avatarUrl),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              customer.name,
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                            Text(
                              customer.email,
                              style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DataCell(Text(
                    '${customer.dateJoined.year}-${customer.dateJoined.month.toString().padLeft(2, '0')}-${customer.dateJoined.day.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  )),
                  DataCell(Text(
                    '\$${customer.lifetimeValue.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  )),
                  DataCell(StatusIndicator(status: customer.status)),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.more_horiz, size: 24.sp, color: Colors.grey[500]),
                      onPressed: () {
                        // Handle actions
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// --- 4. Pagination Section ---

class PaginationSection extends StatelessWidget {
  const PaginationSection({super.key});

  Widget _buildPageButton(String text, bool isActive) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF285A9B) : const Color(0xFF141A25),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: isActive ? const Color(0xFF285A9B) : Colors.grey.shade800, width: 1.w),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing 1 to 5 of 20 results',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey[400]),
        ),
        Row(
          children: [
            // Previous button (Disabled)
            Container(
              width: 40.w,
              height: 40.w,
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: const Color(0xFF141A25),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade800, width: 1.w),
              ),
              child: Icon(Icons.keyboard_arrow_left, size: 24.sp, color: Colors.grey[600]),
            ),

            // Next button (Active)
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFF141A25),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade800, width: 1.w),
              ),
              child: Icon(Icons.keyboard_arrow_right, size: 24.sp, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}