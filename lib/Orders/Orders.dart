import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(

      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            isMobile ? _mobileHeader() : _desktopHeader(),

            SizedBox(height: 30.h),

            /// SEARCH + FILTERS
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                
                color: const Color(0xFF1C242E),
                borderRadius: BorderRadius.circular(18.r),
                
              ),
              child: Column(
                children: [
                  isMobile ? _mobileFilters() : _desktopFilters(),

                  SizedBox(height: 20.h),

                  /// TABLE
                  _ordersTable(context),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            /// PAGINATION
            _pagination(),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // RESPONSIVE HEADERS
  // -------------------------------------------------------------
  Widget _desktopHeader() {
    return Row(
      children: [
        Text(
          "Order Management",
          style: TextStyle(
            color: Colors.white,
            fontSize: 34.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        _blueButton("New Order"),
      ],
    );
  }

  Widget _mobileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order Management",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Align(
          alignment: Alignment.centerRight,
          child: _blueButton("New Order"),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // FILTERS
  // -------------------------------------------------------------
  Widget _desktopFilters() {
    return Row(
      children: [
        Expanded(child: _searchBar()),
        SizedBox(width: 20.w),
        _filterButton("Status"),
        SizedBox(width: 12.w),
        _filterButton("Date Range"),
      ],
    );
  }

  Widget _mobileFilters() {
    return Column(
      children: [
        _searchBar(),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _filterButton("Status")),
            SizedBox(width: 12.w),
            Expanded(child: _filterButton("Date Range")),
          ],
        ),
      ],
    );
  }

  // SEARCH FIELD
  Widget _searchBar() {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white54),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: "Search by Order ID, Customer Name...",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // FILTER BUTTON
  Widget _filterButton(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
          SizedBox(width: 6.w),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
        ],
      ),
    );
  }

  // BLUE BUTTON
  Widget _blueButton(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.add, color: Colors.white),
          SizedBox(width: 6.w),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // ORDERS TABLE
  // -------------------------------------------------------------
  Widget _ordersTable(BuildContext context) {
    return Container(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (_, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 900.w),
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  Colors.white.withOpacity(0.04),
                ),
                columns: [
                  _col("Order ID"),
                  _col("Customer"),
                  _col("Date"),
                  _col("Total"),
                  _col("Status"),
                  _col("Actions"),
                ],
                rows: _sampleRows(),
              ),
            ),
          );
        },
      ),
    );
  }

  DataColumn _col(String label) {
    return DataColumn(
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<DataRow> _sampleRows() {
    return [
      _row("#OD78652", "Liam Johnson", "Oct 12, 2023", "\$124.50", "Delivered"),
      _row("#OD78651", "Olivia Smith", "Oct 11, 2023", "\$89.99", "Shipped"),
      _row("#OD78650", "Noah Williams", "Oct 11, 2023", "\$250.00", "Pending"),
      _row("#OD78649", "Emma Brown", "Oct 10, 2023", "\$32.10", "Cancelled"),
      _row("#OD78648", "Ava Jones", "Oct 9, 2023", "\$199.95", "Delivered"),
    ];
  }

  DataRow _row(
    String orderID,
    String customer,
    String date,
    String total,
    String status,
  ) {
    return DataRow(cells: [
      _cell(orderID),
      _cell(customer),
      _cell(date),
      _cell(total),
      DataCell(_statusBadge(status)),
      const DataCell(Icon(Icons.more_vert, color: Colors.white70)),
    ]);
  }

  DataCell _cell(String value) {
    return DataCell(
      Text(
        value,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  // STATUS COLORS
  Widget _statusBadge(String status) {
    Color bg;
    Color text;

    switch (status) {
      case "Delivered":
        bg = const Color(0xFF16A34A);
        text = Colors.white;
        break;
      case "Shipped":
        bg = const Color(0xFF1D4ED8);
        text = Colors.white;
        break;
      case "Pending":
        bg = const Color(0xFFF59E0B);
        text = Colors.black;
        break;
      default: // Cancelled
        bg = const Color(0xFFB91C1C);
        text = Colors.white;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: TextStyle(color: text, fontSize: 12.sp),
      ),
    );
  }

  // -------------------------------------------------------------
  // PAGINATION
  // -------------------------------------------------------------
  Widget _pagination() {
    return Row(
      children: [
        Text(
          "Showing 1 to 5 of 20 results",
          style: TextStyle(
            color: Colors.white54,
            fontSize: 14.sp,
          ),
        ),
        const Spacer(),
        _pageBtn(Icons.arrow_left),
        SizedBox(width: 6.w),
        _pageNumber(1, selected: true),
        _pageNumber(2),
        _pageNumber(3),
        SizedBox(width: 6.w),
        _pageBtn(Icons.arrow_right),
      ],
    );
  }

  Widget _pageBtn(IconData icon) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _pageNumber(int num, {bool selected = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF2563EB) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        "$num",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
