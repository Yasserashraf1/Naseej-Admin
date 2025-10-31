import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/constants/colors.dart';
import '../../core/models/admin_user.dart';
import '../../core/models/order.dart';
import '../../core/services/api_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/helpers.dart';
import 'package:naseej_admin/features/dashboard/widgets/stats_card.dart';
import 'package:naseej_admin/features/dashboard/widgets/recent_orders.dart';
import 'package:naseej_admin/features/dashboard/widgets/sales_chart.dart';


class DashboardPage extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              _buildWelcomeHeader(),

              SizedBox(height: 20),

              // Stats Cards
              _buildStatsGrid(),

              SizedBox(height: 20),

              // Charts and Recent Orders
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sales Chart
                  Expanded(
                    flex: 2,
                    child: Obx(() => SalesChart(
                      chartData: controller.chartData.value,
                      chartType: controller.chartType.value,
                      onChartTypeChanged: (type) =>
                          controller.changeChartType(type),
                      isLoading: controller.isLoading.value,
                    )),
                  ),

                  SizedBox(width: 20),

                  // Recent Orders
                  Expanded(
                    flex: 1,
                    child: Obx(() => RecentOrdersWidget(
                      orders: controller.recentOrders,
                      isLoading: controller.isLoading.value,
                      onViewAll: () => Get.toNamed('/orders'),
                    )),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Additional Charts and Metrics
              _buildAdditionalMetrics(),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Obx(() {
      final user = controller.currentUser.value;
      final currentTime = DateTime.now();
      final hour = currentTime.hour;
      String greeting;

      if (hour < 12) {
        greeting = 'Good Morning';
      } else if (hour < 17) {
        greeting = 'Good Afternoon';
      } else {
        greeting = 'Good Evening';
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, ${user?.name ?? 'Admin'}! 👋',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Here\'s what\'s happening with your store today.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.gray,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Date Display
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lightGray),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      Helpers.formatDate(DateTime.now()),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              // Refresh Button
              IconButton(
                onPressed: () => controller.refreshDashboard(),
                icon: Icon(Icons.refresh),
                tooltip: 'Refresh Data',
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildStatsGrid() {
    return Obx(() {
      final stats = controller.dashboardStats.value;

      return GridView.count(
        crossAxisCount: _getCrossAxisCount(Get.width),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          TotalRevenueCard(
            revenue: stats['total_revenue'] ?? 0.0,
            percentageChange: stats['revenue_growth'] ?? 0.0,
            isLoading: controller.isLoading.value,
            onTap: () => Get.toNamed('/reports/sales'),
          ),
          TotalOrdersCard(
            orders: stats['total_orders'] ?? 0,
            percentageChange: stats['order_growth'] ?? 0.0,
            isLoading: controller.isLoading.value,
            onTap: () => Get.toNamed('/orders'),
          ),
          TotalCustomersCard(
            customers: stats['total_customers'] ?? 0,
            percentageChange: stats['customer_growth'] ?? 0.0,
            isLoading: controller.isLoading.value,
            onTap: () => Get.toNamed('/customers'),
          ),
          TotalProductsCard(
            products: stats['total_products'] ?? 0,
            isLoading: controller.isLoading.value,
            onTap: () => Get.toNamed('/products'),
          ),
          if (_getCrossAxisCount(Get.width) >= 4) ...[
            _buildCustomStatsCard(
              title: 'Avg. Order Value',
              value: Helpers.formatCurrency(stats['avg_order_value'] ?? 0.0),
              icon: Icons.shopping_cart,
              color: AppColors.info,
              subtitle: 'Per order',
            ),
            _buildCustomStatsCard(
              title: 'Conversion Rate',
              value: '${(stats['conversion_rate'] ?? 0.0).toStringAsFixed(1)}%',
              icon: Icons.trending_up,
              color: AppColors.success,
              subtitle: 'Visitor to customer',
            ),
          ],
        ],
      );
    });
  }

  Widget _buildCustomStatsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return StatsCard(
      title: title,
      value: value,
      icon: icon,
      color: color,
      subtitle: subtitle,
      isLoading: controller.isLoading.value,
    );
  }

  Widget _buildAdditionalMetrics() {
    return Obx(() {
      final stats = controller.dashboardStats.value;

      return Row(
        children: [
          // Top Products
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.gold),
                        SizedBox(width: 8),
                        Text(
                          'Top Products',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (controller.isLoading.value)
                      _buildTopProductsLoading()
                    else if (stats['top_products'] != null &&
                        (stats['top_products'] as List).isNotEmpty)
                      ...(stats['top_products'] as List).map((product) =>
                          _buildTopProductItem(product))
                    else
                      _buildEmptyState('No top products data'),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: 20),

          // Store Performance
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.assessment, color: AppColors.info),
                        SizedBox(width: 8),
                        Text(
                          'Store Performance',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (controller.isLoading.value)
                      _buildPerformanceLoading()
                    else
                      _buildPerformanceMetrics(stats),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTopProductsLoading() {
    return Column(
      children: List.generate(3, (index) => _buildTopProductLoadingItem()),
    );
  }

  Widget _buildTopProductLoadingItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProductItem(Map<String, dynamic> product) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: product['image'] != null
                  ? DecorationImage(
                image: NetworkImage(product['image']),
                fit: BoxFit.cover,
              )
                  : null,
              color: AppColors.lightGray,
            ),
            child: product['image'] == null
                ? Icon(Icons.image, size: 20, color: AppColors.gray)
                : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? 'Unknown Product',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '${product['sales'] ?? 0} sales',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            Helpers.formatCurrency(product['revenue'] ?? 0.0),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceLoading() {
    return Column(
      children: List.generate(4, (index) => _buildPerformanceMetricLoading()),
    );
  }

  Widget _buildPerformanceMetricLoading() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Container(
            width: 60,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics(Map<String, dynamic> stats) {
    final metrics = [
      {
        'label': 'Visitor Count',
        'value': '${stats['visitors'] ?? 0}',
        'icon': Icons.people_outline,
        'color': AppColors.info,
      },
      {
        'label': 'Bounce Rate',
        'value': '${(stats['bounce_rate'] ?? 0.0).toStringAsFixed(1)}%',
        'icon': Icons.exit_to_app,
        'color': AppColors.warning,
      },
      {
        'label': 'Avg. Session',
        'value': '${(stats['avg_session'] ?? 0).toStringAsFixed(0)}m',
        'icon': Icons.timer,
        'color': AppColors.success,
      },
      {
        'label': 'New vs Returning',
        'value': '${(stats['new_customers_ratio'] ?? 0.0).toStringAsFixed(1)}%',
        'icon': Icons.compare_arrows,
        'color': AppColors.primary,
      },
    ];

    return Column(
      children: metrics.map((metric) => _buildPerformanceMetric(metric)).toList(),
    );
  }

  Widget _buildPerformanceMetric(Map<String, dynamic> metric) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: metric['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              metric['icon'],
              size: 20,
              color: metric['color'],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              metric['label'],
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            metric['value'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: metric['color'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: AppColors.gray.withOpacity(0.5),
          ),
          SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              color: AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth > 1400) return 4;
    if (screenWidth > 1000) return 3;
    if (screenWidth > 600) return 2;
    return 1;
  }
}

// Dashboard Controller
class DashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ApiService _apiService = ApiService();

  // Observable states
  final isLoading = false.obs;
  final dashboardStats = Rx<Map<String, dynamic>>({});
  final recentOrders = <Order>[].obs;
  final chartData = Rx<Map<String, dynamic>>({});
  final chartType = Rx<String>('monthly');

  // Current user
  final currentUser = Rx<AdminUser?>(null);

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _authService.getCurrentUser();
    loadDashboardData();
  }

  // Load dashboard data
  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      // Load data in parallel
      await Future.wait([
        _loadStats(),
        _loadRecentOrders(),
        _loadChartData(),
      ]);

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load dashboard statistics
  Future<void> _loadStats() async {
    final response = await _apiService.get(ApiEndpoints.dashboardStats);
    if (response['status'] == 'success') {
      dashboardStats.value = response['data'] ?? {};
    }
  }

  // Load recent orders
  Future<void> _loadRecentOrders() async {
    final response = await _apiService.get(ApiEndpoints.recentOrders);
    if (response['status'] == 'success') {
      recentOrders.value = (response['data'] as List)
          .map((json) => Order.fromJson(json))
          .toList();
    }
  }

  // Load chart data
  Future<void> _loadChartData() async {
    final response = await _apiService.get(
      '${ApiEndpoints.salesAnalytics}?type=${chartType.value}',
    );
    if (response['status'] == 'success') {
      chartData.value = response['data'] ?? {};
    }
  }

  // Change chart type
  void changeChartType(String type) {
    chartType.value = type;
    _loadChartData();
  }

  // Refresh dashboard
  void refreshDashboard() {
    loadDashboardData();
    Get.snackbar(
      'Refreshed',
      'Dashboard data updated',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  // Get quick actions
  List<Map<String, dynamic>> getQuickActions() {
    return [
      {
        'title': 'Add Product',
        'icon': Icons.add,
        'route': '/products/add',
        'color': AppColors.success,
      },
      {
        'title': 'View Orders',
        'icon': Icons.shopping_bag,
        'route': '/orders',
        'color': AppColors.primary,
      },
      {
        'title': 'Manage Customers',
        'icon': Icons.people,
        'route': '/customers',
        'color': AppColors.info,
      },
      {
        'title': 'Analytics',
        'icon': Icons.analytics,
        'route': '/reports',
        'color': AppColors.warning,
      },
    ];
  }
}