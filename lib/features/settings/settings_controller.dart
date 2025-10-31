import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/models/admin_user.dart';
import '../../core/utils/validators.dart';

class SettingsController extends GetxController {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  // Profile Form
  final profileFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // App Settings
  final themeMode = Rx<String>('light');
  final language = Rx<String>('en');
  final notificationsEnabled = Rx<bool>(true);
  final autoBackupEnabled = Rx<bool>(true);
  final backupFrequency = Rx<String>('daily');

  // Observable states
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final currentUser = Rx<AdminUser?>(null);

  // Image handling
  final profileImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadSettings();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Load user data
  void _loadUserData() {
    currentUser.value = _authService.getCurrentUser();
    if (currentUser.value != null) {
      nameController.text = currentUser.value!.name;
      emailController.text = currentUser.value!.email;
      phoneController.text = currentUser.value!.phone ?? '';
    }
  }

  // Load app settings
  void _loadSettings() {
    themeMode.value = StorageService.getThemeMode();
    language.value = StorageService.getLanguage();
    notificationsEnabled.value = StorageService.getBool('notifications_enabled') ?? true;
    autoBackupEnabled.value = StorageService.getBool('auto_backup_enabled') ?? true;
    backupFrequency.value = StorageService.getString('backup_frequency') ?? 'daily';
  }

  // Update profile
  Future<void> updateProfile() async {
    if (!profileFormKey.currentState!.validate()) {
      return;
    }

    try {
      isSubmitting.value = true;

      final response = await _authService.updateProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );

      if (response['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Reload user data
        _loadUserData();
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to update profile',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Change password
  Future<void> changePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'New passwords do not match',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      final response = await _authService.changePassword(
        oldPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      );

      if (response['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Password changed successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear password fields
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to change password',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change password: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Update theme mode
  void updateThemeMode(String mode) {
    themeMode.value = mode;
    StorageService.saveThemeMode(mode);

    // Apply theme change
    if (mode == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    } else if (mode == 'light') {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.system);
    }
  }

  // Update language
  void updateLanguage(String lang) {
    language.value = lang;
    StorageService.saveLanguage(lang);

    // Apply language change
    // You would typically use Get.updateLocale here
    Get.snackbar(
      'Language Updated',
      'App language changed to ${lang == 'en' ? 'English' : 'Arabic'}',
    );
  }

  // Toggle notifications
  void toggleNotifications(bool enabled) {
    notificationsEnabled.value = enabled;
    StorageService.saveBool('notifications_enabled', enabled);
  }

  // Toggle auto backup
  void toggleAutoBackup(bool enabled) {
    autoBackupEnabled.value = enabled;
    StorageService.saveBool('auto_backup_enabled', enabled);
  }

  // Update backup frequency
  void updateBackupFrequency(String frequency) {
    backupFrequency.value = frequency;
    StorageService.saveString('backup_frequency', frequency);
  }

  // Export data
  Future<void> exportData(String format) async {
    try {
      isLoading.value = true;

      // Simulate export process
      await Future.delayed(Duration(seconds: 2));

      Get.snackbar(
        'Export Successful',
        'Data exported as $format file',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Export Failed',
        'Failed to export data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear cache
  Future<void> clearCache() async {
    try {
      isLoading.value = true;

      // Clear cached data (excluding user data and settings)
      final keys = await StorageService.getAllKeys();
      for (final key in keys) {
        if (!key.startsWith('admin_') && key != 'theme_mode' && key != 'language') {
          await StorageService.remove(key);
        }
      }

      Get.snackbar(
        'Cache Cleared',
        'All cached data has been cleared',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear cache: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Upload profile image
  Future<void> uploadProfileImage(File image) async {
    try {
      isLoading.value = true;
      profileImage.value = image;

      // Simulate upload process
      await Future.delayed(Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Profile image updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload profile image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get app version
  String get appVersion => '1.0.0+1';

  // Get build number
  String get buildNumber => '2024.01.001';

  // Get storage usage
  Future<Map<String, dynamic>> getStorageUsage() async {
    // Simulate storage calculation
    return {
      'used': 245.6, // MB
      'total': 1024.0, // MB
      'percentage': 24.0,
    };
  }

  // Validate name
  String? validateName(String? value) {
    return Validators.validateName(value, minLength: 2);
  }

  // Validate email
  String? validateEmail(String? value) {
    return Validators.validateEmail(value);
  }

  // Validate password
  String? validatePassword(String? value) {
    return Validators.validatePassword(value);
  }

  // Validate phone
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return null; // Optional field
    return Validators.validatePhone(value);
  }
}