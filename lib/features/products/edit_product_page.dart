import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/image_upload_widget.dart';
import '../products//product_controller.dart';

class EditProductPage extends StatelessWidget {
  final ProductController controller = Get.find<ProductController>();
  final String productId;

  EditProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  void initState() {
    controller.loadProductForEdit(productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Edit Product'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: controller.productFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Information Card
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
                          'Basic Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Product Name
                        CustomTextField(
                          controller: controller.nameController,
                          label: 'Product Name',
                          hintText: 'Enter product name',
                          validator: (value) =>
                              Validators.validateProductName(value),
                          prefixIcon: Icon(Icons.inventory_2),
                          isPassword: false,
                        ),

                        SizedBox(height: 16),

                        // Description
                        TextFormField(
                          controller: controller.descriptionController,
                          maxLines: 4,
                          maxLength: AppConstants.maxDescriptionLength,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            hintText: 'Enter product description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.description),
                          ),
                          validator: (value) =>
                              Validators.validateDescription(value),
                        ),

                        SizedBox(height: 16),

                        Row(
                          children: [
                            // Category
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: controller.selectedCategoryId.value,
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: Icon(Icons.category),
                                ),
                                items: controller.categories.map((category) {
                                  return DropdownMenuItem(
                                    value: category.id,
                                    child: Text(category.name),
                                  );
                                }).toList(),
                                validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'Please select a category'
                                    : null,
                                onChanged: (value) =>
                                controller.selectedCategoryId.value =
                                    value ?? '',
                              ),
                            ),

                            SizedBox(width: 16),

                            // Status
                            Expanded(
                              child: DropdownButtonFormField<bool>(
                                value: controller.isActive.value,
                                decoration: InputDecoration(
                                  labelText: 'Status',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: Icon(Icons.signal_wifi_statusbar_null),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: true,
                                    child: Text('Active'),
                                  ),
                                  DropdownMenuItem(
                                    value: false,
                                    child: Text('Inactive'),
                                  ),
                                ],
                                onChanged: (value) =>
                                controller.isActive.value = value ?? true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Pricing & Inventory Card
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
                          'Pricing & Inventory',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 20),

                        Row(
                          children: [
                            // Price
                            Expanded(
                              child: CustomTextField(
                                controller: controller.priceController,
                                label: 'Price (${AppConstants.currency})',
                                hintText: '0.00',
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    Validators.validatePrice(value),
                                prefixIcon: Icon(Icons.attach_money),
                                isPassword: false,
                              ),
                            ),

                            SizedBox(width: 16),

                            // Discount Price
                            Expanded(
                              child: CustomTextField(
                                controller: controller.discountPriceController,
                                label: 'Discount Price (Optional)',
                                hintText: '0.00',
                                keyboardType: TextInputType.number,
                                prefixIcon: Icon(Icons.discount),
                                isPassword: false,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

                        Row(
                          children: [
                            // Stock Quantity
                            Expanded(
                              child: CustomTextField(
                                controller: controller.stockController,
                                label: 'Stock Quantity',
                                hintText: '0',
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    Validators.validateStockQuantity(value),
                                prefixIcon: Icon(Icons.inventory),
                                isPassword: false,
                              ),
                            ),

                            SizedBox(width: 16),

                            // Featured
                            Expanded(
                              child: SwitchListTile(
                                title: Text('Featured Product'),
                                subtitle: Text(
                                    'Show this product in featured section'),
                                value: controller.isFeatured.value,
                                onChanged: (value) =>
                                controller.isFeatured.value = value,
                                activeColor: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Product Details Card
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
                          'Product Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 20),

                        Row(
                          children: [
                            // Size
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: controller.selectedSize.value,
                                decoration: InputDecoration(
                                  labelText: 'Size',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: Icon(Icons.aspect_ratio),
                                ),
                                items: AppConstants.carpetSizes.map((size) {
                                  return DropdownMenuItem(
                                    value: size,
                                    child: Text(size),
                                  );
                                }).toList(),
                                validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'Please select a size'
                                    : null,
                                onChanged: (value) =>
                                controller.selectedSize.value = value ?? '',
                              ),
                            ),

                            SizedBox(width: 16),

                            // Color
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: controller.selectedColor.value,
                                decoration: InputDecoration(
                                  labelText: 'Color',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: Icon(Icons.color_lens),
                                ),
                                items: AppConstants.carpetColors.map((color) {
                                  return DropdownMenuItem(
                                    value: color,
                                    child: Text(color),
                                  );
                                }).toList(),
                                validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'Please select a color'
                                    : null,
                                onChanged: (value) =>
                                controller.selectedColor.value = value ?? '',
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

                        // Material
                        DropdownButtonFormField<String>(
                          value: controller.selectedMaterial.value,
                          decoration: InputDecoration(
                            labelText: 'Material',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.texture),
                          ),
                          items: AppConstants.carpetMaterials.map((material) {
                            return DropdownMenuItem(
                              value: material,
                              child: Text(material),
                            );
                          }).toList(),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please select a material'
                              : null,
                          onChanged: (value) =>
                          controller.selectedMaterial.value = value ?? '',
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Images Card
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
                          'Product Images',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'First image will be used as main product image',
                          style: TextStyle(
                            color: AppColors.gray,
                          ),
                        ),
                        SizedBox(height: 20),

                        ImageUploadWidget(
                          images: controller.productImages,
                          existingImages: controller.existingImages,
                          onImagesSelected: (images) {
                            controller.productImages.addAll(images);
                          },
                          onImageRemoved: (index) {
                            if (index < controller.productImages.length) {
                              controller.productImages.removeAt(index);
                            }
                          },
                          onExistingImageRemoved: (index) {
                            controller.removedImages
                                .add(controller.existingImages[index]);
                            controller.existingImages.removeAt(index);
                          },
                          maxImages: 5,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: () => Get.back(),
                        text: 'Cancel',
                        backgroundColor: AppColors.gray,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Obx(() => CustomButton(
                        onPressed: controller.isSubmitting.value
                            ? null
                            : () => controller.updateProduct(productId),
                        text: controller.isSubmitting.value
                            ? 'Updating...'
                            : 'Update Product',
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      )),
                    ),
                  ],
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}