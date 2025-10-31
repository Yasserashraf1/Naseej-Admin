import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color confirmColor;
  final Color cancelColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmColor = AppColors.primary,
    this.cancelColor = AppColors.gray,
    required this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      backgroundColor: AppColors.cardBg,
      child: Container(
        padding: EdgeInsets.all(24),
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? AppColors.error.withOpacity(0.2)
                        : AppColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    isDestructive ? Icons.warning : Icons.help_outline,
                    color: isDestructive ? AppColors.error : AppColors.warning,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Message
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkGray,
                height: 1.5,
              ),
            ),

            SizedBox(height: 24),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel ?? () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cancelColor,
                      side: BorderSide(color: cancelColor),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDestructive ? AppColors.error : confirmColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      confirmText,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Predefined dialog variants
class DeleteConfirmationDialog extends StatelessWidget {
  final String itemName;
  final VoidCallback onConfirm;
  final String itemType;

  const DeleteConfirmationDialog({
    Key? key,
    required this.itemName,
    required this.onConfirm,
    this.itemType = 'item',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Delete $itemType',
      message: 'Are you sure you want to delete "$itemName"? This action cannot be undone.',
      confirmText: 'Delete',
      confirmColor: AppColors.error,
      onConfirm: onConfirm,
      isDestructive: true,
    );
  }
}

class BlockConfirmationDialog extends StatelessWidget {
  final String userName;
  final VoidCallback onConfirm;

  const BlockConfirmationDialog({
    Key? key,
    required this.userName,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Block User',
      message: 'Are you sure you want to block $userName? They will not be able to access the system until unblocked.',
      confirmText: 'Block',
      confirmColor: AppColors.warning,
      onConfirm: onConfirm,
    );
  }
}

class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutConfirmationDialog({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      confirmColor: AppColors.primary,
      onConfirm: onConfirm,
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onConfirm;

  const SuccessDialog({
    Key? key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      backgroundColor: AppColors.cardBg,
      child: Container(
        padding: EdgeInsets.all(24),
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 32,
              ),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkGray,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}