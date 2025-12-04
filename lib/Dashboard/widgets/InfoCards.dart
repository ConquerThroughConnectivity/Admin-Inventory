import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoCards extends StatelessWidget {
  const InfoCards({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 1000;
        return isWide
            ? Row(
                children: [
                  Expanded(child: _card("Total Revenue", "\$125,640", "+12.5%", Colors.green)),
                  SizedBox(width: 16.w),
                  Expanded(child: _card("Total Orders Today", "1,205", "-2.1%", Colors.red)),
                  SizedBox(width: 16.w),
                  Expanded(child: _card("New Customers", "89", "+5.0%", Colors.green)),
                  SizedBox(width: 16.w),
                  Expanded(child: _card("Low in Stock", "12", "", Colors.orange)),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _card("Total Revenue", "\$125,640", "+12.5%", Colors.green),
                  SizedBox(height: 16.h),
                  _card("Total Orders Today", "1,205", "-2.1%", Colors.red),
                  SizedBox(height: 16.h),
                  _card("New Customers", "89", "+5.0%", Colors.green),
                  SizedBox(height: 16.h),
                  _card("Low in Stock", "12", "", Colors.orange),
                ],
              );
      },
    );
  }

  Widget _card(String title, String value, String change, Color changeColor) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1C242E),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 16.sp, color: Colors.white70)),
          SizedBox(height: 10.h),
          Text(value,
              style: TextStyle(
                  fontSize: 28.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 6.h),
          Text(change,
              style: TextStyle(fontSize: 14.sp, color: changeColor)),
        ],
      ),
    );
  }
}
