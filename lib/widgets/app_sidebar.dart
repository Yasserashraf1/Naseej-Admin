import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/colors.dart';
import '../features/auth/auth_controller.dart';

class AppSidebar extends StatelessWidget {
  final String currentRoute;

  const AppSidebar({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo & Title
          Container(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.home,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Naseej Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  authController.getCurrentUserEmail() ?? 'Admin Panel',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Divider(color: Colors.white24, height: 1),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: '/dashboard',
                ),
                _buildMenuItem(
                  icon: Icons.inventory_2,
                  title: 'Products',
                  route: '/products',
                ),
                _buildMenuItem(
                  icon: Icons.category,
                  title: 'Categories',
                  route: '/categories',
                ),
                _buildMenuItem(
                  icon: Icons.shopping_cart,
                  title: 'Orders',
                  route: '/orders',
                ),
                _buildMenuItem(
                  icon: Icons.people,
                  title: 'Customers',
                  route: '/customers',
                ),
                _buildMenuItem(
                  icon: Icons.local_shipping,
                  title: 'Delivery Men',
                  route: '/delivery',
                ),
                _buildMenuItem(
                  icon: Icons.store,
                  title: 'Stores',
                  route: '/stores',
                ),
                Divider(color: Colors.white24, height: 32),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  route: '/settings',
                ),
                _buildMenuItem(
                  icon: Icons.person,
                  title: 'My Profile',
                  route: '/admin/profile',
                ),
              ],
            ),
          ),

          Divider(color: Colors.white24, height: 1),

          // Logout Button
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              _showLogoutDialog(context, authController);
            },
          ),

          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String route,
  }) {
    final isActive = currentRoute == route;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white70,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isActive,
        onTap: () {
          if (!isActive) {
            Get.offAllNamed(route);
          }
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthController authController) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout, color: AppColors.primary),
            SizedBox(width: 12),
            Text('Logout'),
          ],
        ),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}