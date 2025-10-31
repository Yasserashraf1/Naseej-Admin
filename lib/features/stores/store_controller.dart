import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/store.dart';
import '../../../core/constants/api_endpoints.dart';

class StoreController extends GetxController {
  final ApiService _apiService = ApiService();

  // Form controllers
  final nameController = TextEditingController();
  final nameArController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final openingHoursController = TextEditingController();
  final closingHoursController = TextEditingController();
  final managerNameController = TextEditingController();
  final managerPhoneController = TextEditingController();

  // Form key
  final storeFormKey = GlobalKey<FormState>();

  // Observable states
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final stores = <Store>[].obs;
  final filteredStores = <Store>[].obs;
  final selectedStatus = ''.obs;
  final selectedCity = ''.obs;
  final searchController = TextEditingController();
  final isActive = true.obs;
  final workingDays = <String>[].obs;

  // Pagination
  final currentPage = 1.obs;
  final totalStores = 0.obs;
  final itemsPerPage = 10.obs;

  // Image handling
  final storeImages = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStores();
    // Set default working days
    workingDays.addAll(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']);
    // Set default hours
    openingHoursController.text = '09:00';
    closingHoursController.text = '18:00';
  }

  @override
  void onClose() {
    nameController.dispose();
    nameArController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    openingHoursController.dispose();
    closingHoursController.dispose();
    managerNameController.dispose();
    managerPhoneController.dispose();
    searchController.dispose();
    super.onClose();
  }

