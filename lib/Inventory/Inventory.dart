import 'package:adminiventory/Products/AddItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// --- Mock Data ---

class InventoryItem {
  final String name;
  final String sku;
  final String category;
  final int quantity;
  final String status;
  final String lastUpdated;
  final String imageUrl;

  InventoryItem({
    required this.name,
    required this.sku,
    required this.category,
    required this.quantity,
    required this.status,
    required this.lastUpdated,
    required this.imageUrl,
  });
}

final List<InventoryItem> mockInventory = [
  InventoryItem(
    name: "Organic Green Tea",
    sku: "SKU-12345",
    category: "Beverages",
    quantity: 150,
    status: "In Stock",
    lastUpdated: "2023-10-26",
    imageUrl: "https://placehold.co/50x50/388e3c/ffffff?text=Tea",
  ),
  InventoryItem(
    name: "Sourdough Bread",
    sku: "SKU-67890",
    category: "Bakery",
    quantity: 45,
    status: "Low Stock",
    lastUpdated: "2023-10-25",
    imageUrl: "https://placehold.co/50x50/fbc02d/ffffff?text=Bread",
  ),
  InventoryItem(
    name: "Dark Chocolate Bar",
    sku: "SKU-10112",
    category: "Confectionery",
    quantity: 200,
    status: "In Stock",
    lastUpdated: "2023-10-25",
    imageUrl: "https://placehold.co/50x50/4e342e/ffffff?text=Choc",
  ),
  InventoryItem(
    name: "Olive Oil",
    sku: "SKU-13141",
    category: "Pantry",
    quantity: 0,
    status: "Out of Stock",
    lastUpdated: "2023-10-24",
    imageUrl: "https://placehold.co/50x50/1b5e20/ffffff?text=Oil",
  ),
];

class InventoryDashboardScreen extends StatelessWidget {
  const InventoryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Define a breakpoint for switching between desktop and mobile layout
          if (constraints.maxWidth > 900) {
            return const DesktopLayout();
          } else {
            // For narrow screens (mobile/tablet), you might use a Drawer
            // For this example, we'll just show the content without the side menu
            return const MobileLayout();
          }
        },
      ),
    );
  }
}

// --- Desktop Layout (Sidebar + Content) ---

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Side Menu - Fixed width based on ScreenUtil (e.g., 250 units wide)

        // Main Content Area - Takes remaining space
        const Expanded(child: MainContent()),
      ],
    );
  }
}

// --- Mobile Layout (Content Only) ---

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContent(isMobile: true);
  }
}

// --- Side Menu Widget ---

// --- Main Content Widget ---

class MainContent extends StatelessWidget {
  final bool isMobile;
  const MainContent({this.isMobile = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title and Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Inventory Management",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddNewItemScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.add, size: 18.sp),
                label: Text('Add New Item', style: TextStyle(fontSize: 14.sp)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF285A9B),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Search and Filter Controls
          const HeaderControls(),
          SizedBox(height: 24.h),

          // Inventory Table
          const InventoryTable(),

          SizedBox(height: 20.h),
          // Footer / Pagination
          const TableFooter(),
        ],
      ),
    );
  }
}

// --- Header Controls (Search and Dropdowns) ---

class HeaderControls extends StatelessWidget {
  const HeaderControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      alignment: WrapAlignment.start,
      children: [
        // Search Bar (takes up more space)
        SizedBox(
          width: 350.w, // Specific width for the search bar
          child: TextField(
            style: TextStyle(fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: 'Search by name or SKU...',
              hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              prefixIcon: Icon(
                Icons.search,
                size: 20.sp,
                color: Colors.grey[600],
              ),
              filled: true,
              fillColor: const Color(0xFF232D3B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 10.w,
              ),
            ),
          ),
        ),

        // Filter Dropdowns
        _buildFilterDropdown('Status: All', Icons.arrow_drop_down),
        _buildFilterDropdown('Category', Icons.arrow_drop_down),
        _buildFilterDropdown('Supplier', Icons.arrow_drop_down),
      ],
    );
  }

  Widget _buildFilterDropdown(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF232D3B),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: null,
          hint: Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[300]),
          ),
          icon: Icon(icon, color: Colors.grey[300], size: 20.sp),
          dropdownColor: const Color(0xFF232D3B),
          style: TextStyle(fontSize: 14.sp, color: Colors.white),
          items: const [], // Placeholder items
          onChanged: (String? newValue) {},
        ),
      ),
    );
  }
}

