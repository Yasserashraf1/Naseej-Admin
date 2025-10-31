import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/product.dart';
import '../../../core/utils/helpers.dart';
import '../../../widgets/data_table_widget.dart';
import '../../../widgets/confirmation_dialog.dart';
import 'package:naseej_admin/features/products/product_controller.dart';

class ProductsPage extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  ProductsPage({Key? key}) : super(key: key);

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
                  'Products Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/products/add'),
                  icon: Icon(Icons.add),
                  label: Text('Add Product'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Filters and Search
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
                          hintText: 'Search products...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) => controller.searchProducts(value),
                      ),
                    ),

                    SizedBox(width: 16),

                    // Category Filter
                    Obx(() => Container(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: controller.selectedCategoryId.value,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text('All Categories'),
                          ),
                          ...controller.categories.map((category) {
                            return DropdownMenuItem(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) =>
                            controller.filterByCategory(value ?? ''),
                      ),
                    )),

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

            // Products Table
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }

                if (controller.products.isEmpty) {
                  return _buildEmptyState();
                }

                return DataTableWidget(
                  columns: [
                    DataColumn(label: Text('Product')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Stock')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: controller.filteredProducts.map((product) {
                    return DataRow(cells: [
                      DataCell(
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: product.mainImageUrl != null
                                    ? DecorationImage(
                                  image: NetworkImage(
                                      product.mainImageUrl!),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                                color: AppColors.lightGray,
                              ),
                              child: product.mainImageUrl == null
                                  ? Icon(Icons.image, color: AppColors.gray)
                                  : null,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${product.size} • ${product.color}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.gray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(product.categoryName ?? 'Uncategorized'),
                      ),
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Helpers.formatCurrency(product.finalPrice),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            if (product.discountPrice != null)
                              Text(
                                Helpers.formatCurrency(product.price),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.gray,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: product.inStock
                                ? product.stockQuantity < 10
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.stockStatus,
                            style: TextStyle(
                              color: product.inStock
                                  ? product.stockQuantity < 10
                                  ? Colors.orange
                                  : Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: product.isActive
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color:
                              product.isActive ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  Get.toNamed('/products/edit/${product.id}'),
                              icon: Icon(Icons.edit,
                                  color: AppColors.info, size: 20),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              onPressed: () => _showDeleteDialog(product),
                              icon: Icon(Icons.delete,
                                  color: AppColors.error, size: 20),
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                  onPageChanged: (page) => controller.currentPage.value = page,
                  totalItems: controller.totalProducts.value,
                  itemsPerPage: controller.itemsPerPage.value,
                  currentPage: controller.currentPage.value,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              color: AppColors.lightGray,
            ),
            title: Container(
              width: 200,
              height: 16,
              color: AppColors.lightGray,
            ),
            subtitle: Container(
              width: 150,
              height: 12,
              color: AppColors.lightGray,
            ),
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
            Icons.inventory_2_outlined,
            size: 64,
            color: AppColors.gray.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No Products Found',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first product to get started',
            style: TextStyle(
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.toNamed('/products/add'),
            child: Text('Add Product'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Product product) {
    Get.dialog(
      ConfirmationDialog(
        title: 'Delete Product',
        message:
        'Are you sure you want to delete "${product.name}"? This action cannot be undone.',
        onConfirm: () => controller.deleteProduct(product.id),
      ),
    );
  }
}