import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/customer.dart';
import '../../../core/constants/api_endpoints.dart';

class CustomerController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observable states
  final isLoading = false.obs;
  final customers = <Customer>[].obs;
  final filteredCustomers = <Customer>[].obs;
  final currentCustomer = Rx<Customer?>(null);
  final selectedStatus = ''.obs;
  final selectedTier = ''.obs;
  final searchController = TextEditingController();

  // Pagination
  final currentPage = 1.obs;
  final totalCustomers = 0.obs;
  final itemsPerPage = 10.obs;

  @override
  void onInit() {
    super.onInit();
    loadCustomers();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Load customers
  Future<void> loadCustomers() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '${ApiEndpoints.customersList}?page=${currentPage.value}&limit=${itemsPerPage.value}',
      );

      if (response['status'] == 'success') {
        final data = response['data'];
        customers.value = (data['customers'] as List)
            .map((json) => Customer.fromJson(json))
            .toList();
        totalCustomers.value = data['total'] ?? 0;
        filteredCustomers.value = List.from(customers);
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to load customers',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load customers: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load customer details
  Future<void> loadCustomerDetails(String customerId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '${ApiEndpoints.customerDetails}?id=$customerId',
      );

      if (response['status'] == 'success') {
        currentCustomer.value = Customer.fromJson(response['data']);
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to load customer details',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load customer details: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Search customers
  void searchCustomers(String query) {
    if (query.isEmpty) {
      filteredCustomers.value = List.from(customers);
    } else {
      filteredCustomers.value = customers.where((customer) {
        return customer.name.toLowerCase().contains(query.toLowerCase()) ||
            customer.email.toLowerCase().contains(query.toLowerCase()) ||
            (customer.phone ?? '').contains(query) ||
            (customer.city ?? '').toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  // Filter by status
  void filterByStatus(String status) {
    selectedStatus.value = status;
    _applyFilters();
  }

  // Filter by tier
  void filterByTier(String tier) {
    selectedTier.value = tier;
    _applyFilters();
  }

  // Apply all filters
  void _applyFilters() {
    var filtered = List.from(customers);

    // Status filter
    if (selectedStatus.value.isNotEmpty) {
      switch (selectedStatus.value) {
        case 'active':
          filtered = filtered
              .where((customer) => customer.isActive && !customer.isBlocked)
              .toList();
          break;
        case 'blocked':
          filtered = filtered
              .where((customer) => customer.isBlocked)
              .toList();
          break;
        case 'inactive':
          filtered = filtered
              .where((customer) => !customer.isActive)
              .toList();
          break;
      }
    }

    // Tier filter
    if (selectedTier.value.isNotEmpty) {
      filtered = filtered
          .where((customer) => customer.customerTier == selectedTier.value)
          .toList();
    }

    // Search filter
    final searchQuery = searchController.text;
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((customer) {
        return customer.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            customer.email.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    filteredCustomers.value = filtered.cast<Customer>();
  }

  // Block customer
  Future<void> blockCustomer(String customerId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.customerBlock,
        {'customer_id': customerId},
      );

      if (response['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Customer blocked successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Refresh customers and current customer
        loadCustomers();
        if (currentCustomer.value != null && currentCustomer.value!.id == customerId) {
          loadCustomerDetails(customerId);
        }
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to block customer',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to block customer: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Unblock customer
  Future<void> unblockCustomer(String customerId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.customerUnblock,
        {'customer_id': customerId},
      );

      if (response['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Customer unblocked successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Refresh customers and current customer
        loadCustomers();
        if (currentCustomer.value != null && currentCustomer.value!.id == customerId) {
          loadCustomerDetails(customerId);
        }
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to unblock customer',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to unblock customer: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Delete customer
  Future<void> deleteCustomer(String customerId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.customerDelete,
        {'customer_id': customerId},
      );

      if (response['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Customer deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadCustomers(); // Refresh the list
        if (currentCustomer.value?.id == customerId) {
          Get.back(); // Go back if we're on the details page
        }
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to delete customer',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete customer: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear filters
  void clearFilters() {
    selectedStatus.value = '';
    selectedTier.value = '';
    searchController.clear();
    filteredCustomers.value = List.from(customers);
  }

  // Get customer statistics
  Future<Map<String, dynamic>> getCustomerStats() async {
    try {
      final response = await _apiService.get(ApiEndpoints.customersReport);

      if (response['status'] == 'success') {
        return response['data'] ?? {};
      }
    } catch (e) {
      print('Failed to load customer stats: $e');
    }
    return {};
  }
}