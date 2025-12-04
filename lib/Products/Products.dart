import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'AddItem.dart';

// --- Mock Data ---

class InventoryItem {
  final String id;
  final String name;
  final String sku;
  final String category;
  final double price;
  final int stock;
  final String status;
  final String imageUrl;

  InventoryItem({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.price,
    required this.stock,
    required this.status,
    required this.imageUrl,
  });
}

final List<InventoryItem> mockInventory = [
  InventoryItem(
    id: '1',
    name: "ErgoChair Pro+",
    sku: "SKU-84321",
    category: "Furniture",
    price: 699.00,
    stock: 150,
    status: "Active",
    imageUrl: "https://placehold.co/50x50/3e79e6/ffffff?text=Chair",
  ),
  InventoryItem(
    id: '2',
    name: "TypeMaster Elite",
    sku: "SKU-91234",
    category: "Electronics",
    price: 189.99,
    stock: 85,
    status: "Active",
    imageUrl: "https://placehold.co/50x50/6c757d/ffffff?text=Key",
  ),
  InventoryItem(
    id: '3',
    name: "AcousticBliss 3",
    sku: "SKU-56789",
    category: "Electronics",
    price: 349.00,
    stock: 4,
    status: "Low Stock",
    imageUrl: "https://placehold.co/50x50/00bfa5/ffffff?text=Head",
  ),
  InventoryItem(
    id: '4',
    name: "Classic Journal",
    sku: "SKU-11223",
    category: "Stationery",
    price: 25.50,
    stock: 0,
    status: "Out of Stock",
    imageUrl: "https://placehold.co/50x50/e9c46a/ffffff?text=Book",
  ),
  InventoryItem(
    id: '5',
    name: "FlexiDesk Max",
    sku: "SKU-44556",
    category: "Furniture",
    price: 850.00,
    stock: 210,
    status: "Archived",
    imageUrl: "https://placehold.co/50x50/f4a261/ffffff?text=Desk",
  ),
];



// --- Main Screen (Stateful to handle inline editing) ---

class ManageItemsScreen extends StatefulWidget {
  const ManageItemsScreen({super.key});

  @override
  State<ManageItemsScreen> createState() => _ManageItemsScreenState();
}

class _ManageItemsScreenState extends State<ManageItemsScreen> {
  // Holds the ID of the item currently being edited. Null means no item is being edited.
  String? _editingItemId;

  void _startEdit(String itemId) {
    setState(() {
      _editingItemId = itemId;
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingItemId = null;
    });
    // In a real app, you might also reset form data here
  }

  @override
  Widget build(BuildContext context) {
    // We use a LayoutBuilder for responsiveness, primarily for the table structure,
    // but the main screen is full width now that the sidebar is removed.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B232F),
        elevation: 0,
        automaticallyImplyLeading: false, // Ensure no back button appears
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Wrap in a SingleChildScrollView to handle vertical overflow
          return SingleChildScrollView(
            // Use responsive padding for the overall screen
            padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Title and Description
                Text(
                  'Manage Items',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 4.h),
                Text(
                  'View, search, and manage a list of all products.',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[400]),
                ),
                SizedBox(height: 24.h),

                // Search Controls and Add Button
                const HeaderControls(),
                SizedBox(height: 24.h),

                // Items Table
                ItemsList(
                  editingItemId: _editingItemId,
                  onEditStart: _startEdit,
                  onEditCancel: _cancelEdit,
                ),

                SizedBox(height: 20.h),
                // Footer / Pagination
                const TableFooter(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- Header Controls (Search and Dropdowns) ---

class HeaderControls extends StatelessWidget {
  const HeaderControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Search Bar (takes up most of the space)
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 450.w, // Specific width for the search bar
                child: TextField(
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: 'Search by name, SKU...',
                    hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.search, size: 20.sp, color: Colors.grey[600]),
                    suffixIcon: Icon(Icons.tune, size: 20.sp, color: Colors.grey[600]),
                    filled: true,
                    fillColor: const Color(0xFF232D3B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  ),
                ),
              ),
              // Space placeholder for other filters if needed, matching the image structure
            ],
          ),
        ),
        // Add New Item Button
        ElevatedButton.icon(
          onPressed: () {
   
          
          },
          icon: Icon(Icons.add, size: 18.sp),
          label: Text('Add New Item', style: TextStyle(fontSize: 14.sp)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF285A9B),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            elevation: 0,
          ),
        ),
      ],
    );
  }
}

// --- Items List Widget (Handles item rows and edit rows) ---

class ItemsList extends StatelessWidget {
  final String? editingItemId;
  final Function(String) onEditStart;
  final VoidCallback onEditCancel;

  const ItemsList({
    required this.editingItemId,
    required this.onEditStart,
    required this.onEditCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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

          // Table Rows with Inline Edit Logic
          ...mockInventory.expand((item) {
            final isEditing = item.id == editingItemId;
            return [
              ProductRow(
                item: item,
                isBeingEdited: isEditing,
                onEditPressed: () => onEditStart(item.id),
              ),
              if (isEditing) ProductEditRow(item: item, onCancel: onEditCancel),
            ];
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final style = TextStyle(fontSize: 12.sp, color: Colors.grey[500], fontWeight: FontWeight.w600);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          SizedBox(width: 40.w), // Image column padding
          Expanded(flex: 3, child: Text('PRODUCT NAME', style: style)),
          Expanded(flex: 1, child: Text('SKU', style: style)),
          Expanded(flex: 1, child: Text('CATEGORY', style: style)),
          Expanded(flex: 1, child: Text('PRICE', style: style)),
          Expanded(flex: 1, child: Text('STOCK', style: style)),
          Expanded(flex: 1, child: Text('STATUS', style: style)),
          SizedBox(width: 40.w), // Action column width
        ],
      ),
    );
  }
}

