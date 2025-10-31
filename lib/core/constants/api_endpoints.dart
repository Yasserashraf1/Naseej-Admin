class ApiEndpoints {
  // Base URL - Update this to your server
  static const String baseUrl = 'http://yasserashraf.atwebpages.com/newphp';
  static const String imageBase = '$baseUrl/upload';

  // Admin Auth
  static const String adminLogin = '$baseUrl/admin/login.php';
  static const String adminRegister = '$baseUrl/admin/register.php';
  static const String adminProfile = '$baseUrl/admin/profile.php';
  static const String adminLogout = '$baseUrl/admin/logout.php';

  // Dashboard & Analytics
  static const String dashboardStats = '$baseUrl/admin/dashboard/stats.php';
  static const String salesAnalytics = '$baseUrl/admin/dashboard/sales.php';
  static const String recentOrders = '$baseUrl/admin/dashboard/recent_orders.php';

  // Products Management
  static const String products = '$baseUrl/admin/products';
  static const String productsList = '$products/list.php';
  static const String productAdd = '$products/add.php';
  static const String productUpdate = '$products/update.php';
  static const String productDelete = '$products/delete.php';
  static const String productDetails = '$products/details.php';
  static const String productUploadImage = '$products/upload_image.php';
  static const String productDeleteImage = '$products/delete_image.php';

  // Categories Management
  static const String categories = '$baseUrl/admin/categories';
  static const String categoriesList = '$categories/list.php';
  static const String categoryAdd = '$categories/add.php';
  static const String categoryUpdate = '$categories/update.php';
  static const String categoryDelete = '$categories/delete.php';

  // Orders Management
  static const String orders = '$baseUrl/admin/orders';
  static const String ordersList = '$orders/list.php';
  static const String orderDetails = '$orders/details.php';
  static const String orderUpdateStatus = '$orders/update_status.php';
  static const String orderDelete = '$orders/delete.php';
  static const String orderAssignDelivery = '$orders/assign_delivery.php';

  // Customers Management
  static const String customers = '$baseUrl/admin/customers';
  static const String customersList = '$customers/list.php';
  static const String customerDetails = '$customers/details.php';
  static const String customerBlock = '$customers/block.php';
  static const String customerUnblock = '$customers/unblock.php';
  static const String customerDelete = '$customers/delete.php';

  // Delivery Men Management
  static const String delivery = '$baseUrl/admin/delivery';
  static const String deliveryList = '$delivery/list.php';
  static const String deliveryAdd = '$delivery/add.php';
  static const String deliveryUpdate = '$delivery/update.php';
  static const String deliveryDelete = '$delivery/delete.php';
  static const String deliveryOrders = '$delivery/orders.php';
  static const String deliveryStats = '$delivery/stats.php';

  // Stores Management
  static const String stores = '$baseUrl/admin/stores';
  static const String storesList = '$stores/list.php';
  static const String storeAdd = '$stores/add.php';
  static const String storeUpdate = '$stores/update.php';
  static const String storeDelete = '$stores/delete.php';

  // Notifications
  static const String sendNotification = '$baseUrl/admin/notifications/send.php';
  static const String notificationHistory = '$baseUrl/admin/notifications/history.php';

  // Reports
  static const String salesReport = '$baseUrl/admin/reports/sales.php';
  static const String inventoryReport = '$baseUrl/admin/reports/inventory.php';
  static const String customersReport = '$baseUrl/admin/reports/customers.php';

  // Settings
  static const String appSettings = '$baseUrl/admin/settings/app.php';
  static const String updateSettings = '$baseUrl/admin/settings/update.php';
}