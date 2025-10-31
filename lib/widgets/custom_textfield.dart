import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hintText;
  final String? errorText;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final IconData? prefixIconData;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;
  final bool showCounter;
  final bool autoFocus;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry contentPadding;

  const CustomTextField({
    Key? key,
    this.controller,
    required this.label,
    this.hintText = '',
    this.errorText,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.prefixIcon,
    this.prefixIconData,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.showCounter = false,
    this.autoFocus = false,
    this.focusNode,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12), required bool isPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.darkGray,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autoFocus,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          validator: validator,
          maxLines: maxLines,
          maxLength: maxLength,
          style: TextStyle(
            color: enabled ? AppColors.darkGray : AppColors.gray,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.gray,
            ),
            errorText: errorText,
            prefixIcon: prefixIcon ?? (prefixIconData != null
                ? Icon(
              prefixIconData,
              color: AppColors.gray,
              size: 20,
            )
                : null),
            suffixIcon: suffixIcon,
            contentPadding: contentPadding,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.lightGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.lightGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.lightGray.withOpacity(0.5)),
            ),
            filled: !enabled,
            fillColor: !enabled ? AppColors.background : null,
            counterText: showCounter ? null : '',
          ),
        ),
      ],
    );
  }
}

// Specialized text field variants
class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Function(String)? onChanged;
  final VoidCallback? onTap;

  const SearchTextField({
    Key? key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      prefixIconData: Icons.search,
      onChanged: onChanged,
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), label: '',
      isPassword: false,
    );
  }
}

class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? Function(String?)? validator;
  final bool enabled;

  const EmailTextField({
    Key? key,
    this.controller,
    this.label = 'Email',
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hintText: 'Enter your email',
      keyboardType: TextInputType.emailAddress,
      prefixIconData: Icons.email,
      validator: validator,
      enabled: enabled,
      isPassword: false,
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final String? Function(String?)? validator;
  final bool enabled;

  const PasswordTextField({
    Key? key,
    this.controller,
    this.label = 'Password',
    this.obscureText = true,
    this.onToggleVisibility,
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hintText: 'Enter your password',
      obscureText: obscureText,
      prefixIconData: Icons.lock,
      suffixIcon: IconButton(
        onPressed: onToggleVisibility,
        icon: Icon(
          obscureText ? Icons.visibility : Icons.visibility_off,
          color: AppColors.gray,
        ),
      ),
      validator: validator,
      enabled: enabled,
      isPassword: true,

    );
  }
}

class PhoneTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? Function(String?)? validator;
  final bool enabled;

  const PhoneTextField({
    Key? key,
    this.controller,
    this.label = 'Phone Number',
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hintText: 'Enter phone number',
      keyboardType: TextInputType.phone,
      prefixIconData: Icons.phone,
      validator: validator,
      enabled: enabled,
      isPassword: false,
    );
  }
}

class NumberTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final bool enabled;

  const NumberTextField({
    Key? key,
    this.controller,
    required this.label,
    this.hintText = 'Enter number',
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      keyboardType: TextInputType.number,
      prefixIconData: Icons.numbers,
      validator: validator,
      enabled: enabled,
      isPassword: false,
    );
  }
}

class MultilineTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hintText;
  final int maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final bool enabled;

  const MultilineTextField({
    Key? key,
    this.controller,
    required this.label,
    this.hintText = 'Enter text...',
    this.maxLines = 4,
    this.maxLength,
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      maxLines: maxLines,
      maxLength: maxLength,
      prefixIconData: Icons.text_fields,
      validator: validator,
      enabled: enabled,
      isPassword: false,
    );
  }
}