import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dashboard",
                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.h),
            Text("Welcome back, Admin!",
                style: TextStyle(fontSize: 16.sp, color: Colors.white70)),
          ],
        ),

        const Spacer(),

        //* Search box
        Container(
          width: 280.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F25),
            borderRadius: BorderRadius.circular(10.r),
          ),
          height: 60.h,
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.white54, size: 20.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 20.w),

        Icon(Icons.notifications_none, size: 26.sp, color: Colors.white70),
        SizedBox(width: 20.w),

        CircleAvatar(
          radius: 22.r,
          backgroundColor: Colors.blue,
          child: Text("A", style: TextStyle(fontSize: 18.sp)),
        ),
      ],
    );
  }
}
