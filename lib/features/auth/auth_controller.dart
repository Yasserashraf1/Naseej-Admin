import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../core/models/user_model.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool rememberMe = false.obs;

  // User properties
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  // Getters for user properties
  String get userName => currentUser.value?.name ?? getCurrentUserName() ?? 'Admin';
  String get userEmail => currentUser.value?.email ?? getCurrentUserEmail() ?? '';
  String get userRole => currentUser.value?.role ?? getCurrentUserRole() ?? 'Administrator';
  String? get userProfileImage => currentUser.value?.profileImage;

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
    _loadCurrentUser();
    print('🎉 AuthController initialized');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _loadSavedCredentials() {
    final savedEmail = _authService.getSavedEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      emailController.text = savedEmail;
      rememberMe.value = true;
    }
  }

  void _loadCurrentUser() {
    if (_authService.isLoggedIn()) {
      currentUser.value = _authService.getCurrentUserModel();
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> login() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Validation Error',
        'Please fill in all fields correctly',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
        duration: Duration(seconds: 3),
      );
      return;
    }

    try {
      isLoading.value = true;

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      print('🔐 Attempting login with: $email');

      // Perform login
      final success = await _authService.login(
        email: email,
        password: password,
        rememberMe: rememberMe.value,
      );

      if (success) {
        print('✅ Login successful');

        // Load current user
        _loadCurrentUser();

        Get.snackbar(
          'Success',
          'Welcome to Naseej Admin!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
          icon: Icon(Icons.check_circle_outline, color: Colors.white),
          duration: Duration(seconds: 2),
        );

        // Navigate to dashboard
        await Future.delayed(Duration(milliseconds: 500));
        Get.offAllNamed('/dashboard');
      } else {
        print('❌ Login failed');
        _showErrorSnackbar('Invalid email or password');
      }
    } catch (e) {
      print('💥 Login error: $e');
      _showErrorSnackbar('An error occurred during login. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      await _authService.logout();
      currentUser.value = null;

      Get.snackbar(
        'Logged Out',
        'You have been successfully logged out',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.withOpacity(0.9),
        colorText: Colors.white,
        icon: Icon(Icons.exit_to_app, color: Colors.white),
        duration: Duration(seconds: 2),
      );

      // Navigate to login
      await Future.delayed(Duration(milliseconds: 500));
      Get.offAllNamed('/login');
    } catch (e) {
      print('💥 Logout error: $e');
      _showErrorSnackbar('An error occurred during logout');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    String? phone,
    String? profileImage,
  }) async {
    try {
      isLoading.value = true;

      final response = await _authService.updateProfile(
        name: name,
        email: email,
        phone: phone,
      );

      if (response['status'] == 'success') {
        // Update current user
        currentUser.value = UserModel(
          id: currentUser.value?.id ?? '1',
          name: name,
          email: email,
          role: currentUser.value?.role ?? 'Administrator',
          phone: phone,
          profileImage: profileImage,
        );

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
          icon: Icon(Icons.check_circle_outline, color: Colors.white),
        );
      }

      return response;
    } catch (e) {
      print('💥 Update profile error: $e');
      _showErrorSnackbar('Failed to update profile');
      return {'status': 'error', 'message': 'Failed to update profile'};
    } finally {
      isLoading.value = false;
    }
  }

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
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
          icon: Icon(Icons.check_circle_outline, color: Colors.white),
        );
      }

      return response;
    } catch (e) {
      print('💥 Change password error: $e');
      _showErrorSnackbar('Failed to change password');
      return {'status': 'error', 'message': 'Failed to change password'};
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      icon: Icon(Icons.error_outline, color: Colors.white),
      duration: Duration(seconds: 3),
    );
  }

  bool isLoggedIn() {
    return _authService.isLoggedIn();
  }

  String? getCurrentUserEmail() {
    return _authService.getCurrentUserEmail();
  }

  String? getCurrentUserName() {
    return _authService.getCurrentUserName();
  }

  String? getCurrentUserRole() {
    return _authService.getCurrentUserRole();
  }
}