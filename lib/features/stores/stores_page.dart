import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/store.dart';
import '../../../core/utils/helpers.dart';
import '../../../widgets/data_table_widget.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../../core/constants/app_constants.dart';
import '../stores/store_controller.dart';

class StoresPage extends StatelessWidget {
  final StoreController controller = Get.put(StoreController());

  StoresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stores Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/stores/add'),
                  icon: Icon(Icons.add),
                  label: Text('Add Store'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Filters and Search
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Search
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: 'Search stores...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) => controller.searchStores(value),
                      ),
                    ),

                    SizedBox(width: 16),

                    // Status Filter
                    Container(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: controller.selectedStatus.value,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text('All Status'),
                          ),
                          DropdownMenuItem(
                            value: 'active',
                            child: Text('Active'),
                          ),
                          DropdownMenuItem(
                            value: 'inactive',
                            child: Text('Inactive'),
                          ),
                        ],
                        onChanged: (value) =>
                            controller.filterByStatus(value ?? ''),
                      ),
                    ),

                    SizedBox(width: 16),

                    // City Filter
                    Container(
                      width: 150,
                      child: DropdownButtonFormField<String>(
                        value: controller.selectedCity.value,
                        decoration: InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text('All Cities'),
                          ),
                          ...AppConstants.countries.map((city) {
                            return DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) =>
                            controller.filterByCity(value ?? ''),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Stores Table
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }

                if (controller.stores.isEmpty) {
                  return _buildEmptyState();
                }

                return DataTableWidget(
                  columns: [
                    DataColumn(label: Text('Store')),
                    DataColumn(label: Text('Address')),
                    DataColumn(label: Text('Contact')),
                    DataColumn(label: Text('Working Hours')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: controller.filteredStores.map((store) {
                    return DataRow(cells: [
                      DataCell(
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: store.imageUrl != null
                                    ? DecorationImage(
                                  image: NetworkImage(store.imageUrl!),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                                color: AppColors.lightGray,
                              ),
                              child: store.imageUrl == null
                                  ? Icon(Icons.store, color: AppColors.gray)
                                  : null,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    store.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    store.nameAr,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.gray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              store.address,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              store.city,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              store.phone ?? 'No phone',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              store.email ?? 'No email',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${store.openingHours} - ${store.closingHours}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: store.isOpenNow
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                store.isOpenNow ? 'Open Now' : 'Closed',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: store.isOpenNow
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: store.isActive
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            store.statusText,
                            style: TextStyle(
                              color: store.isActive ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  Get.toNamed('/stores/edit/${store.id}'),
                              icon: Icon(Icons.edit,
                                  color: AppColors.info, size: 20),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              onPressed: () => _showDeleteDialog(store),
                              icon: Icon(Icons.delete,
                                  color: AppColors.error, size: 20),
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                  onPageChanged: (page) => controller.currentPage.value = page,
                  totalItems: controller.totalStores.value,
                  itemsPerPage: controller.itemsPerPage.value,
                  currentPage: controller.currentPage.value,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              color: AppColors.lightGray,
            ),
            title: Container(
              width: 200,
              height: 16,
              color: AppColors.lightGray,
            ),
            subtitle: Container(
              width: 150,
              height: 12,
              color: AppColors.lightGray,
            ),
            trailing: Container(
              width: 80,
              height: 24,
              color: AppColors.lightGray,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 64,
            color: AppColors.gray.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No Stores Found',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first store to get started',
            style: TextStyle(
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.toNamed('/stores/add'),
            child: Text('Add Store'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Store store) {
    Get.dialog(
      ConfirmationDialog(
        title: 'Delete Store',
        message:
        'Are you sure you want to delete "${store.name}"? This action cannot be undone.',
        onConfirm: () => controller.deleteStore(store.id),
      ),
    );
  }
}