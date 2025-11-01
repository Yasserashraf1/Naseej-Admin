import 'storage_service.dart';
import '../models/user_model.dart';
import '../models/admin_user.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userRoleKey = 'user_role';
  static const String _savedEmailKey = 'saved_email';

  // Demo credentials (in production, this should call a real API)
  static const Map<String, Map<String, String>> _demoUsers = {
    'admin@naseej.com': {
      'password': 'admin123',
      'name': 'Admin User',
      'role': 'Super Administrator',
      'id': '1',
    },
    'manager@naseej.com': {
      'password': 'manager123',
      'name': 'Manager User',
      'role': 'Store Manager',
      'id': '2',
    },
  };

  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(Duration(seconds: 1));

      // Check demo credentials
      if (_demoUsers.containsKey(email)) {
        final user = _demoUsers[email]!;
        if (user['password'] == password) {
          // Save authentication data
          await StorageService.saveString(_tokenKey, 'demo_token_${DateTime.now().millisecondsSinceEpoch}');
          await StorageService.saveString(_userEmailKey, email);
          await StorageService.saveString(_userNameKey, user['name']!);
          await StorageService.saveString(_userRoleKey, user['role']!);

          // Save email if remember me is checked
          if (rememberMe) {
            await StorageService.saveString(_savedEmailKey, email);
          } else {
            await StorageService.remove(_savedEmailKey);
          }

          return true;
        }
      }

      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await StorageService.remove(_tokenKey);
    await StorageService.remove(_userEmailKey);
    await StorageService.remove(_userNameKey);
    await StorageService.remove(_userRoleKey);
  }

  bool isLoggedIn() {
    final token = StorageService.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  String? getCurrentUserEmail() {
    return StorageService.getString(_userEmailKey);
  }

  String? getCurrentUserName() {
    return StorageService.getString(_userNameKey);
  }

  String? getCurrentUserRole() {
    return StorageService.getString(_userRoleKey);
  }

  // Return AdminUser (for compatibility with existing code)
  AdminUser? getCurrentUser() {
    final email = getCurrentUserEmail();
    final name = getCurrentUserName();
    final role = getCurrentUserRole();

    if (email != null && name != null && role != null) {
      // Find user ID from demo users
      String userId = '1';
      for (var entry in _demoUsers.entries) {
        if (entry.key == email) {
          userId = entry.value['id'] ?? '1';
          break;
        }
      }

      return AdminUser(
        id: userId,
        name: name,
        email: email,
        role: role,
        createdAt: DateTime.now(),
      );
    }

    return null;
  }

  // Return UserModel (for auth controller)
  UserModel? getCurrentUserModel() {
    final email = getCurrentUserEmail();
    final name = getCurrentUserName();
    final role = getCurrentUserRole();

    if (email != null && name != null && role != null) {
      // Find user ID from demo users
      String userId = '1';
      for (var entry in _demoUsers.entries) {
        if (entry.key == email) {
          userId = entry.value['id'] ?? '1';
          break;
        }
      }

      return UserModel(
        id: userId,
        name: name,
        email: email,
        role: role,
        createdAt: DateTime.now(),
      );
    }

    return null;
  }

  Future<void> updateUserData({
    required String name,
    required String email,
  }) async {
    await StorageService.saveString(_userNameKey, name);
    await StorageService.saveString(_userEmailKey, email);
  }

  // Update profile (returns Map for compatibility)
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    String? phone,
  }) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      await updateUserData(name: name, email: email);
      return {'status': 'success', 'message': 'Profile updated successfully'};
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to update profile'};
    }
  }

  // Change password (returns Map for compatibility)
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      // In production, verify old password and update
      return {'status': 'success', 'message': 'Password changed successfully'};
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to change password'};
    }
  }

  String? getSavedEmail() {
    return StorageService.getString(_savedEmailKey);
  }

  String? getAuthToken() {
    return StorageService.getString(_tokenKey);
  }
}