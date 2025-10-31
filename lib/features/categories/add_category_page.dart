import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/image_upload_widget.dart';
import '../categories/category_controller.dart';

class AddCategoryPage extends StatelessWidget {
  final CategoryController controller = Get.find<CategoryController>();

  AddCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Add New Category'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: controller.categoryFormKey,
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
                        'Category Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 20),

                      // English Name
                      CustomTextField(
                        controller: controller.nameController,
                        label: 'Category Name (English)',
                        hintText: 'Enter category name in English',
                        validator: (value) =>
                            Validators.validateName(value, minLength: 2),
                        prefixIcon: Icon(Icons.category),//
                        isPassword: false,
                      ),

                      SizedBox(height: 16),

                      // Arabic Name
                      CustomTextField(
                        controller: controller.nameArController,
                        label: 'Category Name (Arabic)',
                        hintText: 'أدخل اسم الفئة بالعربية',
                        validator: (value) =>
                            Validators.validateName(value, minLength: 2),
                        prefixIcon: Icon(Icons.category),
                        isPassword: false,
                      ),

                      SizedBox(height: 16),

                      // Description
                      TextFormField(
                        controller: controller.descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Description (Optional)',
                          hintText: 'Enter category description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(Icons.description),
                        ),
                      ),

                      SizedBox(height: 16),

                      Row(
                        children: [
                          // Display Order
                          Expanded(
                            child: CustomTextField(
                              controller: controller.displayOrderController,
                              label: 'Display Order',
                              hintText: '0',
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  Validators.validateInteger(value, 'Display order'),
                              prefixIcon: Icon(Icons.sort_outlined),
                              isPassword: false,
                            ),
                          ),

                          SizedBox(width: 16),

                          // Status
                          Expanded(
                            child: Obx(() => SwitchListTile(
                              title: Text('Active Category'),
                              subtitle: Text(
                                  'Show this category in the app'),
                              value: controller.isActive.value,
                              onChanged: (value) =>
                              controller.isActive.value = value,
                              activeColor: AppColors.primary,
                            )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Category Image Card
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
                        'Category Image',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Upload an image for this category (Optional)',
                        style: TextStyle(
                          color: AppColors.gray,
                        ),
                      ),
                      SizedBox(height: 20),

                      Obx(() => ImageUploadWidget(
                        images: controller.categoryImages,
                        onImagesSelected: (images) {
                          if (images.isNotEmpty) {
                            controller.categoryImages.value = [images.first];
                          }
                        },
                        onImageRemoved: (index) {
                          controller.categoryImages.clear();
                        },
                        maxImages: 1,
                        singleImage: true,
                      )),
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
                          : () => controller.addCategory(),
                      text: controller.isSubmitting.value
                          ? 'Adding...'
                          : 'Add Category',
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
      ),
    );
  }
}