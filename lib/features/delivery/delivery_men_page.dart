import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/delivery_man.dart';
import '../../../core/utils/helpers.dart';
import '../../../widgets/data_table_widget.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../delivery//delivery_controller.dart';

class DeliveryMenPage extends StatelessWidget {
  final DeliveryController controller = Get.put(DeliveryController());

  DeliveryMenPage({Key? key}) : super(key: key);

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
                  'Delivery Men Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/delivery/add'),
                  icon: Icon(Icons.add),
                  label: Text('Add Delivery Man'),
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
                          hintText: 'Search delivery men...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) => controller.searchDeliveryMen(value),
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

                    // Availability Filter
                    Container(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: controller.selectedAvailability.value,
                        decoration: InputDecoration(
                          labelText: 'Availability',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text('All'),
                          ),
                          DropdownMenuItem(
                            value: 'available',
                            child: Text('Available'),
                          ),
                          DropdownMenuItem(
                            value: 'busy',
                            child: Text('Busy'),
                          ),
                        ],
                        onChanged: (value) =>
                            controller.filterByAvailability(value ?? ''),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Delivery Men Table
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }

                if (controller.deliveryMen.isEmpty) {
                  return _buildEmptyState();
                }

                return DataTableWidget(
                  columns: [
                    DataColumn(label: Text('Delivery Man')),
                    DataColumn(label: Text('Contact')),
                    DataColumn(label: Text('Vehicle')),
                    DataColumn(label: Text('Completed Orders')),
                    DataColumn(label: Text('Rating')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: controller.filteredDeliveryMen.map((deliveryMan) {
                    return DataRow(cells: [
                      DataCell(
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: deliveryMan.profileImageUrl != null
                                    ? DecorationImage(
                                  image: NetworkImage(
                                      deliveryMan.profileImageUrl!),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                                color: AppColors.lightGray,
                              ),
                              child: deliveryMan.profileImageUrl == null
                                  ? Icon(Icons.person, color: AppColors.gray)
                                  : null,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    deliveryMan.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Since ${Helpers.formatDate(deliveryMan.joinedDate)}',
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
                              deliveryMan.email,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              deliveryMan.phone,
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
                              deliveryMan.vehicleType ?? 'Not specified',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              deliveryMan.vehicleNumber ?? 'No number',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${deliveryMan.completedOrders}/${deliveryMan.totalDeliveries}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              deliveryMan.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '(${deliveryMan.ratingStars})',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray,
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
                            color: _getStatusColor(deliveryMan).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            deliveryMan.statusText,
                            style: TextStyle(
                              color: _getStatusColor(deliveryMan),
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
                              onPressed: () => Get.toNamed(
                                  '/delivery/edit/${deliveryMan.id}'),
                              icon: Icon(Icons.edit,
                                  color: AppColors.info, size: 20),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              onPressed: () => _showDeleteDialog(deliveryMan),
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
                  totalItems: controller.totalDeliveryMen.value,
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
            Icons.delivery_dining_outlined,
            size: 64,
            color: AppColors.gray.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No Delivery Men Found',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first delivery man to get started',
            style: TextStyle(
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.toNamed('/delivery/add'),
            child: Text('Add Delivery Man'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(DeliveryMan deliveryMan) {
    if (!deliveryMan.isActive) return Colors.red;
    if (!deliveryMan.isAvailable) return Colors.orange;
    return Colors.green;
  }

  void _showDeleteDialog(DeliveryMan deliveryMan) {
    Get.dialog(
      ConfirmationDialog(
        title: 'Delete Delivery Man',
        message:
        'Are you sure you want to delete ${deliveryMan.name}? This action cannot be undone.',
        onConfirm: () => controller.deleteDeliveryMan(deliveryMan.id),
      ),
    );
  }
}