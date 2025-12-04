import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SidebarMenu extends StatefulWidget {
  final Function(int)? onMenuItemTapped;
  
  const SidebarMenu({super.key, this.onMenuItemTapped});

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230.w,
      color: const Color(0xFF0A0E14),
      child: Column(
        children: [
          SizedBox(height: 30.h),
          Text("Store Admin",
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 30.h),

          _menuItem(Icons.dashboard, "Dashboard", 0),
          _menuItem(Icons.bar_chart, "Sales", 1),
          _menuItem(Icons.shopping_bag, "Orders", 2),
          _menuItem(Icons.inventory, "Inventory", 3),
          _menuItem(Icons.category, "Products", 4),
          _menuItem(Icons.people, "Customers", 5),
          _menuItem(Icons.receipt_long, "Reports", 6),

          const Spacer(),
          _menuItem(Icons.settings, "Settings", 7),
          _menuItem(Icons.logout, "Logout", 8),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String text, int index) {
    bool isActive = activeIndex == index;
    return InkWell(
      onTap: (){
        setState(() {
          activeIndex = index;
        });
        widget.onMenuItemTapped?.call(index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1C2B3A) : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: SizedBox(
          width: 170.w,
          child: Row(
            children: [
              Icon(icon, color: isActive ? Colors.blue : Colors.white70, size: 20.sp),
              SizedBox(width: 12.w),
              Text(text, style: TextStyle(fontSize: 14.sp, color: isActive ? Colors.blue : Colors.white, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }
}
