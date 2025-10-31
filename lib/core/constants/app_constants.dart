class AppConstants {
  // App Info
  static const String appName = 'Naseej Admin Dashboard';
  static const String appVersion = '1.0.0';
  static const String companyName = 'Naseej Handmade Carpets';

  // Pagination
  static const int itemsPerPage = 20;
  static const int maxItemsPerPage = 100;

  // Image Upload
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Order Status
  static const String orderPending = '0';
  static const String orderPreparing = '1';
  static const String orderReady = '2';
  static const String orderOnWay = '3';
  static const String orderDelivered = '4';
  static const String orderCancelled = '5';

  static const Map<String, String> orderStatusLabels = {
    '0': 'Pending Approval',
    '1': 'Preparing',
    '2': 'Ready for Pickup',
    '3': 'On the Way',
    '4': 'Delivered',
    '5': 'Cancelled',
  };

  // Payment Methods
  static const String paymentCash = '0';
  static const String paymentCard = '1';

  static const Map<String, String> paymentMethodLabels = {
    '0': 'Cash on Delivery',
    '1': 'Payment Card',
  };

  // Delivery Types
  static const String deliveryHome = '0';
  static const String deliveryPickup = '1';

  static const Map<String, String> deliveryTypeLabels = {
    '0': 'Home Delivery',
    '1': 'Store Pickup',
  };

  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleSuperAdmin = 'super_admin';
  static const String roleManager = 'manager';

  // Storage Keys
  static const String storageToken = 'admin_token';
  static const String storageUser = 'admin_user';
  static const String storageTheme = 'theme_mode';
  static const String storageLanguage = 'language';

  // Chart Types
  static const String chartDaily = 'daily';
  static const String chartWeekly = 'weekly';
  static const String chartMonthly = 'monthly';
  static const String chartYearly = 'yearly';

  // Export Formats
  static const String exportPDF = 'pdf';
  static const String exportExcel = 'excel';
  static const String exportCSV = 'csv';

  // Carpet Sizes
  static const List<String> carpetSizes = [
    'Small (4x6 ft)',
    'Medium (6x9 ft)',
    'Large (8x10 ft)',
    'X-Large (9x12 ft)',
    'Custom',
  ];

  // Carpet Colors
  static const List<String> carpetColors = [
    'Burgundy',
    'Gold',
    'Brown',
    'Cream',
    'Multi-color',
    'Blue',
    'Green',
    'Red',
  ];

  // Carpet Materials
  static const List<String> carpetMaterials = [
    'Wool',
    'Silk',
    'Cotton',
    'Wool & Silk Blend',
    'Synthetic',
  ];

  // Countries
  static const List<String> countries = [
    'Egypt',
    'Saudi Arabia',
    'UAE',
    'Kuwait',
    'Qatar',
    'Bahrain',
    'Oman',
    'Jordan',
    'Lebanon',
    'Other',
  ];

  // Currency
  static const String currency = 'EGP';
  static const String currencySymbol = '£';

  // API Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minProductNameLength = 3;
  static const int maxProductNameLength = 100;
  static const int maxDescriptionLength = 1000;

  // Messages
  static const String successMessage = 'Operation completed successfully';
  static const String errorMessage = 'An error occurred. Please try again';
  static const String networkErrorMessage = 'Network error. Check your connection';
  static const String unauthorizedMessage = 'Unauthorized. Please login again';
  static const String notFoundMessage = 'Resource not found';
  static const String validationErrorMessage = 'Please check your input';

  // Regex Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^\+?[\d\s-]{10,}$';
  static const String urlPattern = r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';
}