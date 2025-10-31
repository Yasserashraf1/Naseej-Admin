import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/validators.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import 'package:naseej_admin/features/auth/auth_controller.dart';

class AdminProfilePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  AdminProfilePage({Key? key}) : super(key: key) {
    // Initialize with current user data
    final user = authController.currentUser.value;
    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
      phoneController.text = user.phone ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: authController.userProfileImage != null
                          ? NetworkImage(authController.userProfileImage!)
                          : null,
                      child: authController.userProfileImage == null
                          ? Icon(Icons.person, size: 40)
                          : null,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authController.userName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            authController.userEmail,
                            style: TextStyle(
                              color: AppColors.gray,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            authController.userRole,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Change profile picture
                      },
                      icon: Icon(Icons.camera_alt),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Profile Form
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Name
                      CustomTextField(
                        controller: nameController,
                        label: 'Full Name',
                        hintText: 'Enter your full name',
                        validator: (value) =>
                            Validators.validateName(value, minLength: 2),
                        prefixIcon: Icon(Icons.person), isPassword: false,
                      ),

                      SizedBox(height: 16),

                      // Email
                      CustomTextField(
                        controller: emailController,
                        label: 'Email Address',
                        hintText: 'Enter your email',
                        validator: (value) => Validators.validateEmail(value),
                        prefixIcon: Icon(Icons.email),
                        isPassword: false,
                      ),

                      SizedBox(height: 16),

                      // Phone
                      CustomTextField(
                        controller: phoneController,
                        label: 'Phone Number',
                        hintText: 'Enter your phone number',
                        validator: (value) => value!.isEmpty
                            ? null
                            : Validators.validatePhone(value),
                        prefixIcon: Icon(Icons.phone),
                        isPassword: false,
                      ),

                      SizedBox(height: 30),

                      // Update Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _updateProfile();
                            }
                          },
                          child: Text('Update Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Change Password
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
                      'Change Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 20),

                    Text(
                      'For security reasons, you can change your password here.',
                      style: TextStyle(
                        color: AppColors.gray,
                      ),
                    ),

                    SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          _showChangePasswordDialog();
                        },
                        child: Text('Change Password'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _updateProfile() async {
    try {
      // Show loading
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
        barrierDismissible: false,
      );

      final response = await authController.updateProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );

      Get.back(); // Close loading dialog

      if (response['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to update profile',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: oldPasswordController,
              label: 'Current Password',
              hintText: 'Enter current password',
              isPassword: true,
              validator: (value) =>
                  Validators.validateRequired(value, 'Current password'),
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: newPasswordController,
              label: 'New Password',
              hintText: 'Enter new password',
              isPassword: true,
              validator: (value) => Validators.validatePassword(value),
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: confirmPasswordController,
              label: 'Confirm New Password',
              hintText: 'Confirm new password',
              isPassword: true,
              validator: (value) => Validators.validateConfirmPassword(
                  value, newPasswordController.text),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (oldPasswordController.text.isEmpty ||
                  newPasswordController.text.isEmpty ||
                  confirmPasswordController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please fill all fields',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              if (newPasswordController.text != confirmPasswordController.text) {
                Get.snackbar(
                  'Error',
                  'Passwords do not match',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              try {
                Get.back(); // Close dialog
                Get.dialog(
                  Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                  barrierDismissible: false,
                );

                final response = await authController.changePassword(
                  oldPassword: oldPasswordController.text,
                  newPassword: newPasswordController.text,
                );

                Get.back(); // Close loading dialog

                if (response['status'] == 'success') {
                  Get.snackbar(
                    'Success',
                    'Password changed successfully',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    response['message'] ?? 'Failed to change password',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              } catch (e) {
                Get.back(); // Close loading dialog
                Get.snackbar(
                  'Error',
                  'Failed to change password: $e',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: Text('Change Password'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}