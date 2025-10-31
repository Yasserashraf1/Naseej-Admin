import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/delivery_man.dart';
import '../../../core/constants/api_endpoints.dart';

class DeliveryController extends GetxController {
  final ApiService _apiService = ApiService();

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final vehicleNumberController = TextEditingController();

  // Form key
  final deliveryManFormKey = GlobalKey<FormState>();

  // Observable states
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final deliveryMen = <DeliveryMan>[].obs;
  final filteredDeliveryMen = <DeliveryMan>[].obs;
  final selectedStatus = ''.obs;
  final selectedAvailability = ''.obs;
  final searchController = TextEditingController();
  final isActive = true.obs;
  final isAvailable = true.obs;
  final selectedVehicleType = 'Motorcycle'.obs;

  // Pagination
  final currentPage = 1.obs;
  final totalDeliveryMen = 0.obs;
  final itemsPerPage = 10.obs;

  // Image handling
  final profileImages = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDeliveryMen();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    vehicleNumberController.dispose();
    searchController.dispose();
    super.onClose();
  }

  // Load delivery men
  Future<void> loadDeliveryMen() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '${ApiEndpoints.deliveryList}?page=${currentPage.value}&limit=${itemsPerPage.value}',
      );

      if (response['status'] == 'success') {
        final data = response['data'];
        deliveryMen.value = (data['delivery_men'] as List)
            .map((json) => DeliveryMan.fromJson(json))
            .toList();
        totalDeliveryMen.value = data['total'] ?? 0;
        filteredDeliveryMen.value = List.from(deliveryMen);
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to load delivery men',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load delivery men: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Search delivery men
  void searchDeliveryMen(String query) {
    if (query.isEmpty) {
      filteredDeliveryMen.value = List.from(deliveryMen);
    } else {
      filteredDeliveryMen.value = deliveryMen.where((deliveryMan) {
        return deliveryMan.name.toLowerCase().contains(query.toLowerCase()) ||
            deliveryMan.email.toLowerCase().contains(query.toLowerCase()) ||
            deliveryMan.phone.contains(query) ||
            (deliveryMan.vehicleType ?? '')
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    }
  }

  // Filter by status
  void filterByStatus(String status) {
    selectedStatus.value = status;
    _applyFilters();
  }

  // Filter by availability
  void filterByAvailability(String availability) {
    selectedAvailability.value = availability;
    _applyFilters();
  }

  // Apply all filters
  void _applyFilters() {
    var filtered = List.from(deliveryMen);

    // Status filter
    if (selectedStatus.value.isNotEmpty) {
      final isActiveFilter = selectedStatus.value == 'active';
      filtered = filtered
          .where((deliveryMan) => deliveryMan.isActive == isActiveFilter)
          .toList();
    }

    // Availability filter
    if (selectedAvailability.value.isNotEmpty) {
      final isAvailableFilter = selectedAvailability.value == 'available';
      filtered = filtered
          .where((deliveryMan) => deliveryMan.isAvailable == isAvailableFilter)
          .toList();
    }

    // Search filter
    final searchQuery = searchController.text;
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((deliveryMan) {
        return deliveryMan.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            deliveryMan.email.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    filteredDeliveryMen.value = filtered.cast<DeliveryMan>();
  }

  // Add delivery man
  Future<void> addDeliveryMan() async {
    if (!deliveryManFormKey.currentState!.validate()) {
      return;
    }

    try {
      isSubmitting.value = true;

      // Prepare delivery man data
      final deliveryManData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'vehicle_type': selectedVehicleType.value,
        'vehicle_number': vehicleNumberController.text.trim(),
        'is_active': isActive.value ? '1' : '0',
        'is_available': isAvailable.value ? '1' : '0',
      };

      // Remove empty vehicle number
      if (deliveryManData['vehicle_number']?.isEmpty ?? true) {
        deliveryManData.remove('vehicle_number');
      }

      // First, create the delivery man
      final response = await _apiService.post(
        ApiEndpoints.deliveryAdd,
        deliveryManData,
      );

      if (response['status'] == 'success') {
        final deliveryManId = response['data']['id'];

        // Upload profile image if available
        if (profileImages.isNotEmpty) {
          await _uploadProfileImage(deliveryManId.toString());
        }

        Get.snackbar(
          'Success',
          'Delivery man added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear form and go back
        clearForm();
        Get.offNamed('/delivery');
        loadDeliveryMen(); // Refresh the list
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to add delivery man',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add delivery man: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Update delivery man
  Future<void> updateDeliveryMan(String deliveryManId) async {
    if (!deliveryManFormKey.currentState!.validate()) {
      return;
    }

    try {
      isSubmitting.value = true;

      // Prepare delivery man data
      final deliveryManData = {
        'id': deliveryManId,
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'vehicle_type': selectedVehicleType.value,
        'vehicle_number': vehicleNumberController.text.trim(),
        'is_active': isActive.value ? '1' : '0',
        'is_available': isAvailable.value ? '1' : '0',
      };

      // Remove empty vehicle number
      if (deliveryManData['vehicle_number']?.isEmpty ?? true) {
        deliveryManData.remove('vehicle_number');
      }

      // Update delivery man
      final response = await _apiService.post(
        ApiEndpoints.deliveryUpdate,
        deliveryManData,
      );

      if (response['status'] == 'success') {
        // Upload new profile image if available
        if (profileImages.isNotEmpty) {
          await _uploadProfileImage(deliveryManId);
        }

        Get.snackbar(
          'Success',
          'Delivery man updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offNamed('/delivery');
        loadDeliveryMen(); // Refresh the list
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to update delivery man',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update delivery man: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Load delivery man for editing
  Future<void> loadDeliveryManForEdit(String deliveryManId) async {
    try {
      isLoading.value = true;

      // Find delivery man in the list or fetch from API
      final deliveryMan = deliveryMen.firstWhere(
            (man) => man.id == deliveryManId,
        orElse: () => DeliveryMan(
          id: '',
          name: '',
          email: '',
          phone: '',
          joinedDate: DateTime.now(),
        ),
      );

      // Fill form with delivery man data
      nameController.text = deliveryMan.name;
      emailController.text = deliveryMan.email;
      phoneController.text = deliveryMan.phone;
      selectedVehicleType.value = deliveryMan.vehicleType ?? 'Motorcycle';
      vehicleNumberController.text = deliveryMan.vehicleNumber ?? '';
      isActive.value = deliveryMan.isActive;
      isAvailable.value = deliveryMan.isAvailable;

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load delivery man: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  // Delete delivery man
  Future<void> deleteDeliveryMan(String deliveryManId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.deliveryDelete,
        {'id': deliveryManId},
      );

      if (response['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Delivery man deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadDeliveryMen(); // Refresh the list
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to delete delivery man',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete delivery man: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Upload profile image
  Future<void> _uploadProfileImage(String deliveryManId) async {
    if (profileImages.isNotEmpty) {
      await _apiService.uploadFile(
        '${ApiEndpoints.baseUrl}/admin/delivery/upload_image.php',
        profileImages.first,
        'image',
        additionalFields: {
          'delivery_man_id': deliveryManId,
        },
      );
    }
  }

  // Clear form
  void clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    vehicleNumberController.clear();
    selectedVehicleType.value = 'Motorcycle';
    isActive.value = true;
    isAvailable.value = true;
    profileImages.clear();
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      profileImages.value = [File(pickedFile.path)];
    }
  }

  // Remove image
  void removeImage() {
    profileImages.clear();
  }
}