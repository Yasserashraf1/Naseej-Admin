import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/image_upload_widget.dart';
import 'package:naseej_admin/features/delivery/delivery_controller.dart';

class AddDeliveryManPage extends StatelessWidget {
  final DeliveryController controller = Get.find<DeliveryController>();

  AddDeliveryManPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Add New Delivery Man'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: controller.deliveryManFormKey,
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

                      // Name
                      CustomTextField(
                        controller: controller.nameController,
                        label: 'Full Name',
                        hintText: 'Enter delivery man name',
                        validator: (value) =>
                            Validators.validateName(value, minLength: 2),
                        prefixIcon: Icon(Icons.person),
                        isPassword: false,
                      ),

                      SizedBox(height: 16),

                      Row(
                        children: [
                          // Email
                          Expanded(
                            child: CustomTextField(
                              controller: controller.emailController,
                              label: 'Email',
                              hintText: 'Enter email address',
                              validator: (value) =>
                                  Validators.validateEmail(value),
                              prefixIcon: Icon(Icons.email),
                              isPassword: false,
                            ),
                          ),

                          SizedBox(width: 16),

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
                        ],
                      ),

                      SizedBox(height: 16),

                      Row(
                        children: [
                          // Status
                          Expanded(
                            child: Obx(() => SwitchListTile(
                              title: Text('Active Delivery Man'),
                              subtitle: Text(
                                  'Allow this delivery man to receive orders'),
                              value: controller.isActive.value,
                              onChanged: (value) =>
                              controller.isActive.value = value,
                              activeColor: AppColors.primary,
                            )),
                          ),

                          SizedBox(width: 16),

                          // Availability
                          Expanded(
                            child: Obx(() => SwitchListTile(
                              title: Text('Available Now'),
                              subtitle: Text(
                                  'Set current availability status'),
                              value: controller.isAvailable.value,
                              onChanged: (value) =>
                              controller.isAvailable.value = value,
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

              // Vehicle Information Card
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
                        'Vehicle Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 20),

                      Row(
                        children: [
                          // Vehicle Type
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: controller.selectedVehicleType.value,
                              decoration: InputDecoration(
                                labelText: 'Vehicle Type',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(Icons.directions_car),
                              ),
                              items: [
                                'Motorcycle',
                                'Car',
                                'Bicycle',
                                'Truck',
                                'Other'
                              ].map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) =>
                              controller.selectedVehicleType.value =
                                  value ?? '',
                            ),
                          ),

                          SizedBox(width: 16),

                          // Vehicle Number
                          Expanded(
                            child: CustomTextField(
                              controller: controller.vehicleNumberController,
                              label: 'Vehicle Number',
                              hintText: 'Enter vehicle number',
                              prefixIcon: Icon(Icons.confirmation_number),
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

              // Profile Image Card
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
                        'Profile Image',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Upload a profile image for the delivery man (Optional)',
                        style: TextStyle(
                          color: AppColors.gray,
                        ),
                      ),
                      SizedBox(height: 20),

                      Obx(() => ImageUploadWidget(
                        images: controller.profileImages,
                        onImagesSelected: (images) {
                          if (images.isNotEmpty) {
                            controller.profileImages.value = [images.first];
                          }
                        },
                        onImageRemoved: (index) {
                          controller.profileImages.clear();
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
                          : () => controller.addDeliveryMan(),
                      text: controller.isSubmitting.value
                          ? 'Adding...'
                          : 'Add Delivery Man',
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