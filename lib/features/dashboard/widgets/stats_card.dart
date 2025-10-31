import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/helpers.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final double? percentageChange;
  final VoidCallback? onTap;
  final bool isLoading;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.percentageChange,
    this.onTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: isLoading
              ? _buildLoadingState()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 28,
                    ),
                  ),

                  // Percentage Change Badge
                  if (percentageChange != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: percentageChange! >= 0
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            percentageChange! >= 0
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 14,
                            color: percentageChange! >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${percentageChange!.abs().toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: percentageChange! >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              SizedBox(height: 16),

              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.gray,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 8),

              // Value
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),

              // Subtitle
              if (subtitle != null) ...[
                SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Container(
              width: 60,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          width: 100,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 150,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

// Predefined Stats Cards for common use cases
class TotalRevenueCard extends StatelessWidget {
  final double revenue;
  final double? percentageChange;
  final bool isLoading;
  final VoidCallback? onTap;

  const TotalRevenueCard({
    Key? key,
    required this.revenue,
    this.percentageChange,
    this.isLoading = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatsCard(
      title: 'Total Revenue',
      value: Helpers.formatCurrency(revenue),
      icon: Icons.attach_money,
      color: AppColors.success,
      subtitle: 'This month',
      percentageChange: percentageChange,
      isLoading: isLoading,
      onTap: onTap,
    );
  }
}

class TotalOrdersCard extends StatelessWidget {
  final int orders;
  final double? percentageChange;
  final bool isLoading;
  final VoidCallback? onTap;

  const TotalOrdersCard({
    Key? key,
    required this.orders,
    this.percentageChange,
    this.isLoading = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatsCard(
      title: 'Total Orders',
      value: orders.toString(),
      icon: Icons.shopping_bag,
      color: AppColors.primary,
      subtitle: 'This month',
      percentageChange: percentageChange,
      isLoading: isLoading,
      onTap: onTap,
    );
  }
}

class TotalCustomersCard extends StatelessWidget {
  final int customers;
  final double? percentageChange;
  final bool isLoading;
  final VoidCallback? onTap;

  const TotalCustomersCard({
    Key? key,
    required this.customers,
    this.percentageChange,
    this.isLoading = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatsCard(
      title: 'Total Customers',
      value: customers.toString(),
      icon: Icons.people,
      color: AppColors.info,
      subtitle: 'Registered users',
      percentageChange: percentageChange,
      isLoading: isLoading,
      onTap: onTap,
    );
  }
}

class TotalProductsCard extends StatelessWidget {
  final int products;
  final bool isLoading;
  final VoidCallback? onTap;

  const TotalProductsCard({
    Key? key,
    required this.products,
    this.isLoading = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatsCard(
      title: 'Total Products',
      value: products.toString(),
      icon: Icons.inventory,
      color: AppColors.gold,
      subtitle: 'In catalog',
      isLoading: isLoading,
      onTap: onTap,
    );
  }
}