import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class DataTableWidget extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final int currentPage;
  final int totalItems;
  final int itemsPerPage;
  final Function(int) onPageChanged;
  final bool isLoading;
  final bool showPagination;
  final double rowHeight;
  final double headingRowHeight;

  const DataTableWidget({
    Key? key,
    required this.columns,
    required this.rows,
    required this.currentPage,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
    this.isLoading = false,
    this.showPagination = true,
    this.rowHeight = 60,
    this.headingRowHeight = 56,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalPages = (totalItems / itemsPerPage).ceil();
    final startItem = (currentPage - 1) * itemsPerPage + 1;
    final endItem = currentPage * itemsPerPage > totalItems
        ? totalItems
        : currentPage * itemsPerPage;

    return Column(
      children: [
        // Table
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: isLoading
                ? _buildLoadingState()
                : rows.isEmpty
                ? _buildEmptyState()
                : _buildDataTable(),
          ),
        ),

        // Pagination
        if (showPagination && totalPages > 1) ...[
          SizedBox(height: 16),
          _buildPagination(
            currentPage: currentPage,
            totalPages: totalPages,
            startItem: startItem,
            endItem: endItem,
            totalItems: totalItems,
          ),
        ],
      ],
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      child: DataTable(
        columns: columns,
        rows: rows,
        headingRowColor: MaterialStateProperty.all(AppColors.background),
        dataRowColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.primary.withOpacity(0.2);
            }
            // Even rows have a slight background color
            final index = rows.indexOf(rows.firstWhere((row) => row.key == states));
            return index.isEven ? AppColors.background : Colors.transparent;
          },
        ),
        headingTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          fontSize: 14,
        ),
        dataTextStyle: TextStyle(
          fontSize: 14,
          color: AppColors.darkGray,
        ),
        dividerThickness: 1,
        showBottomBorder: true,
        horizontalMargin: 16,
        columnSpacing: 20,
        headingRowHeight: headingRowHeight,
        dataRowHeight: rowHeight,
      ),
    );
  }

  Widget _buildPagination({
    required int currentPage,
    required int totalPages,
    required int startItem,
    required int endItem,
    required int totalItems,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Items count
          Text(
            'Showing $startItem to $endItem of $totalItems entries',
            style: TextStyle(
              color: AppColors.gray,
              fontSize: 14,
            ),
          ),

          // Pagination controls
          Row(
            children: [
              // Previous button
              IconButton(
                onPressed: currentPage > 1
                    ? () => onPageChanged(currentPage - 1)
                    : null,
                icon: Icon(Icons.chevron_left),
                color: currentPage > 1 ? AppColors.primary : AppColors.gray,
                tooltip: 'Previous',
              ),

              // Page numbers
              ..._buildPageNumbers(currentPage, totalPages),

              // Next button
              IconButton(
                onPressed: currentPage < totalPages
                    ? () => onPageChanged(currentPage + 1)
                    : null,
                icon: Icon(Icons.chevron_right),
                color: currentPage < totalPages ? AppColors.primary : AppColors.gray,
                tooltip: 'Next',
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers(int currentPage, int totalPages) {
    final pages = <Widget>[];
    const maxVisiblePages = 5;

    int startPage = (currentPage - (maxVisiblePages ~/ 2)).clamp(1, totalPages);
    int endPage = (startPage + maxVisiblePages - 1).clamp(1, totalPages);

    // Adjust start page if we're near the end
    if (endPage - startPage + 1 < maxVisiblePages) {
      startPage = (endPage - maxVisiblePages + 1).clamp(1, totalPages);
    }

    // First page and ellipsis
    if (startPage > 1) {
      pages.add(_buildPageNumber(1, currentPage));
      if (startPage > 2) {
        pages.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('...', style: TextStyle(color: AppColors.gray)),
        ));
      }
    }

    // Page numbers
    for (int i = startPage; i <= endPage; i++) {
      pages.add(_buildPageNumber(i, currentPage));
    }

    // Last page and ellipsis
    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pages.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('...', style: TextStyle(color: AppColors.gray)),
        ));
      }
      pages.add(_buildPageNumber(totalPages, currentPage));
    }

    return pages;
  }

  Widget _buildPageNumber(int page, int currentPage) {
    final isCurrent = page == currentPage;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isCurrent ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: isCurrent ? null : () => onPageChanged(page),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            child: Text(
              page.toString(),
              style: TextStyle(
                color: isCurrent ? Colors.white : AppColors.darkGray,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'Loading data...',
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
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.gray.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'No data available',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.gray,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'There are no items to display',
              style: TextStyle(
                color: AppColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}