  // Load stores
  Future<void> loadStores() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '${ApiEndpoints.storesList}?page=${currentPage.value}&limit=${itemsPerPage.value}',
      );

      if (response['status'] == 'success') {
        final data = response['data'];
        stores.value = (data['stores'] as List)
            .map((json) => Store.fromJson(json))
            .toList();
        totalStores.value = data['total'] ?? 0;
        filteredStores.value = List.from(stores);
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to load stores',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load stores: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Search stores
  void searchStores(String query) {
    if (query.isEmpty) {
      filteredStores.value = List.from(stores);
    } else {
      filteredStores.value = stores.where((store) {
        return store.name.toLowerCase().contains(query.toLowerCase()) ||
            store.nameAr.toLowerCase().contains(query.toLowerCase()) ||
            store.address.toLowerCase().contains(query.toLowerCase()) ||
            store.city.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  // Filter by status
  void filterByStatus(String status) {
    selectedStatus.value = status;
    _applyFilters();
  }

  // Filter by city
  void filterByCity(String city) {
    selectedCity.value = city;
    _applyFilters();
  }

  // Apply all filters
  void _applyFilters() {
    var filtered = List.from(stores);

    // Status filter
    if (selectedStatus.value.isNotEmpty) {
      final isActiveFilter = selectedStatus.value == 'active';
      filtered = filtered
          .where((store) => store.isActive == isActiveFilter)
          .toList();
    }

    // City filter
    if (selectedCity.value.isNotEmpty) {
      filtered = filtered
          .where((store) => store.city == selectedCity.value)
          .toList();
    }

    // Search filter
    final searchQuery = searchController.text;
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((dynamic store) {
        return store.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            store.nameAr.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    filteredStores.value = filtered.cast<Store>();
  }

  // Add store
  Future<void> addStore() async {
    if (!storeFormKey.currentState!.validate()) {
      return;
    }

    try {
      isSubmitting.value = true;

      // Prepare store data
      final storeData = {
        'name': nameController.text.trim(),
        'name_ar': nameArController.text.trim(),
        'address': addressController.text.trim(),
        'city': selectedCity.value,
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'latitude': latitudeController.text,
        'longitude': longitudeController.text,
        'opening_hours': openingHoursController.text.trim(),
        'closing_hours': closingHoursController.text.trim(),
        'working_days': workingDays.join(','),
        'manager_name': managerNameController.text.trim(),
        'manager_phone': managerPhoneController.text.trim(),
        'is_active': isActive.value ? '1' : '0',
      };

      // Remove empty optional fields
      if (storeData['email']?.isEmpty ?? true) {
        storeData.remove('email');
      }
      if (storeData['manager_name']?.isEmpty ?? true) {
        storeData.remove('manager_name');
      }
      if (storeData['manager_phone']?.isEmpty ?? true) {
        storeData.remove('manager_phone');
      }

      // First, create the store
      final response = await _apiService.post(
        ApiEndpoints.storeAdd,
        storeData,
      );

      if (response['status'] == 'success') {
        final storeId = response['data']['id'];

        // Upload image if available
        if (storeImages.isNotEmpty) {
          await _uploadStoreImage(storeId.toString());
        }

        Get.snackbar(
          'Success',
          'Store added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear form and go back
        clearForm();
        Get.offNamed('/stores');
        loadStores(); // Refresh the list
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to add store',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add store: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Update store
  Future<void> updateStore(String storeId) async {
    if (!storeFormKey.currentState!.validate()) {
      return;
    }

    try {
      isSubmitting.value = true;

      // Prepare store data
      final storeData = {
        'id': storeId,
        'name': nameController.text.trim(),
        'name_ar': nameArController.text.trim(),
        'address': addressController.text.trim(),
        'city': selectedCity.value,
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'latitude': latitudeController.text,
        'longitude': longitudeController.text,
        'opening_hours': openingHoursController.text.trim(),
        'closing_hours': closingHoursController.text.trim(),
        'working_days': workingDays.join(','),
        'manager_name': managerNameController.text.trim(),
        'manager_phone': managerPhoneController.text.trim(),
        'is_active': isActive.value ? '1' : '0',
      };

      // Remove empty optional fields
      if (storeData['email']?.isEmpty ?? true) {
        storeData.remove('email');
      }
      if (storeData['manager_name']?.isEmpty ?? true) {
        storeData.remove('manager_name');
      }
      if (storeData['manager_phone']?.isEmpty ?? true) {
        storeData.remove('manager_phone');
      }

      // Update store
      final response = await _apiService.post(
        ApiEndpoints.storeUpdate,
        storeData,
      );

      if (response['status'] == 'success') {
        // Upload new image if available
        if (storeImages.isNotEmpty) {
          await _uploadStoreImage(storeId);
        }

        Get.snackbar(
          'Success',
          'Store updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offNamed('/stores');
        loadStores(); // Refresh the list
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to update store',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update store: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Load store for editing
  Future<void> loadStoreForEdit(String storeId) async {
    try {
      isLoading.value = true;

      // Find store in the list or fetch from API
      final store = stores.firstWhere(
            (str) => str.id == storeId,
        orElse: () => Store(
          id: '',
          name: '',
          nameAr: '',
          address: '',
          city: '',
          latitude: 0,
          longitude: 0,
          openingHours: '',
          closingHours: '',
          createdAt: DateTime.now(),
        ),
      );

      // Fill form with store data
      nameController.text = store.name;
      nameArController.text = store.nameAr;
      addressController.text = store.address;
      selectedCity.value = store.city;
      phoneController.text = store.phone ?? '';
      emailController.text = store.email ?? '';
      latitudeController.text = store.latitude.toString();
      longitudeController.text = store.longitude.toString();
      openingHoursController.text = store.openingHours;
      closingHoursController.text = store.closingHours;
      isActive.value = store.isActive;
      managerNameController.text = store.managerName ?? '';
      managerPhoneController.text = store.managerPhone ?? '';

      // Set working days
      workingDays.clear();
      if (store.workingDays != null) {
        workingDays.addAll(store.workingDays!);
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load store: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  // Delete store
  Future<void> deleteStore(String storeId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.storeDelete,
        {'id': storeId},
      );

      if (response['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Store deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadStores(); // Refresh the list
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to delete store',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete store: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Upload store image
  Future<void> _uploadStoreImage(String storeId) async {
    if (storeImages.isNotEmpty) {
      await _apiService.uploadFile(
        '${ApiEndpoints.baseUrl}/admin/stores/upload_image.php',
        storeImages.first,
        'image',
        additionalFields: {
          'store_id': storeId,
        },
      );
    }
  }

  // Clear form
  void clearForm() {
    nameController.clear();
    nameArController.clear();
    addressController.clear();
    phoneController.clear();
    emailController.clear();
    latitudeController.clear();
    longitudeController.clear();
    openingHoursController.text = '09:00';
    closingHoursController.text = '18:00';
    managerNameController.clear();
    managerPhoneController.clear();
    selectedCity.value = '';
    isActive.value = true;
    workingDays.clear();
    workingDays.addAll(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']);
    storeImages.clear();
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
      storeImages.value = [File(pickedFile.path)];
    }
  }

  // Remove image
  void removeImage() {
    storeImages.clear();
  }
}