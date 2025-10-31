import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final bool isLoading;
  final bool disabled;
  final bool small;
  final bool outlined;
  final IconData? icon;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = Colors.white,
    this.borderColor,
    this.isLoading = false,
    this.disabled = false,
    this.small = false,
    this.outlined = false,
    this.icon,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !disabled && !isLoading;
    final actualBorderColor = borderColor ?? backgroundColor;

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        padding: small
            ? EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            : padding,
        decoration: BoxDecoration(
          color: outlined
              ? Colors.transparent
              : (isEnabled ? backgroundColor : backgroundColor.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(borderRadius),
          border: outlined
              ? Border.all(
            color: isEnabled
                ? actualBorderColor
                : actualBorderColor.withOpacity(0.5),
            width: 2,
          )
              : null,
          boxShadow: isEnabled && !outlined
              ? [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: small ? 16 : 20,
                height: small ? 16 : 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foregroundColor,
                ),
              ),
              SizedBox(width: small ? 8 : 12),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: small ? 16 : 20,
                color: isEnabled
                    ? foregroundColor
                    : foregroundColor.withOpacity(0.5),
              ),
              SizedBox(width: small ? 8 : 12),
            ],
            Text(
              text,
              style: TextStyle(
                color: isEnabled
                    ? foregroundColor
                    : foregroundColor.withOpacity(0.5),
                fontSize: small ? 14 : 16,
                fontWeight: small ? FontWeight.w500 : FontWeight.w600,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Predefined button variants
class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool disabled;
  final bool small;
  final IconData? icon;

  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.disabled = false,
    this.small = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      text: text,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      isLoading: isLoading,
      disabled: disabled,
      small: small,
      icon: icon,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool disabled;
  final bool small;
  final IconData? icon;

  const SecondaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.disabled = false,
    this.small = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      text: text,
      backgroundColor: AppColors.secondary,
      foregroundColor: Colors.white,
      isLoading: isLoading,
      disabled: disabled,
      small: small,
      icon: icon,
    );
  }
}

class SuccessButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool disabled;
  final bool small;
  final IconData? icon;

  const SuccessButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.disabled = false,
    this.small = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      text: text,
      backgroundColor: AppColors.success,
      foregroundColor: Colors.white,
      isLoading: isLoading,
      disabled: disabled,
      small: small,
      icon: icon,
    );
  }
}

class DangerButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool disabled;
  final bool small;
  final IconData? icon;

  const DangerButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.disabled = false,
    this.small = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      text: text,
      backgroundColor: AppColors.error,
      foregroundColor: Colors.white,
      isLoading: isLoading,
      disabled: disabled,
      small: small,
      icon: icon,
    );
  }
}

class OutlineButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color color;
  final bool isLoading;
  final bool disabled;
  final bool small;
  final IconData? icon;

  const OutlineButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.color = AppColors.primary,
    this.isLoading = false,
    this.disabled = false,
    this.small = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      text: text,
      backgroundColor: Colors.transparent,
      foregroundColor: color,
      borderColor: color,
      isLoading: isLoading,
      disabled: disabled,
      small: small,
      outlined: true,
      icon: icon,
    );
  }
}