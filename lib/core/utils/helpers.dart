import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class Helpers {
  // Format currency
  static String formatCurrency(double amount, {bool showSymbol = true}) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final formattedAmount = formatter.format(amount);
    return showSymbol
        ? '${AppConstants.currencySymbol}$formattedAmount'
        : formattedAmount;
  }

  // Format date
  static String formatDate(DateTime date, {String? format}) {
    final dateFormat = DateFormat(format ?? AppConstants.dateFormat);
    return dateFormat.format(date);
  }

  // Format time
  static String formatTime(DateTime time) {
    final timeFormat = DateFormat(AppConstants.timeFormat);
    return timeFormat.format(time);
  }

  // Format date time
  static String formatDateTime(DateTime dateTime) {
    final dateTimeFormat = DateFormat(AppConstants.dateTimeFormat);
    return dateTimeFormat.format(dateTime);
  }

  // Get time ago
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // Truncate text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Capitalize first letter
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // Capitalize each word
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalizeFirst(word)).join(' ');
  }

  // Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  // Get file extension
  static String getFileExtension(String filename) {
    return filename.split('.').last.toLowerCase();
  }

  // Check if image file
  static bool isImageFile(String filename) {
    final ext = getFileExtension(filename);
    return AppConstants.allowedImageTypes.contains(ext);
  }

  // Generate random string
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(length, (index) =>
    chars[(DateTime.now().millisecondsSinceEpoch + index) % chars.length]
    ).join();
  }

  // Calculate percentage
  static double calculatePercentage(double value, double total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  // Format percentage
  static String formatPercentage(double percentage, {int decimals = 1}) {
    return '${percentage.toStringAsFixed(decimals)}%';
  }

  // Get order status color
  static String getOrderStatusColor(String status) {
    switch (status) {
      case '0': return '#FFA500'; // Orange - Pending
      case '1': return '#2196F3'; // Blue - Preparing
      case '2': return '#9C27B0'; // Purple - Ready
      case '3': return '#FF9800'; // Amber - On Way
      case '4': return '#4CAF50'; // Green - Delivered
      case '5': return '#F44336'; // Red - Cancelled
      default: return '#757575'; // Gray - Unknown
    }
  }

  // Parse JSON safely
  static dynamic parseJson(dynamic value, dynamic defaultValue) {
    try {
      return value ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  // Debounce function
  static Function debounce(Function func, Duration delay) {
    DateTime? lastCall;
    return () {
      final now = DateTime.now();
      if (lastCall == null || now.difference(lastCall!) > delay) {
        lastCall = now;
        func();
      }
    };
  }

  // Sort list by field
  static List<T> sortByField<T>(
      List<T> list,
      Comparable Function(T) getField, {
        bool ascending = true,
      }) {
    final sortedList = List<T>.from(list);
    sortedList.sort((a, b) {
      final comparison = getField(a).compareTo(getField(b));
      return ascending ? comparison : -comparison;
    });
    return sortedList;
  }

  // Group list by field
  static Map<K, List<T>> groupBy<T, K>(
      List<T> list,
      K Function(T) getKey,
      ) {
    final map = <K, List<T>>{};
    for (var item in list) {
      final key = getKey(item);
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(item);
    }
    return map;
  }

  // Check if valid URL
  static bool isValidUrl(String url) {
    final urlRegex = RegExp(AppConstants.urlPattern);
    return urlRegex.hasMatch(url);
  }

  // Get initials from name
  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  // Format phone number
  static String formatPhoneNumber(String phone) {
    // Remove all non-digit characters
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.length >= 10) {
      // Format as +XX XXX XXX XXXX
      return '+${digits.substring(0, 2)} ${digits.substring(2, 5)} ${digits.substring(5, 8)} ${digits.substring(8)}';
    }

    return phone;
  }

  // Calculate discount amount
  static double calculateDiscountAmount(double originalPrice, double discountPrice) {
    return originalPrice - discountPrice;
  }

  // Calculate discount percentage
  static double calculateDiscountPercentage(double originalPrice, double discountPrice) {
    if (originalPrice == 0) return 0;
    return ((originalPrice - discountPrice) / originalPrice) * 100;
  }

  // Safe divide
  static double safeDivide(double numerator, double denominator, {double defaultValue = 0}) {
    if (denominator == 0) return defaultValue;
    return numerator / denominator;
  }

  // Clean text (remove extra spaces)
  static String cleanText(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  // Convert snake_case to Title Case
  static String snakeToTitle(String text) {
    return text
        .split('_')
        .map((word) => capitalizeFirst(word))
        .join(' ');
  }
}