// --- Inventory Table Widget ---

class InventoryTable extends StatelessWidget {
  const InventoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141A25), // Inner dark background for the table
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        children: [
          // Table Header
          _buildTableHeader(context),
          SizedBox(height: 8.h),
          // Table Rows
          ...mockInventory.map((item) => ProductRow(item: item)).toList(),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final style = TextStyle(
      fontSize: 12.sp,
      color: Colors.grey[500],
      fontWeight: FontWeight.w600,
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          // Checkbox (Placeholder)
          SizedBox(width: 30.w),
          Expanded(flex: 3, child: Text('PRODUCT NAME', style: style)),
          Expanded(flex: 1, child: Text('SKU', style: style)),
          Expanded(flex: 1, child: Text('CATEGORY', style: style)),
          Expanded(flex: 1, child: Text('QUANTITY', style: style)),
          Expanded(flex: 1, child: Text('STATUS', style: style)),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('LAST UPDATED', style: style),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Single Product Row Widget ---

class ProductRow extends StatelessWidget {
  final InventoryItem item;
  const ProductRow({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(
          0xFF1B232F,
        ), // Slightly lighter background for the row
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          // Checkbox
          Checkbox(
            value: false,
            onChanged: (val) {},
            fillColor: MaterialStateProperty.resolveWith(
              (states) => Colors.grey[700],
            ),
          ),
          // Product Name with Image
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Image.network(
                  "https://placehold.co/50x50/4e342e/ffffff?text=Choc",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey,
                      child: Icon(Icons.image_not_supported),
                    );
                  },
                ),
                // Container(

                //   decoration: BoxDecoration(
                //   image: DecorationImage(
                //     fit: BoxFit.cover,
                //     scale: 5.0,
                //     image: NetworkImage(item.imageUrl,))
                // ),),
                SizedBox(width: 12.w),
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // SKU
          Expanded(
            flex: 1,
            child: Text(
              item.sku,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          ),
          // Category
          Expanded(
            flex: 1,
            child: Text(
              item.category,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          ),
          // Quantity
          Expanded(
            flex: 1,
            child: Text(
              item.quantity.toString(),
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
          ),
          // Status Badge
          Expanded(flex: 1, child: StatusBadge(status: item.status)),
          // Last Updated
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                item.lastUpdated,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Status Indicator Badge ---

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    Color textColor;
    Color bgColor;

    switch (status) {
      case 'In Stock':
        dotColor = Colors.lightGreenAccent;
        textColor = Colors.lightGreenAccent;
        bgColor = Colors.green.shade900.withOpacity(0.4);
        break;
      case 'Low Stock':
        dotColor = Colors.orangeAccent;
        textColor = Colors.orangeAccent;
        bgColor = Colors.orange.shade900.withOpacity(0.4);
        break;
      case 'Out of Stock':
      default:
        dotColor = Colors.redAccent;
        textColor = Colors.redAccent;
        bgColor = Colors.red.shade900.withOpacity(0.4);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          SizedBox(width: 6.w),
          Text(
            status,
            style: TextStyle(
              fontSize: 12.sp,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Table Footer (Pagination) ---

class TableFooter extends StatelessWidget {
  const TableFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing 1 to 4 of 2,390 results',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
        Row(
          children: [
            _buildPaginationButton(
              context,
              Icons.chevron_left,
              isActive: false,
            ),
            _buildPaginationButton(context, null, text: '1', isActive: true),
            _buildPaginationButton(context, null, text: '2'),
            _buildPaginationButton(context, null, text: '3'),
            _buildPaginationButton(context, null, text: '...'),
            _buildPaginationButton(context, null, text: '24'),
            _buildPaginationButton(
              context,
              Icons.chevron_right,
              isActive: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaginationButton(
    BuildContext context,
    IconData? icon, {
    String? text,
    bool isActive = false,
  }) {
    return Container(
      width: 36.w,
      height: 36.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF285A9B) : const Color(0xFF141A25),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8.r),
          child: Center(
            child: icon != null
                ? Icon(
                    icon,
                    color: isActive ? Colors.white : Colors.grey[400],
                    size: 20.sp,
                  )
                : Text(
                    text!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isActive ? Colors.white : Colors.grey[300],
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