// --- Single Product Row Widget (Non-editing view) ---

class ProductRow extends StatelessWidget {
  final InventoryItem item;
  final bool isBeingEdited;
  final VoidCallback onEditPressed;

  const ProductRow({
    required this.item,
    required this.isBeingEdited,
    required this.onEditPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isBeingEdited ? const Color(0xFF1F2837) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          // Image
          SizedBox(
            width: 40.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: Image.network(item.imageUrl, width: 32.w, height: 32.w, fit: BoxFit.cover),
            ),
          ),
          // Product Name
          Expanded(
            flex: 3,
            child: Text(item.name, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
          ),
          // SKU
          Expanded(flex: 1, child: Text(item.sku, style: TextStyle(fontSize: 14.sp, color: Colors.grey))),
          // Category
          Expanded(flex: 1, child: Text(item.category, style: TextStyle(fontSize: 14.sp, color: Colors.grey))),
          // Price
          Expanded(flex: 1, child: Text('\$${item.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 14.sp, color: Colors.white))),
          // Stock
          Expanded(flex: 1, child: Text(item.stock.toString(), style: TextStyle(fontSize: 14.sp, color: Colors.white))),
          // Status Badge
          Expanded(flex: 1, child: StatusBadge(status: item.status)),
          // Action Button
          SizedBox(
            width: 40.w,
            child: IconButton(
              icon: Icon(Icons.edit, color: Colors.grey[500], size: 18.sp),
              onPressed: onEditPressed,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Product Edit Row (Inline editing form) ---

class ProductEditRow extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onCancel;

  const ProductEditRow({required this.item, required this.onCancel, super.key});

  Widget _buildTextField(String label, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey[500])),
        SizedBox(height: 4.h),
        TextField(
          controller: TextEditingController(text: initialValue),
          style: TextStyle(fontSize: 14.sp, color: Colors.white),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: const Color(0xFF232D3B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String initialValue, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey[500])),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: const Color(0xFF232D3B),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: initialValue,
              isDense: true,
              dropdownColor: const Color(0xFF232D3B),
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(fontSize: 14.sp)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Handle change
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2837),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF285A9B), width: 1.w),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name (3/8 width)
              Expanded(
                flex: 3,
                child: _buildTextField('Product Name', item.name),
              ),
              SizedBox(width: 16.w),
              // Price (1/8 width)
              Expanded(
                flex: 1,
                child: _buildTextField('Price', item.price.toStringAsFixed(2)),
              ),
              SizedBox(width: 16.w),
              // Stock (1/8 width)
              Expanded(
                flex: 1,
                child: _buildTextField('Stock', item.stock.toString()),
              ),
              // Empty space to align with table structure
              Expanded(flex: 3, child: Container()),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SKU (1/8 width)
              Expanded(
                flex: 1,
                child: _buildTextField('SKU', item.sku),
              ),
              SizedBox(width: 16.w),
              // Category (1/8 width)
              Expanded(
                flex: 1,
                child: _buildDropdown('Category', item.category, ['Furniture', 'Electronics', 'Stationery']),
              ),
              SizedBox(width: 16.w),
              // Status (1/8 width)
              Expanded(
                flex: 1,
                child: _buildDropdown('Status', item.status, ['Active', 'Low Stock', 'Out of Stock', 'Archived']),
              ),
              // Empty space to align with table structure
              Expanded(flex: 3, child: Container()),
              // Save/Cancel Buttons
              SizedBox(
                width: 250.w, // Fixed width for buttons
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onCancel,
                      child: Text('Cancel', style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                    ),
                    SizedBox(width: 10.w),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle Save Changes
                        onCancel();
                      },
                      icon: Icon(Icons.save, size: 16.sp),
                      label: Text('Save Changes', style: TextStyle(fontSize: 14.sp)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF285A9B),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// --- Status Indicator Badge (Re-used) ---

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    Color textColor;
    Color bgColor;

    switch (status) {
      case 'Active':
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
        dotColor = Colors.redAccent;
        textColor = Colors.redAccent;
        bgColor = Colors.red.shade900.withOpacity(0.4);
        break;
      case 'Archived':
      default:
        dotColor = Colors.blueGrey;
        textColor = Colors.blueGrey;
        bgColor = Colors.blueGrey.shade900.withOpacity(0.4);
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
            style: TextStyle(fontSize: 12.sp, color: textColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// --- Table Footer (Pagination - Re-used and simplified) ---

class TableFooter extends StatelessWidget {
  const TableFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPaginationButton(context, Icons.chevron_left, isActive: false),
        _buildPaginationButton(context, null, text: '1', isActive: true),
        _buildPaginationButton(context, null, text: '2'),
        _buildPaginationButton(context, null, text: '3'),
        _buildPaginationButton(context, null, text: '...'),
        _buildPaginationButton(context, null, text: '10'),
        _buildPaginationButton(context, Icons.chevron_right, isActive: true),
      ],
    );
  }

  Widget _buildPaginationButton(BuildContext context, IconData? icon, {String? text, bool isActive = false}) {
    return Container(
      width: 36.w,
      height: 36.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF285A9B) : Colors.transparent, // Changed inactive color for better visual integration
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8.r),
          child: Center(
            child: icon != null
                ? Icon(icon, color: isActive ? Colors.white : Colors.grey[400], size: 20.sp)
                : Text(
                    text!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isActive ? Colors.white : Colors.grey[300],
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}