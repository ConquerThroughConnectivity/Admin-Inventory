import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopSellingItems extends StatelessWidget {
  const TopSellingItems({super.key});

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
          Text("Top Selling Items",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 16.h),
          _item("Modern Black T-Shirt", "1,230"),
          _item("Classic Blue Jeans", "980"),
          _item("Leather Wallet", "750"),
          _item("Running Sneakers", "610"),
          _item("Sunglasses", "420"),
        ],
      ),
    );
  }

  Widget _item(String name, String sold) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        children: [
          Expanded(
            child: Text(name,
                style: TextStyle(fontSize: 15.sp, color: Colors.white70)),
          ),
          Text("$sold sold",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
