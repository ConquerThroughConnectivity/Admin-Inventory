import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentOrdersTable extends StatelessWidget {
  const RecentOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1C242E),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recent Orders",
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              Text("View All Orders",
                  style: TextStyle(fontSize: 14.sp, color: Colors.blue)),
            ],
          ),

          SizedBox(height: 20.h),

          DataTable(
            headingTextStyle:
                TextStyle(color: Colors.white70, fontSize: 14.sp),
            columns: [
              DataColumn(label: Text("Order ID")),
              DataColumn(label: Text("Customer")),
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Amount")),
              DataColumn(label: Text("Status")),
            ],
            rows: [
              _row("#12548", "John Doe", "2 min ago", "\$128.50", Colors.green),
              _row("#12547", "Jane Smith", "15 min ago", "\$45.00", Colors.blue),
              _row("#12546", "Mike Johnson", "1 hour ago", "\$250.00", Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  DataRow _row(String id, String name, String date, String amount, Color color) {
    return DataRow(cells: [
      DataCell(Text(id)),
      DataCell(Text(name)),
      DataCell(Text(date)),
      DataCell(Text(amount)),
      DataCell(Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          color == Colors.green
              ? "Completed"
              : color == Colors.blue
                  ? "Shipped"
                  : "Pending",
          style: TextStyle(color: color, fontSize: 12.sp),
        ),
      )),
    ]);
  }
}
