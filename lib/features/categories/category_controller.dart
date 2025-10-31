import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/category.dart';
import '../../../core/constants/api_endpoints.dart';

class CategoryController extends GetxController {
  final ApiService _apiService = ApiService();

  // Form controllers
  final nameController = TextEditingController();
  final nameArController = TextEditingController();
  final descriptionController = TextEditingController();
  final displayOrderController = TextEditingController();

  // Form key
  final categoryFormKey = GlobalKey<FormState>();

  // Observable states
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final categories = <Category>[].obs;
  final filteredCategories = <Category>[].obs;
  final selectedStatus = ''.obs;
  final searchController = TextEditingController();
  final isActive = true.obs;

  // Image handling
  final categoryImages = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    displayOrderController.text = '0'; // Default display order
  }

  @override
  void onClose() {
    nameController.dispose();
    nameArController.dispose();
    descriptionController.dispose();
    displayOrderController.dispose();
    searchController.dispose();
    super.onClose();
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(ApiEndpoints.categoriesList);

      if (response['status'] == 'success') {
        categories.value = (response['data'] as List)
            .map((json) => Category.fromJson(json))
            .toList();
        filteredCategories.value = List.from(categories);
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to load categories',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load categories: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Search categories
  void searchCategories(String query) {
    if (query.isEmpty) {
      filteredCategories.value = List.from(categories);
    } else {
      filteredCategories.value = categories.where((category) {
        return category.name.toLowerCase().contains(query.toLowerCase()) ||
            category.nameAr.toLowerCase().contains(query.toLowerCase()) ||
            (category.description ?? '')
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    }
  }

  // Filter by status
  void filterByStatus(String status) {
    selectedStatus.value = status;

    if (status.isEmpty) {
      filteredCategories.value = List.from(categories);
    } else {
      final isActiveFilter = status == 'active';
      filteredCategories.value = categories
          .where((category) => category.isActive == isActiveFilter)
          .toList();
    }
  }

  // Add category
  Future<void> addCategory() async {
    if (!categoryFormKey.currentState!.validate()) {
      return;
    }

    try {
      isSubmitting.value = true;

      // Prepare category data
      final categoryData = {
        'name': nameController.text.trim(),
        'name_ar': nameArController.text.trim(),
        'description': descriptionController.text.trim(),
        'display_order': displayOrderController.text,
        'is_active': isActive.value ? '1' : '0',
      };

      // Remove empty description
      if (categoryData['description']?.isEmpty ?? true) {
        categoryData.remove('description');
      }

      // First, create the category
      final response = await _apiService.post(
        ApiEndpoints.categoryAdd,
        categoryData,
      );

      if (response['status'] == 'success') {
        final categoryId = response['data']['id'];

        // Upload image if available
        if (categoryImages.isNotEmpty) {
          await _uploadCategoryImage(categoryId.toString());
        }

        Get.snackbar(
          'Success',
          'Category added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear form and go back
        clearForm();
        Get.offNamed('/categories');
        loadCategories(); // Refresh the list
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to add category',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add category: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Update category
  Future<void> updateCategory(String categoryId) async {
    if (!categoryFormKey.currentState!.validate()) {
      return;
    }

    try {
      isSubmitting.value = true;

      // Prepare category data
      final categoryData = {
        'id': categoryId,
        'name': nameController.text.trim(),
        'name_ar': nameArController.text.trim(),
        'description': descriptionController.text.trim(),
        'display_order': displayOrderController.text,
        'is_active': isActive.value ? '1' : '0',
      };

      // Remove empty description
      if (categoryData['description']?.isEmpty ?? true) {
        categoryData.remove('description');
      }

      // Update category
      final response = await _apiService.post(
        ApiEndpoints.categoryUpdate,
        categoryData,
      );

      if (response['status'] == 'success') {
        // Upload new image if available
        if (categoryImages.isNotEmpty) {
          await _uploadCategoryImage(categoryId);
        }

        Get.snackbar(
          'Success',
          'Category updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offNamed('/categories');
        loadCategories(); // Refresh the list
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to update category',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update category: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Load category for editing
  Future<void> loadCategoryForEdit(String categoryId) async {
    try {
      isLoading.value = true;

      // Find category in the list or fetch from API
      final category = categories.firstWhere(
            (cat) => cat.id == categoryId,
        orElse: () => Category(
          id: '',
          name: '',
          nameAr: '',
          createdAt: DateTime.now(),
        ),
      );

      // Fill form with category data
      nameController.text = category.name;
      nameArController.text = category.nameAr;
      descriptionController.text = category.description ?? '';
      displayOrderController.text = category.displayOrder.toString();
      isActive.value = category.isActive;

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load category: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  // Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.categoryDelete,
        {'id': categoryId},
      );

      if (response['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Category deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadCategories(); // Refresh the list
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to delete category',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete category: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Upload category image
  Future<void> _uploadCategoryImage(String categoryId) async {
    if (categoryImages.isNotEmpty) {
      await _apiService.uploadFile(
        '${ApiEndpoints.baseUrl}/admin/categories/upload_image.php',
        categoryImages.first,
        'image',
        additionalFields: {
          'category_id': categoryId,
        },
      );
    }
  }

  // Clear form
  void clearForm() {
    nameController.clear();
    nameArController.clear();
    descriptionController.clear();
    displayOrderController.text = '0';
    isActive.value = true;
    categoryImages.clear();
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
      categoryImages.value = [File(pickedFile.path)];
    }
  }

  // Remove image
  void removeImage() {
    categoryImages.clear();
  }
}