import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/order.dart';
import '../../../core/utils/helpers.dart';

class RecentOrdersWidget extends StatelessWidget {
  final List<Order> orders;
  final bool isLoading;
  final VoidCallback? onViewAll;

  const RecentOrdersWidget({
    Key? key,
    required this.orders,
    this.isLoading = false,
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Recent Orders',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: Text('View All'),
                  ),
              ],
            ),

            SizedBox(height: 20),

            // Orders List
            if (isLoading)
              _buildLoadingState()
            else if (orders.isEmpty)
              _buildEmptyState()
            else
              _buildOrdersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: orders.length > 5 ? 5 : orders.length,
      separatorBuilder: (context, index) => Divider(height: 24),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderItem(order);
      },
    );
  }

  Widget _buildOrderItem(Order order) {
    return InkWell(
      onTap: () {
        // Navigate to order details
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Order Status Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getStatusIcon(order.status),
                color: _getStatusColor(order.status),
                size: 24,
              ),
            ),

            SizedBox(width: 16),

            // Order Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${order.id}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    order.userName ?? 'Customer',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.gray,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    Helpers.timeAgo(order.orderDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),

            // Order Amount and Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Helpers.formatCurrency(order.totalPrice),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(order.status),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (context, index) => Divider(height: 24),
      itemBuilder: (context, index) {
        return Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 120,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: AppColors.gray.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'No recent orders',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.gray,
              ),
            ),
          ],
        ),
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

  IconData _getStatusIcon(String status) {
    switch (status) {
      case '0': return Icons.pending;
      case '1': return Icons.restaurant;
      case '2': return Icons.check_circle;
      case '3': return Icons.local_shipping;
      case '4': return Icons.done_all;
      case '5': return Icons.cancel;
      default: return Icons.help;
    }
  }
}