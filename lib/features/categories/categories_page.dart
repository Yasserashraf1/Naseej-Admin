import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/category.dart';
import '../../../core/utils/helpers.dart';
import '../../../widgets/data_table_widget.dart';
import '../../../widgets/confirmation_dialog.dart';
import 'package:naseej_admin/features/categories/category_controller.dart';

class CategoriesPage extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());

  CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/categories/add'),
                  icon: Icon(Icons.add),
                  label: Text('Add Category'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Search and Filters
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Search
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: 'Search categories...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) => controller.searchCategories(value),
                      ),
                    ),

                    SizedBox(width: 16),

                    // Status Filter
                    Container(
                      width: 150,
                      child: DropdownButtonFormField<String>(
                        value: controller.selectedStatus.value,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text('All Status'),
                          ),
                          DropdownMenuItem(
                            value: 'active',
                            child: Text('Active'),
                          ),
                          DropdownMenuItem(
                            value: 'inactive',
                            child: Text('Inactive'),
                          ),
                        ],
                        onChanged: (value) =>
                            controller.filterByStatus(value ?? ''),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Categories Grid/List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }

                if (controller.categories.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildCategoriesGrid();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(Get.width),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: controller.filteredCategories.length,
      itemBuilder: (context, index) {
        final category = controller.filteredCategories[index];
        return _buildCategoryCard(category);
      },
    );
  }

  Widget _buildCategoryCard(Category category) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to category products or edit
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  image: category.imageUrl != null
                      ? DecorationImage(
                    image: NetworkImage(category.imageUrl!),
                    fit: BoxFit.cover,
                  )
                      : null,
                  color: AppColors.lightGray,
                ),
                child: category.imageUrl == null
                    ? Center(
                  child: Icon(
                    Icons.category,
                    size: 48,
                    color: AppColors.gray,
                  ),
                )
                    : null,
              ),
            ),

            // Category Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          category.nameAr,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.gray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Product Count
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${category.productCount} products',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // Status Badge
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: category.isActive
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            category.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 12,
                              color: category.isActive ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: IconButton(
                            onPressed: () => Get.toNamed(
                                '/categories/edit/${category.id}'),
                            icon: Icon(Icons.edit, size: 18),
                            color: AppColors.info,
                            tooltip: 'Edit',
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () => _showDeleteDialog(category),
                            icon: Icon(Icons.delete, size: 18),
                            color: AppColors.error,
                            tooltip: 'Delete',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(Get.width),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: AppColors.lightGray,
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: AppColors.lightGray,
                      ),
                      Container(
                        width: 80,
                        height: 12,
                        color: AppColors.lightGray,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 20,
                            color: AppColors.lightGray,
                          ),
                          Spacer(),
                          Container(
                            width: 40,
                            height: 20,
                            color: AppColors.lightGray,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 64,
            color: AppColors.gray.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No Categories Found',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first category to get started',
            style: TextStyle(
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.toNamed('/categories/add'),
            child: Text('Add Category'),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) return 4;
    if (screenWidth > 800) return 3;
    if (screenWidth > 600) return 2;
    return 1;
  }

  void _showDeleteDialog(Category category) {
    Get.dialog(
      ConfirmationDialog(
        title: 'Delete Category',
        message:
        'Are you sure you want to delete "${category.name}"? This will also remove all products in this category.',
        onConfirm: () => controller.deleteCategory(category.id),
      ),
    );
  }
}