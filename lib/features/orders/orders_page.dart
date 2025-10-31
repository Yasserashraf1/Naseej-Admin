import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/order.dart';
import '../../../core/utils/helpers.dart';
import '../../../widgets/data_table_widget.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../../core/constants/app_constants.dart';
import '../orders/order_controller.dart';

class OrdersPage extends StatelessWidget {
  final OrderController controller = Get.put(OrderController());

  OrdersPage({Key? key}) : super(key: key);

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
                  'Orders Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Obx(() => Text(
                  '${controller.totalOrders.value} Total Orders',
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
                          hintText: 'Search orders...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) => controller.searchOrders(value),
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
                          ...AppConstants.orderStatusLabels.entries.map((entry) {
                            return DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) =>
                            controller.filterByStatus(value ?? ''),
                      ),
                    ),

                    SizedBox(width: 16),

                    // Date Filter
                    Container(
                      width: 150,
                      child: TextButton.icon(
                        onPressed: () => controller.showDateFilter(context),
                        icon: Icon(Icons.calendar_today),
                        label: Text('Date'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: AppColors.lightGray),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Orders Table
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }

                if (controller.orders.isEmpty) {
                  return _buildEmptyState();
                }

                return DataTableWidget(
                  columns: [
                    DataColumn(label: Text('Order ID')),
                    DataColumn(label: Text('Customer')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: controller.filteredOrders.map((order) {
                    return DataRow(cells: [
                      DataCell(
                        Text(
                          '#${order.id}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              order.userName ?? 'Unknown Customer',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              order.userPhone ?? 'No phone',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray,
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
                              Helpers.formatDate(order.orderDate),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              Helpers.formatTime(order.orderDate),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray,
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
                              Helpers.formatCurrency(order.totalPrice),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              order.deliveryTypeText,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.statusText,
                            style: TextStyle(
                              color: _getStatusColor(order.status),
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
                                  '/orders/details/${order.id}'),
                              icon: Icon(Icons.visibility,
                                  color: AppColors.info, size: 20),
                              tooltip: 'View Details',
                            ),
                            if (order.canBeEdited)
                              IconButton(
                                onPressed: () =>
                                    _showStatusUpdateDialog(order),
                                icon: Icon(Icons.edit,
                                    color: AppColors.warning, size: 20),
                                tooltip: 'Update Status',
                              ),
                            if (order.canBeCancelled)
                              IconButton(
                                onPressed: () => _showCancelDialog(order),
                                icon: Icon(Icons.cancel,
                                    color: AppColors.error, size: 20),
                                tooltip: 'Cancel Order',
                              ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                  onPageChanged: (page) => controller.currentPage.value = page,
                  totalItems: controller.totalOrders.value,
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
            Icons.shopping_bag_outlined,
            size: 64,
            color: AppColors.gray.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No Orders Found',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Orders will appear here once customers start placing orders',
            style: TextStyle(
              color: AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '0': return Colors.orange;
      case '1': return Colors.blue;
      case '2': return Colors.purple;
      case '3': return Colors.amber;
      case '4': return Colors.green;
      case '5': return Colors.red;
      default: return AppColors.gray;
    }
  }

  void _showStatusUpdateDialog(Order order) {
    Get.dialog(
      AlertDialog(
        title: Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.orderStatusLabels.entries.map((entry) {
            return ListTile(
              leading: Radio<String>(
                value: entry.key,
                groupValue: order.status,
                onChanged: (value) {
                  Get.back();
                  controller.updateOrderStatus(order.id, value!);
                },
              ),
              title: Text(entry.value),
              onTap: () {
                Get.back();
                controller.updateOrderStatus(order.id, entry.key);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCancelDialog(Order order) {
    Get.dialog(
      ConfirmationDialog(
        title: 'Cancel Order',
        message:
        'Are you sure you want to cancel order #${order.id}? This action cannot be undone.',
        onConfirm: () => controller.cancelOrder(order.id),
      ),
    );
  }
}