import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/order.dart';
import '../../../core/constants/api_endpoints.dart';

class OrderController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observable states
  final isLoading = false.obs;
  final orders = <Order>[].obs;
  final filteredOrders = <Order>[].obs;
  final currentOrder = Rx<Order?>(null);
  final selectedStatus = ''.obs;
  final searchController = TextEditingController();
  final selectedDateRange = Rx<DateTimeRange?>(null);

  // Pagination
  final currentPage = 1.obs;
  final totalOrders = 0.obs;
  final itemsPerPage = 10.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Load orders
  Future<void> loadOrders() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '${ApiEndpoints.ordersList}?page=${currentPage.value}&limit=${itemsPerPage.value}',
      );

      if (response['status'] == 'success') {
        final data = response['data'];
        orders.value = (data['orders'] as List)
            .map((json) => Order.fromJson(json))
            .toList();
        totalOrders.value = data['total'] ?? 0;
        filteredOrders.value = List.from(orders);
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to load orders',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load orders: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load order details
  Future<void> loadOrderDetails(String orderId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '${ApiEndpoints.orderDetails}?id=$orderId',
      );

      if (response['status'] == 'success') {
        currentOrder.value = Order.fromJson(response['data']);
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to load order details',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load order details: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Search orders
  void searchOrders(String query) {
    if (query.isEmpty) {
      filteredOrders.value = List.from(orders);
    } else {
      filteredOrders.value = orders.where((order) {
        return order.id.toLowerCase().contains(query.toLowerCase()) ||
            (order.userName ?? '').toLowerCase().contains(query.toLowerCase()) ||
            (order.userPhone ?? '').contains(query) ||
            (order.userEmail ?? '').toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  // Filter by status
  void filterByStatus(String status) {
    selectedStatus.value = status;
    _applyFilters();
  }

  // Filter by date range
  void filterByDateRange(DateTimeRange? dateRange) {
    selectedDateRange.value = dateRange;
    _applyFilters();
  }

  // Apply all filters
  void _applyFilters() {
    List<Order> filtered = List.from(orders);

    // Status filter
    if (selectedStatus.value.isNotEmpty) {
      filtered = filtered
          .where((order) => order.status == selectedStatus.value)
          .toList();
    }

    // Date range filter
    if (selectedDateRange.value != null) {
      final start = selectedDateRange.value!.start;
      final end = selectedDateRange.value!.end;
      filtered = filtered.where((order) {
        return order.orderDate.isAfter(start.subtract(Duration(days: 1))) &&
            order.orderDate.isBefore(end.add(Duration(days: 1)));
      }).toList();
    }

    // Search filter
    final searchQuery = searchController.text;
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((order) {
        return order.id.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (order.userName ?? '')
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
      }).toList();
    }

    filteredOrders.value = filtered;
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.orderUpdateStatus,
        {
          'order_id': orderId,
          'status': status,
        },
      );

      if (response['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Order status updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Refresh orders and current order
        loadOrders();
        if (currentOrder.value != null && currentOrder.value!.id == orderId) {
          loadOrderDetails(orderId);
        }
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to update order status',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update order status: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Cancel order
  Future<void> cancelOrder(String orderId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.orderDelete,
        {'order_id': orderId},
      );

      if (response['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Order cancelled successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadOrders(); // Refresh the list
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to cancel order',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel order: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Assign delivery man
  Future<void> assignDeliveryMan(String orderId, String deliveryManId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.orderAssignDelivery,
        {
          'order_id': orderId,
          'delivery_man_id': deliveryManId,
        },
      );

      if (response['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Delivery man assigned successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadOrders(); // Refresh the list
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to assign delivery man',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to assign delivery man: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Show date filter dialog
  Future<void> showDateFilter(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 365)),
      currentDate: DateTime.now(),
      saveText: 'Apply',
    );

    if (picked != null) {
      filterByDateRange(picked);
    }
  }

  // Clear filters
  void clearFilters() {
    selectedStatus.value = '';
    selectedDateRange.value = null;
    searchController.clear();
    filteredOrders.value = List.from(orders);
  }

  // Get orders statistics
  Future<Map<String, dynamic>> getOrderStats() async {
    try {
      final response = await _apiService.get(ApiEndpoints.dashboardStats);

      if (response['status'] == 'success') {
        return response['data'] ?? {};
      }
    } catch (e) {
      print('Failed to load order stats: $e');
    }
    return {};
  }
}