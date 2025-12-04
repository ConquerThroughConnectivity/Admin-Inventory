import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNewItemScreen extends StatelessWidget {
  const AddNewItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              // Responsive padding
              final horizontalPadding = constraints.maxWidth * 0.04;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  30.h,
                  horizontalPadding,
                  30.h + 80.h, // Add space for the fixed footer
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Header (Title and Cancel Button)
                    const HeaderSection(),
                    SizedBox(height: 30.h),

                    // 2. Main Content (Responsive two-column or single-column layout)
                    MainContent(constraints: constraints),
                  ],
                ),
              );
            },
          ),
          // 3. Fixed Footer (Save buttons)
          const BottomActionBar(),
        ],
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
              'Add New Item',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 4.h),
            Text(
              'Fill in the details below to add a new product to your inventory.',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[400]),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text('Cancel', style: TextStyle(fontSize: 16.sp, color: Colors.grey[400])),
        ),
      ],
    );
  }
}

// --- 2. Main Content (Handles responsive column layout) ---

class MainContent extends StatelessWidget {
  final BoxConstraints constraints;
  const MainContent({required this.constraints, super.key});

  @override
  Widget build(BuildContext context) {
    // Breakpoint for switching from Row (desktop) to Column (mobile/tablet)
    bool isMobileLayout = constraints.maxWidth < 900;

    if (isMobileLayout) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ProductInformationCard(),
          SizedBox(height: 20),
          PricingInventoryCard(),
          SizedBox(height: 20),
          OrganizationCard(),
          SizedBox(height: 20),
          ProductImagesCard(),
          SizedBox(height: 20),
          StatusCard(),
        ],
      );
    } else {
      // Desktop layout: Main form on left (2/3 width), Images/Status on right (1/3 width)
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Product Info, Pricing, Organization
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const ProductInformationCard(),
                SizedBox(height: 20.h),
                const PricingInventoryCard(),
                SizedBox(height: 20.h),
                const OrganizationCard(),
              ],
            ),
          ),
          SizedBox(width: 30.w),
          // Right Column: Images, Status
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const ProductImagesCard(),
                SizedBox(height: 20.h),
                const StatusCard(),
              ],
            ),
          ),
        ],
      );
    }
  }
}

// --- Shared Card Structure ---

class CustomCard extends StatelessWidget {
  final String title;
  final Widget child;

  const CustomCard({required this.title, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141A25),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

// --- Form Components ---

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final bool isCurrency;

  const CustomTextField({
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.isCurrency = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        SizedBox(height: 8.h),
        TextField(
          maxLines: maxLines,
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            prefixIcon: isCurrency ? Icon(Icons.attach_money, size: 20.sp, color: Colors.grey[600]) : null,
            filled: true,
            fillColor: const Color(0xFF232D3B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          ),
        ),
      ],
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String label;
  final String hint;

  const CustomDropdown({required this.label, required this.hint, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFF232D3B),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: null,
              hint: Text(hint, style: TextStyle(fontSize: 16.sp, color: Colors.grey[600])),
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 24.sp),
              dropdownColor: const Color(0xFF232D3B),
              isExpanded: true,
              items: const [], // Placeholder items
              onChanged: (String? newValue) {},
            ),
          ),
        ),
      ],
    );
  }
}

// --- Content Cards ---

class ProductInformationCard extends StatelessWidget {
  const ProductInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Product Information',
      child: Column(
        children: [
          const CustomTextField(
            label: 'Product Name',
            hint: 'Enter product name',
          ),
          SizedBox(height: 20.h),
          const CustomTextField(
            label: 'Product Description',
            hint: 'Enter a detailed description for the product',
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}

class PricingInventoryCard extends StatelessWidget {
  const PricingInventoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Pricing & Inventory',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomTextField(
              label: 'Price',
              hint: '0.00',
              isCurrency: true,
              // Use a smaller font size hint to match the design (e.g., $ 0.00)
              // We'll simulate this with the hint text since the prefix is not ideal for exact alignment.
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: CustomTextField(
              label: 'Stock Quantity',
              hint: '0',
            ),
          ),
        ],
      ),
    );
  }
}

class OrganizationCard extends StatelessWidget {
  const OrganizationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Organization',
      child: CustomDropdown(
        label: 'Category',
        hint: 'Select a category',
      ),
    );
  }
}

class ProductImagesCard extends StatelessWidget {
  const ProductImagesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Product Images',
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: const Color(0xFF232D3B),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFF285A9B), width: 1.w),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload_outlined, size: 36.sp, color: Colors.grey[400]),
              SizedBox(height: 8.h),
              Text('Drag & drop images here, or', style: TextStyle(fontSize: 14.sp, color: Colors.grey[400])),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('click to browse', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF285A9B))),
              ),
              SizedBox(height: 4.h),
              Text('PNG, JPG or GIF (up to 10MB)', style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Status',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Published',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          Switch(
            value: true,
            onChanged: (bool value) {
              // Handle status toggle
            },
            activeColor: const Color(0xFF38977F), // Green color
          ),
        ],
      ),
    );
  }
}

// --- 3. Bottom Action Bar (Fixed Footer) ---

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width * 0.04;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF141A25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade700, width: 1.w),
                foregroundColor: Colors.grey[400],
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              child: Text('Save as Draft', style: TextStyle(fontSize: 16.sp)),
            ),
            SizedBox(width: 16.w),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF285A9B),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                elevation: 0,
              ),
              child: Text('Save Item', style: TextStyle(fontSize: 16.sp)),
            ),
          ],
        ),
      ),
    );
  }
}