import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/order.dart';
import '../../../core/utils/helpers.dart';
import '../../../widgets/custom_button.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/confirmation_dialog.dart';
import '../orders/order_controller.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderController controller = Get.find<OrderController>();
  final String orderId;

  OrderDetailsPage({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Order Details #$orderId'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => controller.loadOrderDetails(orderId),
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

        final order = controller.currentOrder.value;
        if (order == null) {
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
                  'Order not found',
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
              // Order Summary Card
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
                            'Order Summary',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
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
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Order Details Grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 3,
                        children: [
                          _buildDetailItem('Order ID', '#${order.id}'),
                          _buildDetailItem('Order Date',
                              Helpers.formatDateTime(order.orderDate)),
                          _buildDetailItem(
                              'Customer', order.userName ?? 'Unknown'),
                          _buildDetailItem(
                              'Phone', order.userPhone ?? 'Not provided'),
                          _buildDetailItem(
                              'Delivery Type', order.deliveryTypeText),
                          _buildDetailItem(
                              'Payment Method', order.paymentMethodText),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Action Buttons
                      if (order.canBeEdited || order.canBeCancelled) ...[
                        Divider(),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            if (order.canBeEdited)
                              Expanded(
                                child: CustomButton(
                                  onPressed: () =>
                                      _showStatusUpdateDialog(order),
                                  text: 'Update Status',
                                  backgroundColor: AppColors.warning,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            if (order.canBeEdited && order.canBeCancelled)
                              SizedBox(width: 12),
                            if (order.canBeCancelled)
                              Expanded(
                                child: CustomButton(
                                  onPressed: () => _showCancelDialog(order),
                                  text: 'Cancel Order',
                                  backgroundColor: AppColors.error,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Customer & Delivery Information
              Row(
                children: [
                  // Customer Information
                  Expanded(
                    child: Card(
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
                              'Customer Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 16),
                            _buildInfoRow('Name', order.userName ?? 'Unknown'),
                            _buildInfoRow('Email', order.userEmail ?? 'N/A'),
                            _buildInfoRow('Phone', order.userPhone ?? 'N/A'),
                            _buildInfoRow(
                                'Address', order.addressDetails ?? 'N/A'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 20),

                  // Delivery Information
                  Expanded(
                    child: Card(
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
                              'Delivery Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 16),
                            _buildInfoRow('Type', order.deliveryTypeText),
                            _buildInfoRow('Delivery Man',
                                order.deliveryManName ?? 'Not assigned'),
                            _buildInfoRow('Delivery Fee',
                                Helpers.formatCurrency(order.deliveryPrice)),
                            if (order.notes != null)
                              _buildInfoRow('Notes', order.notes!),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Order Items
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
                        'Order Items',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 16),

                      if (order.items != null && order.items!.isNotEmpty) ...[
                        ...order.items!.map((item) => _buildOrderItem(item)),
                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(height: 16),
                        _buildPriceSummary(order),
                      ] else
                        Center(
                          child: Text(
                            'No items found',
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.gray,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: item.productImageUrl != null
                  ? DecorationImage(
                image: NetworkImage(item.productImageUrl!),
                fit: BoxFit.cover,
              )
                  : null,
              color: AppColors.lightGray,
            ),
            child: item.productImageUrl == null
                ? Icon(Icons.image, color: AppColors.gray)
                : null,
          ),
          SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'Quantity: ${item.quantity}',
                  style: TextStyle(
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),

          // Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Helpers.formatCurrency(item.price),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                Helpers.formatCurrency(item.total),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(Order order) {
    return Column(
      children: [
        _buildPriceRow('Items Total', order.itemsPrice),
        if (order.couponDiscount > 0)
          _buildPriceRow('Coupon Discount', -order.couponDiscount),
        _buildPriceRow('Delivery Fee', order.deliveryPrice),
        Divider(),
        _buildPriceRow('Total Amount', order.totalPrice, isTotal: true),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? AppColors.primary : AppColors.gray,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            Helpers.formatCurrency(amount),
            style: TextStyle(
              color: isTotal ? AppColors.primary : AppColors.gray,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
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