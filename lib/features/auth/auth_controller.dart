import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../core/models/admin_user.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable states - FIXED: Use simple Rx types
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final currentUser = Rxn<AdminUser>(); // FIXED: Use Rxn instead of Rx<AdminUser?>

  // Form key
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Load current user from storage
  void _loadCurrentUser() {
    currentUser.value = _authService.getCurrentUser();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Toggle remember me
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  // Login
  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (response['status'] == 'success') {
        // Load user data
        _loadCurrentUser();

        // Show success message
        Get.snackbar(
          'Success',
          'Welcome back, ${currentUser.value?.name ?? 'Admin'}!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        // Navigate to dashboard
        Get.offAllNamed('/dashboard');
      } else {
        // Show error message
        Get.snackbar(
          'Login Failed',
          response['message'] ?? 'Invalid email or password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Logout'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        isLoading.value = true;

        await _authService.logout();

        // Clear user data
        currentUser.value = null;

        // Show success message
        Get.snackbar(
          'Logged Out',
          'You have been successfully logged out',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        // Navigate to login
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update profile
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      isLoading.value = true;

      final response = await _authService.updateProfile(
        name: name,
        email: email,
        phone: phone,
      );

      if (response['status'] == 'success') {
        // Reload user data
        _loadCurrentUser();

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

      return response;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return {'status': 'error', 'message': 'Failed to update profile: $e'};
    } finally {
      isLoading.value = false;
    }
  }

  // Change password
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;

      final response = await _authService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

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

      return response;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change password: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return {'status': 'error', 'message': 'Failed to change password: $e'};
    } finally {
      isLoading.value = false;
    }
  }

  // Check if user is logged in - FIXED: Make this a simple getter
  bool get isLoggedIn => _authService.isLoggedIn();

  // Get user name - FIXED: Use proper reactive access
  String get userName => currentUser.value?.name ?? 'Admin';

  // Get user email
  String get userEmail => currentUser.value?.email ?? '';

  // Get user role
  String get userRole => currentUser.value?.roleDisplayName ?? '';

  // Get user profile image
  String? get userProfileImage => currentUser.value?.profileImageUrl;

  // Refresh user data
  Future<void> refreshUserData() async {
    try {
      final response = await _authService.getProfile();
      if (response['status'] == 'success') {
        _loadCurrentUser();
      }
    } catch (e) {
      print('Failed to refresh user data: $e');
    }
  }

  // Clear form
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    isPasswordVisible.value = false;
    rememberMe.value = false;
  }
}