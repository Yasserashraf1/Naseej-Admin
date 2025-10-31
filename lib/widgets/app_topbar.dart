import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/colors.dart';
import '../features/auth/auth_controller.dart';

class AppTopbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const AppTopbar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title and Breadcrumb
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showBackButton)
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      iconSize: 20,
                    ),
                  SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4),
                  _buildBreadcrumb(),
                ],
              ),
            ),

            // Actions and User Info
            Row(
              children: [
                // Notifications
                _buildNotificationButton(),

                // User Menu
                _buildUserMenu(authController),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumb() {
    final currentRoute = Get.currentRoute;
    final routes = currentRoute.split('/').where((r) => r.isNotEmpty).toList();

    if (routes.isEmpty) {
      return SizedBox();
    }

    return Row(
      children: [
        Text(
          'Home',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.gray,
          ),
        ),
        ...routes.map((route) {
          return Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.chevron_right,
                  size: 12,
                  color: AppColors.gray,
                ),
              ),
              Text(
                _formatRouteName(route),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.gray,
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  String _formatRouteName(String route) {
    // Convert route name to display format
    // e.g., "orders" -> "Orders", "order-details" -> "Order Details"
    return route
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Widget _buildNotificationButton() {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            // Navigate to notifications page
          },
          icon: Icon(Icons.notifications_outlined),
          tooltip: 'Notifications',
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserMenu(AuthController authController) {
    return Obx(() {
      final user = authController.currentUser.value;
      return PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'profile':
              Get.toNamed('/profile');
              break;
            case 'settings':
              Get.toNamed('/settings');
              break;
            case 'logout':
              authController.logout();
              break;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'profile',
            child: Row(
              children: [
                Icon(Icons.person, size: 18),
                SizedBox(width: 8),
                Text('My Profile'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'settings',
            child: Row(
              children: [
                Icon(Icons.settings, size: 18),
                SizedBox(width: 8),
                Text('Settings'),
              ],
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout, size: 18, color: AppColors.error),
                SizedBox(width: 8),
                Text('Logout', style: TextStyle(color: AppColors.error)),
              ],
            ),
          ),
        ],
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGray),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: user?.profileImageUrl != null
                      ? DecorationImage(
                    image: NetworkImage(user!.profileImageUrl!),
                    fit: BoxFit.cover,
                  )
                      : null,
                  color: AppColors.lightGray,
                ),
                child: user?.profileImageUrl == null
                    ? Icon(Icons.person, size: 16, color: AppColors.gray)
                    : null,
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user?.name.split(' ').first ?? 'Admin',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user?.roleDisplayName ?? 'Admin',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                color: AppColors.gray,
                size: 16,
              ),
            ],
          ),
        ),
      );
    });
  }
}