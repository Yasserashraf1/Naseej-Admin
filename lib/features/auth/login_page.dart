import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/validators.dart';
import 'auth_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.secondary,
              AppColors.gold,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Container(
                constraints: BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(48),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.admin_panel_settings,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 32),

                          // Title
                          Text(
                            'Naseej Admin',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            'Dashboard Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.gray,
                            ),
                          ),

                          SizedBox(height: 40),

                          // Email Field
                          TextFormField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.validateEmail,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'admin@naseej.com',
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          SizedBox(height: 24),

                          // Password Field
                          Obx(() => TextFormField(
                            controller: controller.passwordController,
                            obscureText: !controller.isPasswordVisible.value,
                            validator: Validators.validatePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: '••••••••',
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )),

                          SizedBox(height: 16),

                          // Remember Me & Forgot Password
                          Row(
                            children: [
                              Obx(() => Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: controller.toggleRememberMe,
                                activeColor: AppColors.primary,
                              )),
                              Text('Remember me'),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  Get.snackbar(
                                    'Coming Soon',
                                    'Forgot password feature will be available soon',
                                    snackPosition: SnackPosition.TOP,
                                  );
                                },
                                child: Text('Forgot Password?'),
                              ),
                            ],
                          ),

                          SizedBox(height: 32),

                          // Login Button
                          Obx(() => SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: controller.isLoading.value
                                  ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login),
                                  SizedBox(width: 8),
                                  Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),

                          SizedBox(height: 32),

                          // Demo Credentials (Remove in production)
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.gold.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Demo Credentials',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Email: admin@naseej.com',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Password: admin123',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24),

                          // Footer
                          Text(
                            '© 2025 Naseej. All rights reserved.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}