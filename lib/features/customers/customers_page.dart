import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/customer.dart';
import '../../../core/utils/helpers.dart';
import '../../../widgets/data_table_widget.dart';
import '../../../widgets/confirmation_dialog.dart';
import 'package:naseej_admin/features/customers/customer_controller.dart';

class CustomersPage extends StatelessWidget {
  final CustomerController controller = Get.put(CustomerController());

  CustomersPage({Key? key}) : super(key: key);

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
                  'Customers Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Obx(() => Text(
                  '${controller.totalCustomers.value} Total Customers',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.gray,
                  ),
                )),
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
                          hintText: 'Search customers...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) => controller.searchCustomers(value),
                      ),
                    ),

                    SizedBox(width: 16),

                    // Status Filter
                    Container(
                      width: 200,
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
                            value: 'blocked',
                            child: Text('Blocked'),
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

                    SizedBox(width: 16),

                    // Tier Filter
                    Container(
                      width: 150,
                      child: DropdownButtonFormField<String>(
                        value: controller.selectedTier.value,
                        decoration: InputDecoration(
                          labelText: 'Customer Tier',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text('All Tiers'),
                          ),
                          DropdownMenuItem(
                            value: 'VIP',
                            child: Text('VIP'),
                          ),
                          DropdownMenuItem(
                            value: 'Gold',
                            child: Text('Gold'),
                          ),
                          DropdownMenuItem(
                            value: 'Silver',
                            child: Text('Silver'),
                          ),
                          DropdownMenuItem(
                            value: 'Bronze',
                            child: Text('Bronze'),
                          ),
                        ],
                        onChanged: (value) =>
                            controller.filterByTier(value ?? ''),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Customers Table
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }

                if (controller.customers.isEmpty) {
                  return _buildEmptyState();
                }

                return DataTableWidget(
                  columns: [
                    DataColumn(label: Text('Customer')),
                    DataColumn(label: Text('Contact')),
                    DataColumn(label: Text('Orders')),
                    DataColumn(label: Text('Total Spent')),
                    DataColumn(label: Text('Tier')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: controller.filteredCustomers.map((customer) {
                    return DataRow(cells: [
                      DataCell(
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: customer.profileImageUrl != null
                                    ? DecorationImage(
                                  image: NetworkImage(
                                      customer.profileImageUrl!),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                                color: AppColors.lightGray,
                              ),
                              child: customer.profileImageUrl == null
                                  ? Icon(Icons.person, color: AppColors.gray)
                                  : null,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    customer.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    Helpers.timeAgo(customer.registeredDate),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              customer.email,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              customer.phone ?? 'No phone',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              customer.totalOrders.toString(),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          Helpers.formatCurrency(customer.totalSpent),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getTierColor(customer.customerTier)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: _getTierColor(customer.customerTier),
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                customer.customerTier,
                                style: TextStyle(
                                  color: _getTierColor(customer.customerTier),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(customer).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            customer.statusText,
                            style: TextStyle(
                              color: _getStatusColor(customer),
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
                              onPressed: () => Get.toNamed(
                                  '/customers/details/${customer.id}'),
                              icon: Icon(Icons.visibility,
                                  color: AppColors.info, size: 20),
                              tooltip: 'View Details',
                            ),
                            if (!customer.isBlocked)
                              IconButton(
                                onPressed: () => _showBlockDialog(customer),
                                icon: Icon(Icons.block,
                                    color: AppColors.warning, size: 20),
                                tooltip: 'Block Customer',
                              ),
                            if (customer.isBlocked)
                              IconButton(
                                onPressed: () => controller.unblockCustomer(customer.id),
                                icon: Icon(Icons.check_circle,
                                    color: AppColors.success, size: 20),
                                tooltip: 'Unblock Customer',
                              ),
                            IconButton(
                              onPressed: () => _showDeleteDialog(customer),
                              icon: Icon(Icons.delete,
                                  color: AppColors.error, size: 20),
                              tooltip: 'Delete Customer',
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                  onPageChanged: (page) => controller.currentPage.value = page,
                  totalItems: controller.totalCustomers.value,
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
            trailing: Container(
              width: 80,
              height: 24,
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
            Icons.people_outline,
            size: 64,
            color: AppColors.gray.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No Customers Found',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Customers will appear here once they register in the app',
            style: TextStyle(
              color: AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(Customer customer) {
    if (customer.isBlocked) return Colors.red;
    if (!customer.isActive) return Colors.orange;
    return Colors.green;
  }

  Color _getTierColor(String tier) {
    switch (tier) {
      case 'VIP': return Colors.purple;
      case 'Gold': return Colors.amber;
      case 'Silver': return Colors.blueGrey;
      case 'Bronze': return Colors.brown;
      default: return AppColors.gray;
    }
  }

  void _showBlockDialog(Customer customer) {
    Get.dialog(
      ConfirmationDialog(
        title: 'Block Customer',
        message:
        'Are you sure you want to block ${customer.name}? They will not be able to place orders until unblocked.',
        onConfirm: () => controller.blockCustomer(customer.id),
      ),
    );
  }

  void _showDeleteDialog(Customer customer) {
    Get.dialog(
      ConfirmationDialog(
        title: 'Delete Customer',
        message:
        'Are you sure you want to delete ${customer.name}? This action cannot be undone and all their data will be lost.',
        onConfirm: () => controller.deleteCustomer(customer.id),
      ),
    );
  }
}