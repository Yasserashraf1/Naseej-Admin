import '../constants/app_constants.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(AppConstants.emailPattern);
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must not exceed ${AppConstants.maxPasswordLength} characters';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Phone number validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(AppConstants.phonePattern);
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value, {int minLength = 2}) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < minLength) {
      return 'Name must be at least $minLength characters';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Number validation
  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }

    return null;
  }

  // Positive number validation
  static String? validatePositiveNumber(String? value, String fieldName) {
    final numberError = validateNumber(value, fieldName);
    if (numberError != null) return numberError;

    final number = double.parse(value!);
    if (number <= 0) {
      return '$fieldName must be greater than zero';
    }

    return null;
  }

  // Integer validation
  static String? validateInteger(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (int.tryParse(value) == null) {
      return 'Please enter a valid integer';
    }

    return null;
  }

  // Min length validation
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    return null;
  }

  // Max length validation
  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }

    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    final urlRegex = RegExp(AppConstants.urlPattern);
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // Price validation
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'Please enter a valid price';
    }

    if (price < 0) {
      return 'Price cannot be negative';
    }

    return null;
  }

  // Stock quantity validation
  static String? validateStockQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Stock quantity is required';
    }

    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Please enter a valid quantity';
    }

    if (quantity < 0) {
      return 'Quantity cannot be negative';
    }

    return null;
  }

  // Discount validation
  static String? validateDiscount(String? value, double originalPrice) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    final discount = double.tryParse(value);
    if (discount == null) {
      return 'Please enter a valid discount price';
    }

    if (discount < 0) {
      return 'Discount cannot be negative';
    }

    if (discount >= originalPrice) {
      return 'Discount must be less than original price';
    }

    return null;
  }

  // Product name validation
  static String? validateProductName(String? value) {
    return validateMinLength(
      value,
      AppConstants.minProductNameLength,
      'Product name',
    );
  }

  // Description validation
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }

    if (value.length > AppConstants.maxDescriptionLength) {
      return 'Description is too long (max ${AppConstants.maxDescriptionLength} characters)';
    }

    return null;
  }

  // Date validation
  static String? validateDate(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Please enter a valid date';
    }
  }

  // Future date validation
  static String? validateFutureDate(String? value, String fieldName) {
    final dateError = validateDate(value, fieldName);
    if (dateError != null) return dateError;

    final date = DateTime.parse(value!);
    if (date.isBefore(DateTime.now())) {
      return '$fieldName must be in the future';
    }

    return null;
  }
}