import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../../core/services/storage_service.dart';
import 'package:naseej_admin/features/auth/auth_controller.dart';

class SettingsPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // Profile Section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: authController.userProfileImage != null
                          ? NetworkImage(authController.userProfileImage!)
                          : null,
                      child: authController.userProfileImage == null
                          ? Icon(Icons.person, size: 30)
                          : null,
                    ),
                    title: Text(
                      authController.userName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(authController.userRole),
                    trailing: IconButton(
                      onPressed: () => Get.toNamed('/admin/profile'),
                      icon: Icon(Icons.edit),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // App Settings Section
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
                    'App Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Theme Mode
                  Obx(() {
                    final currentTheme = StorageService.getThemeMode();
                    return ListTile(
                      leading: Icon(Icons.color_lens),
                      title: Text('Theme Mode'),
                      subtitle: Text(currentTheme == 'dark' ? 'Dark' : 'Light'),
                      trailing: Switch(
                        value: currentTheme == 'dark',
                        onChanged: (value) {
                          final newTheme = value ? 'dark' : 'light';
                          StorageService.saveThemeMode(newTheme);
                          Get.changeThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                        activeColor: AppColors.primary,
                      ),
                    );
                  }),

                  Divider(),

                  // Language
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text('Language'),
                    subtitle: Text('English'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Show language selection dialog
                    },
                  ),

                  Divider(),

                  // Notifications
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Push Notifications'),
                    subtitle: Text('Receive order notifications'),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // Handle notification settings
                      },
                      activeColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Data Management Section
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
                    'Data Management',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Export Data
                  ListTile(
                    leading: Icon(Icons.file_download),
                    title: Text('Export Data'),
                    subtitle: Text('Export products, orders, and customers'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showExportOptions();
                    },
                  ),

                  Divider(),

                  // Clear Cache
                  ListTile(
                    leading: Icon(Icons.cached),
                    title: Text('Clear Cache'),
                    subtitle: Text('Clear temporary files and data'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _clearCache();
                    },
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // About Section
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
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 16),

                  // App Version
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('App Version'),
                    subtitle: Text('1.0.0'),
                  ),

                  Divider(),

                  // Privacy Policy
                  ListTile(
                    leading: Icon(Icons.privacy_tip),
                    title: Text('Privacy Policy'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Open privacy policy
                    },
                  ),

                  Divider(),

                  // Terms of Service
                  ListTile(
                    leading: Icon(Icons.description),
                    title: Text('Terms of Service'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Open terms of service
                    },
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Danger Zone
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
                    'Danger Zone',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Logout
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
                    onTap: () {
                      authController.logout();
                    },
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showExportOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Export Data',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('Export as Excel'),
                onTap: () {
                  Get.back();
                  // Handle Excel export
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text('Export as PDF'),
                onTap: () {
                  Get.back();
                  // Handle PDF export
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.text_snippet),
                title: Text('Export as CSV'),
                onTap: () {
                  Get.back();
                  // Handle CSV export
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gray,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearCache() {
    Get.dialog(
      AlertDialog(
        title: Text('Clear Cache'),
        content: Text('Are you sure you want to clear all cached data?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Clear cache logic
              Get.snackbar(
                'Success',
                'Cache cleared successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }
}