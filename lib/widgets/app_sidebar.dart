import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/colors.dart';
import '../features/auth/auth_controller.dart';
import '../core/models/admin_user.dart';

class AppSidebar extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final String currentRoute;

  AppSidebar({Key? key, required this.currentRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
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
          // Header
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // App Logo/Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.home,//carpet
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Naseej Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Obx(() {
                        final user = authController.currentUser.value;
                        return Text(
                          user?.roleDisplayName ?? 'Admin',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // User Info
          Obx(() {
            final user = authController.currentUser.value;
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(
                  bottom: BorderSide(color: AppColors.lightGray),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: user?.profileImageUrl != null
                          ? DecorationImage(
                        image: NetworkImage(user!.profileImageUrl!),
                        fit: BoxFit.cover,
                      )
                          : null,
                      color: AppColors.lightGray,
                    ),
                    child: user?.profileImageUrl == null
                        ? Icon(Icons.person, color: AppColors.gray)
                        : null,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Admin User',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          user?.email ?? 'admin@naseej.com',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.gray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          // Navigation Menu
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildMenuSection('MAIN'),
                _buildMenuItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: '/dashboard',
                  isActive: currentRoute == '/dashboard',
                ),
                _buildMenuItem(
                  icon: Icons.shopping_bag,
                  title: 'Orders',
                  route: '/orders',
                  isActive: currentRoute.startsWith('/orders'),
                ),
                _buildMenuItem(
                  icon: Icons.inventory,
                  title: 'Products',
                  route: '/products',
                  isActive: currentRoute.startsWith('/products'),
                ),
                _buildMenuItem(
                  icon: Icons.category,
                  title: 'Categories',
                  route: '/categories',
                  isActive: currentRoute.startsWith('/categories'),
                ),

                _buildMenuSection('MANAGEMENT'),
                _buildMenuItem(
                  icon: Icons.people,
                  title: 'Customers',
                  route: '/customers',
                  isActive: currentRoute.startsWith('/customers'),
                ),
                _buildMenuItem(
                  icon: Icons.delivery_dining,
                  title: 'Delivery Men',
                  route: '/delivery',
                  isActive: currentRoute.startsWith('/delivery'),
                ),
                _buildMenuItem(
                  icon: Icons.store,
                  title: 'Stores',
                  route: '/stores',
                  isActive: currentRoute.startsWith('/stores'),
                ),

                _buildMenuSection('REPORTS'),
                _buildMenuItem(
                  icon: Icons.analytics,
                  title: 'Sales Reports',
                  route: '/reports/sales',
                  isActive: currentRoute.startsWith('/reports/sales'),
                ),
                _buildMenuItem(
                  icon: Icons.inventory_2,
                  title: 'Inventory Reports',
                  route: '/reports/inventory',
                  isActive: currentRoute.startsWith('/reports/inventory'),
                ),

                _buildMenuSection('SETTINGS'),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  route: '/settings',
                  isActive: currentRoute.startsWith('/settings'),
                ),
                _buildMenuItem(
                  icon: Icons.person,
                  title: 'Profile',
                  route: '/profile',
                  isActive: currentRoute.startsWith('/profile'),
                ),

                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 10),

                // Logout Button
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: AppColors.error,
                    size: 20,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => authController.logout(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 8, left: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.gray,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String route,
    required bool isActive,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isActive
            ? Border.all(color: AppColors.primary.withOpacity(0.3))
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppColors.primary : AppColors.gray,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? AppColors.primary : AppColors.darkGray,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isActive
            ? Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        )
            : null,
        onTap: () {
          if (!isActive) {
            Get.offAllNamed(route);
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        minLeadingWidth: 0,
      ),
    );
  }
}