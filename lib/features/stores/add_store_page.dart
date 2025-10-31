import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/image_upload_widget.dart';
import '../stores/store_controller.dart';

class AddStorePage extends StatelessWidget {
  final StoreController controller = Get.find<StoreController>();

  AddStorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Add New Store'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: controller.storeFormKey,
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
                        'Store Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Store Name (English)
                      CustomTextField(
                        controller: controller.nameController,
                        label: 'Store Name (English)',
                        hintText: 'Enter store name in English',
                        validator: (value) =>
                            Validators.validateName(value, minLength: 2),
                        prefixIcon: Icon(Icons.shop), isPassword: false,
                      ),

                      SizedBox(height: 16),

                      // Store Name (Arabic)
                      CustomTextField(
                        controller: controller.nameArController,
                        label: 'Store Name (Arabic)',
                        hintText: 'أدخل اسم المتجر بالعربية',
                        validator: (value) =>
                            Validators.validateName(value, minLength: 2),
                        prefixIcon: Icon(Icons.shop),//store
                        isPassword: false,
                      ),

                      SizedBox(height: 16),

                      Row(
                        children: [
                          // City
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: controller.selectedCity.value,
                              decoration: InputDecoration(
                                labelText: 'City',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(Icons.location_city),
                              ),
                              items: AppConstants.countries.map((city) {
                                return DropdownMenuItem(
                                  value: city,
                                  child: Text(city),
                                );
                              }).toList(),
                              validator: (value) =>
                              value == null || value.isEmpty
                                  ? 'Please select a city'
                                  : null,
                              onChanged: (value) =>
                              controller.selectedCity.value = value ?? '',
                            ),
                          ),

                          SizedBox(width: 16),

                          // Status
                          Expanded(
                            child: Obx(() => SwitchListTile(
                              title: Text('Active Store'),
                              subtitle: Text(
                                  'Show this store in the app'),
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

              // Address & Contact Card
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
                        'Address & Contact',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Address
                      TextFormField(
                        controller: controller.addressController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          hintText: 'Enter store address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: (value) =>
                            Validators.validateRequired(value, 'Address'),
                      ),

                      SizedBox(height: 16),

                      Row(
                        children: [
                          // Phone
                          Expanded(
                            child: CustomTextField(
                              controller: controller.phoneController,
                              label: 'Phone Number',
                              hintText: 'Enter phone number',
                              validator: (value) =>
                                  Validators.validatePhone(value),
                              prefixIcon: Icon(Icons.phone),
                              isPassword: false,
                            ),
                          ),

                          SizedBox(width: 16),

                          // Email
                          Expanded(
                            child: CustomTextField(
                              controller: controller.emailController,
                              label: 'Email (Optional)',
                              hintText: 'Enter email address',
                              validator: (value) => value!.isEmpty
                                  ? null
                                  : Validators.validateEmail(value),
                              prefixIcon: Icon(Icons.email),
                              isPassword: false,

                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      Row(
                        children: [
                          // Latitude
                          Expanded(
                            child: CustomTextField(
                              controller: controller.latitudeController,
                              label: 'Latitude',
                              hintText: '25.276987',
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  Validators.validateNumber(value, 'Latitude'),
                              prefixIcon: Icon(Icons.map),
                              isPassword: false,
                            ),
                          ),

                          SizedBox(width: 16),

                          // Longitude
                          Expanded(
                            child: CustomTextField(
                              controller: controller.longitudeController,
                              label: 'Longitude',
                              hintText: '55.296249',
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  Validators.validateNumber(value, 'Longitude'),
                              prefixIcon: Icon(Icons.map),
                              isPassword: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Working Hours Card
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
                        'Working Hours',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 20),

                      Row(
                        children: [
                          // Opening Hours
                          Expanded(
                            child: CustomTextField(
                              controller: controller.openingHoursController,
                              label: 'Opening Hours',
                              hintText: '09:00',
                              validator: (value) =>
                                  Validators.validateRequired(
                                      value, 'Opening hours'),
                              prefixIcon: Icon(Icons.access_time),
                              isPassword: false,
                            ),
                          ),

                          SizedBox(width: 16),

                          // Closing Hours
                          Expanded(
                            child: CustomTextField(
                              controller: controller.closingHoursController,
                              label: 'Closing Hours',
                              hintText: '18:00',
                              validator: (value) =>
                                  Validators.validateRequired(
                                      value, 'Closing hours'),
                              prefixIcon: Icon(Icons.access_time),
                              isPassword: false,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Working Days
                      Wrap(
                        spacing: 8,
                        children: [
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday',
                          'Saturday',
                          'Sunday'
                        ].map((day) {
                          return FilterChip(
                            label: Text(day),
                            selected:
                            controller.workingDays.contains(day),
                            onSelected: (selected) {
                              if (selected) {
                                controller.workingDays.add(day);
                              } else {
                                controller.workingDays.remove(day);
                              }
                            },
                            checkmarkColor: Colors.white,
                            selectedColor: AppColors.primary,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Manager Information Card
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
                        'Manager Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 20),

                      Row(
                        children: [
                          // Manager Name
                          Expanded(
                            child: CustomTextField(
                              controller: controller.managerNameController,
                              label: 'Manager Name',
                              hintText: 'Enter manager name',
                              prefixIcon: Icon(Icons.person),
                              isPassword: false,

                            ),
                          ),

                          SizedBox(width: 16),

                          // Manager Phone
                          Expanded(
                            child: CustomTextField(
                              controller: controller.managerPhoneController,
                              label: 'Manager Phone',
                              hintText: 'Enter manager phone',
                              prefixIcon: Icon(Icons.phone),
                              isPassword: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Store Image Card
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
                        'Store Image',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Upload an image for this store (Optional)',
                        style: TextStyle(
                          color: AppColors.gray,
                        ),
                      ),
                      SizedBox(height: 20),

                      Obx(() => ImageUploadWidget(
                        images: controller.storeImages,
                        onImagesSelected: (images) {
                          if (images.isNotEmpty) {
                            controller.storeImages.value = [images.first];
                          }
                        },
                        onImageRemoved: (index) {
                          controller.storeImages.clear();
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
                          : () => controller.addStore(),
                      text: controller.isSubmitting.value
                          ? 'Adding...'
                          : 'Add Store',
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