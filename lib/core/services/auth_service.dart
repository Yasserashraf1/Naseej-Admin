import '../constants/api_endpoints.dart';
import '../models/admin_user.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.postForm(
        ApiEndpoints.adminLogin,
        {
          'email': email,
          'password': password,
        },
      );

      if (response['status'] == 'success') {
        // Save token
        if (response['token'] != null) {
          await StorageService.saveToken(response['token']);
        }

        // Save user data
        if (response['data'] != null) {
          final user = AdminUser.fromJson(response['data']);
          await StorageService.saveUser(user);
        }
      }

      return response;
    } catch (e) {
      return {'status': 'error', 'message': 'Login failed: $e'};
    }
  }

  // Register (if needed for new admins)
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _apiService.postForm(
        ApiEndpoints.adminRegister,
        {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        },
      );

      return response;
    } catch (e) {
      return {'status': 'error', 'message': 'Registration failed: $e'};
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      // Call logout API (optional)
      await _apiService.post(ApiEndpoints.adminLogout, {});

      // Clear local storage
      await StorageService.clearAll();

      return {'status': 'success', 'message': 'Logged out successfully'};
    } catch (e) {
      // Even if API fails, clear local storage
      await StorageService.clearAll();
      return {'status': 'success', 'message': 'Logged out successfully'};
    }
  }

  // Get current user
  AdminUser? getCurrentUser() {
    return StorageService.getUser();
  }

  // Check if logged in
  bool isLoggedIn() {
    return StorageService.isLoggedIn;
  }

  // Get user profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiService.get(ApiEndpoints.adminProfile);

      if (response['status'] == 'success' && response['data'] != null) {
        final user = AdminUser.fromJson(response['data']);
        await StorageService.saveUser(user);
      }

      return response;
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to fetch profile: $e'};
    }
  }

  // Update profile
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (phone != null) data['phone'] = phone;

      final response = await _apiService.post(
        ApiEndpoints.adminProfile,
        data,
      );

      if (response['status'] == 'success' && response['data'] != null) {
        final user = AdminUser.fromJson(response['data']);
        await StorageService.saveUser(user);
      }

      return response;
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to update profile: $e'};
    }
  }

  // Change password
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post(
        '${ApiEndpoints.baseUrl}/admin/change_password.php',
        {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      return response;
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to change password: $e'};
    }
  }

  // Refresh token (if using JWT with refresh tokens)
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final response = await _apiService.post(
        '${ApiEndpoints.baseUrl}/admin/refresh_token.php',
        {},
      );

      if (response['status'] == 'success' && response['token'] != null) {
        await StorageService.saveToken(response['token']);
      }

      return response;
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to refresh token: $e'};
    }
  }
}