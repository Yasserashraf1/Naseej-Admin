import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/customer.dart';
import '../../../core/utils/helpers.dart';
import '../../../widgets/custom_button.dart';
import 'package:naseej_admin/features/customers/customer_controller.dart';

import '../../widgets/confirmation_dialog.dart';

class CustomerDetailsPage extends StatelessWidget {
  final CustomerController controller = Get.find<CustomerController>();
  final String customerId;

  CustomerDetailsPage({Key? key, required this.customerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Customer Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => controller.loadCustomerDetails(customerId),
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        final customer = controller.currentCustomer.value;
        if (customer == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.gray,
                ),
                SizedBox(height: 16),
                Text(
                  'Customer not found',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.gray,
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  onPressed: () => Get.back(),
                  text: 'Go Back',
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Profile Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Profile Image
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          image: customer.profileImageUrl != null
                              ? DecorationImage(
                            image: NetworkImage(customer.profileImageUrl!),
                            fit: BoxFit.cover,
                          )
                              : null,
                          color: AppColors.lightGray,
                        ),
                        child: customer.profileImageUrl == null
                            ? Icon(Icons.person, size: 40, color: AppColors.gray)
                            : null,
                      ),
                      SizedBox(width: 20),

                      // Customer Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              customer.email,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.gray,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(customer)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
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
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getTierColor(customer.customerTier)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: _getTierColor(customer.customerTier),
                                        size: 12,
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
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Action Buttons
                      Column(
                        children: [
                          if (!customer.isBlocked)
                            CustomButton(
                              onPressed: () => _showBlockDialog(customer),
                              text: 'Block',
                              backgroundColor: AppColors.warning,
                              foregroundColor: Colors.white,
                              small: true,
                            ),
                          if (customer.isBlocked)
                            CustomButton(
                              onPressed: () => controller.unblockCustomer(customer.id),
                              text: 'Unblock',
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                              small: true,
                            ),
                          SizedBox(height: 8),
                          CustomButton(
                            onPressed: () => _showDeleteDialog(customer),
                            text: 'Delete',
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                            small: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Customer Statistics
              Row(
                children: [
                  // Orders Statistics
                  Expanded(
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.shopping_bag,
                              size: 40,
                              color: AppColors.primary,
                            ),
                            SizedBox(height: 12),
                            Text(
                              customer.totalOrders.toString(),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Total Orders',
                              style: TextStyle(
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 20),

                  // Spending Statistics
                  Expanded(
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 40,
                              color: AppColors.success,
                            ),
                            SizedBox(height: 12),
                            Text(
                              Helpers.formatCurrency(customer.totalSpent),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Total Spent',
                              style: TextStyle(
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 20),

                  // Average Order Value
                  Expanded(
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 40,
                              color: AppColors.info,
                            ),
                            SizedBox(height: 12),
                            Text(
                              Helpers.formatCurrency(customer.averageOrderValue),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.info,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Avg. Order Value',
                              style: TextStyle(
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Customer Details
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 20),

                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 4,
                        children: [
                          _buildDetailItem('Customer ID', customer.id),
                          _buildDetailItem('Phone', customer.phone ?? 'Not provided'),
                          _buildDetailItem('Registration Date',
                              Helpers.formatDate(customer.registeredDate)),
                          _buildDetailItem('Last Login',
                              customer.lastLogin != null
                                  ? Helpers.timeAgo(customer.lastLogin!)
                                  : 'Never'),
                          _buildDetailItem('City', customer.city ?? 'Not specified'),
                          _buildDetailItem('Country', customer.country ?? 'Not specified'),
                          _buildDetailItem('Preferred Language',
                              customer.preferredLanguage ?? 'Not specified'),
                          _buildDetailItem('Customer Since',
                              '${Helpers.formatDate(customer.registeredDate)} (${Helpers.timeAgo(customer.registeredDate)})'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Recent Orders (if available)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Orders',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to orders page filtered by this customer
                            },
                            child: Text('View All Orders'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Here you would list recent orders for this customer
                      // For now, we'll show a placeholder
                      Center(
                        child: Text(
                          'Order history would be displayed here',
                          style: TextStyle(
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.gray,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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