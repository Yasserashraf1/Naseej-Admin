import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/product.dart';
import '../../../core/models/category.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/utils/helpers.dart';

class ProductController extends GetxController {
  final ApiService _apiService = ApiService();

  // Form controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final discountPriceController = TextEditingController();
  final stockController = TextEditingController();

  // Form key
  final productFormKey = GlobalKey<FormState>();

  // Observable states
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final products = <Product>[].obs;
  final filteredProducts = <Product>[].obs;
  final categories = <Category>[].obs;
  final selectedCategoryId = ''.obs;
  final selectedStatus = ''.obs;
  final selectedSize = ''.obs;
  final selectedColor = ''.obs;
  final selectedMaterial = ''.obs;
  final isActive = true.obs;
  final isFeatured = false.obs;
  final searchController = TextEditingController();

  // Pagination
  final currentPage = 1.obs;
  final totalProducts = 0.obs;
  final itemsPerPage = 10.obs;

  // Image handling
  final productImages = <File>[].obs;
  final existingImages = <String>[].obs;
  final removedImages = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    loadCategories();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    stockController.dispose();
    searchController.dispose();
    super.onClose();
  }

  // Load products
  Future<void> loadProducts() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '${ApiEndpoints.productsList}?page=${currentPage.value}&limit=${itemsPerPage.value}',
      );

      if (response['status'] == 'success') {
        final data = response['data'];
        products.value = (data['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
        totalProducts.value = data['total'] ?? 0;
        filteredProducts.value = List.from(products);
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to load products',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load products: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      final response = await _apiService.get(ApiEndpoints.categoriesList);

      if (response['status'] == 'success') {
        categories.value = (response['data'] as List)
            .map((json) => Category.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  // Search products
  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.value = List.from(products);
    } else {
      filteredProducts.value = products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()) ||
            (product.categoryName ?? '')
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    }
  }

  // Filter by category
  void filterByCategory(String categoryId) {
    selectedCategoryId.value = categoryId;
    _applyFilters();
  }

  // Filter by status
  void filterByStatus(String status) {
    selectedStatus.value = status;
    _applyFilters();
  }

  // Apply all filters
  void _applyFilters() {
    var filtered = List.from(products);
    // Category filter
    if (selectedCategoryId.value.isNotEmpty) {
      filtered = filtered
          .where((product) =>
              (product as Product).categoryId == selectedCategoryId.value)
          .toList();
    }

    // Status filter
    if (selectedStatus.value.isNotEmpty) {
      final isActiveFilter = selectedStatus.value == 'active';
      filtered = filtered
          .where((product) => (product as Product).isActive == isActiveFilter)
          .toList();
    }

    // Search filter
    final searchQuery = searchController.text;
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        final p = product as Product;
        return p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            p.description.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Cast the list to the correct type
    filteredProducts.value = filtered.cast<Product>();
  }

  // Add product
  Future<void> addProduct() async {
    if (!productFormKey.currentState!.validate()) {
      return;
    }

    try {
      isSubmitting.value = true;

      // Prepare product data
      final productData = {
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'price': priceController.text,
        'discount_price': discountPriceController.text.isEmpty
            ? null
            : discountPriceController.text,
        'category_id': selectedCategoryId.value,
        'stock_quantity': stockController.text,
        'size': selectedSize.value,
        'color': selectedColor.value,
        'material': selectedMaterial.value,
        'is_active': isActive.value ? '1' : '0',
        'is_featured': isFeatured.value ? '1' : '0',
      };

      // Remove null values
      productData.removeWhere((key, value) => value == null || value == '');

      // First, create the product
      final response = await _apiService.post(
        ApiEndpoints.productAdd,
        productData,
      );

      if (response['status'] == 'success') {
        final productId = response['data']['id'];

        // Upload images if any
        if (productImages.isNotEmpty) {
          await _uploadProductImages(productId.toString());
        }

        Get.snackbar(
          'Success',
          'Product added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear form and go back
        clearForm();
        Get.offNamed('/products');
        loadProducts(); // Refresh the list
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to add product',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add product: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Update product
  Future<void> updateProduct(String productId) async {
    if (!productFormKey.currentState!.validate()) {
      return;
    }

    try {
      isSubmitting.value = true;

      // Prepare product data
      final productData = {
        'id': productId,
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'price': priceController.text,
        'discount_price': discountPriceController.text.isEmpty
            ? null
            : discountPriceController.text,
        'category_id': selectedCategoryId.value,
        'stock_quantity': stockController.text,
        'size': selectedSize.value,
        'color': selectedColor.value,
        'material': selectedMaterial.value,
        'is_active': isActive.value ? '1' : '0',
        'is_featured': isFeatured.value ? '1' : '0',
      };

      // Remove null values
      productData.removeWhere((key, value) => value == null || value == '');

      // Update product
      final response = await _apiService.post(
        ApiEndpoints.productUpdate,
        productData,
      );

      if (response['status'] == 'success') {
        // Upload new images
        if (productImages.isNotEmpty) {
          await _uploadProductImages(productId);
        }

        // Delete removed images
        for (final imageName in removedImages) {
          await _deleteProductImage(productId, imageName);
        }

        Get.snackbar(
          'Success',
          'Product updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offNamed('/products');
        loadProducts(); // Refresh the list
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to update product',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update product: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Load product for editing
  Future<void> loadProductForEdit(String productId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '${ApiEndpoints.productDetails}?id=$productId',
      );

      if (response['status'] == 'success') {
        final product = Product.fromJson(response['data']);

        // Fill form with product data
        nameController.text = product.name;
        descriptionController.text = product.description;
        priceController.text = product.price.toString();
        if (product.discountPrice != null) {
          discountPriceController.text = product.discountPrice!.toString();
        }
        stockController.text = product.stockQuantity.toString();
        selectedCategoryId.value = product.categoryId;
        selectedSize.value = product.size;
        selectedColor.value = product.color;
        selectedMaterial.value = product.material;
        isActive.value = product.isActive;
        isFeatured.value = product.isFeatured;

        // Load existing images
        existingImages.value = product.images ?? [];
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to load product',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load product: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.productDelete,
        {'id': productId},
      );

      if (response['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Product deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadProducts(); // Refresh the list
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to delete product',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete product: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Upload product images
  Future<void> _uploadProductImages(String productId) async {
    for (final imageFile in productImages) {
      await _apiService.uploadFile(
        ApiEndpoints.productUploadImage,
        imageFile,
        'image',
        additionalFields: {
          'product_id': productId,
        },
      );
    }
  }

  // Delete product image
  Future<void> _deleteProductImage(String productId, String imageName) async {
    await _apiService.post(
      ApiEndpoints.productDeleteImage,
      {
        'product_id': productId,
        'image_name': imageName,
      },
    );
  }

  // Clear form
  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    discountPriceController.clear();
    stockController.clear();
    selectedCategoryId.value = '';
    selectedSize.value = '';
    selectedColor.value = '';
    selectedMaterial.value = '';
    isActive.value = true;
    isFeatured.value = false;
    productImages.clear();
    existingImages.clear();
    removedImages.clear();
  }

  // Pick images from gallery
  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage(
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (pickedFiles.isNotEmpty) {
      for (final pickedFile in pickedFiles) {
        if (productImages.length < 5) {
          productImages.add(File(pickedFile.path));
        } else {
          break; // Maximum 5 images
        }
      }
    }
  }

  // Remove image
  void removeImage(int index) {
    if (index < productImages.length) {
      productImages.removeAt(index);
    }
  }

  // Remove existing image
  void removeExistingImage(int index) {
    if (index < existingImages.length) {
      removedImages.add(existingImages[index]);
      existingImages.removeAt(index);
    }
  }
}