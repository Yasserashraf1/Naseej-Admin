import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/helpers.dart';

class SalesChart extends StatelessWidget {
  final Map<String, dynamic> chartData;
  final String chartType;
  final Function(String) onChartTypeChanged;
  final bool isLoading;

  const SalesChart({
    Key? key,
    required this.chartData,
    required this.chartType,
    required this.onChartTypeChanged,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.bar_chart,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Sales Analytics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                // Chart Type Selector
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.lightGray),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: chartType,
                      items: [
                        DropdownMenuItem(
                          value: 'daily',
                          child: Text('Daily'),
                        ),
                        DropdownMenuItem(
                          value: 'weekly',
                          child: Text('Weekly'),
                        ),
                        DropdownMenuItem(
                          value: 'monthly',
                          child: Text('Monthly'),
                        ),
                        DropdownMenuItem(
                          value: 'yearly',
                          child: Text('Yearly'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          onChartTypeChanged(value);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Chart
            if (isLoading)
              _buildLoadingState()
            else if (chartData.isEmpty)
              _buildEmptyState()
            else
              _buildChart(),

            // Legend
            if (!isLoading && chartData.isNotEmpty) ...[
              SizedBox(height: 20),
              _buildLegend(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final salesData = chartData['sales_data'] ?? [];
    final maxValue = chartData['max_value'] ?? 0.0;
    final totalRevenue = chartData['total_revenue'] ?? 0.0;
    final percentageChange = chartData['percentage_change'] ?? 0.0;

    return Column(
      children: [
        // Summary Cards
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Revenue',
                Helpers.formatCurrency(totalRevenue),
                Icons.attach_money,
                AppColors.success,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Growth',
                '${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}%',
                percentageChange >= 0 ? Icons.trending_up : Icons.trending_down,
                percentageChange >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),

        SizedBox(height: 20),

        // Bar Chart
        Container(
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxValue * 1.2, // Add some padding
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: AppColors.primary.withOpacity(0.8),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${salesData[groupIndex]['label']}\n',
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: Helpers.formatCurrency(rod.toY),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < salesData.length) {
                        return Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            salesData[index]['label'],
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.gray,
                            ),
                          ),
                        );
                      }
                      return Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        Helpers.formatCurrency(value, showSymbol: false),
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.gray,
                        ),
                      );
                    },
                    reservedSize: 40,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.lightGray,
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: salesData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: (data['value'] as num).toDouble(),
                      color: AppColors.chartColors[index % AppColors.chartColors.length],
                      width: 16,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.gray,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: AppColors.chartColors.asMap().entries.map((entry) {
        final index = entry.key;
        final color = entry.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 6),
            Text(
              'Series ${index + 1}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.gray,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'Loading chart data...',
              style: TextStyle(
                color: AppColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_outlined,
              size: 64,
              color: AppColors.gray.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'No sales data available',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.gray,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Sales data will appear here once orders start coming in',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.gray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Line Chart Variant
class SalesLineChart extends StatelessWidget {
  final Map<String, dynamic> chartData;
  final bool isLoading;

  const SalesLineChart({
    Key? key,
    required this.chartData,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    final salesData = chartData['sales_data'] ?? [];
    final maxValue = chartData['max_value'] ?? 0.0;

    return Container(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.lightGray,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < salesData.length) {
                    return Text(
                      salesData[index]['label'],
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.gray,
                      ),
                    );
                  }
                  return Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    Helpers.formatCurrency(value, showSymbol: false),
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.gray,
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (salesData.length - 1).toDouble(),
          minY: 0,
          maxY: maxValue * 1.2,
          lineBarsData: [
            LineChartBarData(
              spots: salesData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                return FlSpot(
                  index.toDouble(),
                  (data['value'] as num).toDouble(),
                );
              }).toList(),
              isCurved: true,
              color: AppColors.primary,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 300,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}