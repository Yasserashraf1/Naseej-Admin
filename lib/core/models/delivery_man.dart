class DeliveryMan {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final String? vehicleType;
  final String? vehicleNumber;
  final bool isActive;
  final bool isAvailable;
  final DateTime joinedDate;
  final int totalDeliveries;
  final double rating;
  final int completedOrders;
  final int activeOrders;
  final String? currentLocation;

  DeliveryMan({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    this.vehicleType,
    this.vehicleNumber,
    this.isActive = true,
    this.isAvailable = true,
    required this.joinedDate,
    this.totalDeliveries = 0,
    this.rating = 0.0,
    this.completedOrders = 0,
    this.activeOrders = 0,
    this.currentLocation,
  });

  factory DeliveryMan.fromJson(Map<String, dynamic> json) {
    return DeliveryMan(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profile_image'],
      vehicleType: json['vehicle_type'],
      vehicleNumber: json['vehicle_number'],
      isActive: json['is_active'] == '1' || json['is_active'] == true,
      isAvailable: json['is_available'] == '1' || json['is_available'] == true,
      joinedDate: json['joined_date'] != null
          ? DateTime.parse(json['joined_date'])
          : DateTime.now(),
      totalDeliveries: int.tryParse(json['total_deliveries']?.toString() ?? '0') ?? 0,
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      completedOrders: int.tryParse(json['completed_orders']?.toString() ?? '0') ?? 0,
      activeOrders: int.tryParse(json['active_orders']?.toString() ?? '0') ?? 0,
      currentLocation: json['current_location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'is_active': isActive ? '1' : '0',
      'is_available': isAvailable ? '1' : '0',
      'joined_date': joinedDate.toIso8601String(),
      'total_deliveries': totalDeliveries,
      'rating': rating,
      'completed_orders': completedOrders,
      'active_orders': activeOrders,
      'current_location': currentLocation,
    };
  }

  DeliveryMan copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? vehicleType,
    String? vehicleNumber,
    bool? isActive,
    bool? isAvailable,
    DateTime? joinedDate,
    int? totalDeliveries,
    double? rating,
    int? completedOrders,
    int? activeOrders,
    String? currentLocation,
  }) {
    return DeliveryMan(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      isActive: isActive ?? this.isActive,
      isAvailable: isAvailable ?? this.isAvailable,
      joinedDate: joinedDate ?? this.joinedDate,
      totalDeliveries: totalDeliveries ?? this.totalDeliveries,
      rating: rating ?? this.rating,
      completedOrders: completedOrders ?? this.completedOrders,
      activeOrders: activeOrders ?? this.activeOrders,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }

  // Get profile image URL
  String? get profileImageUrl {
    if (profileImage != null && profileImage!.isNotEmpty) {
      return 'http://yasserashraf.atwebpages.com/newphp/upload/profiles/$profileImage';
    }
    return null;
  }

  // Get status text
  String get statusText {
    if (!isActive) return 'Inactive';
    if (!isAvailable) return 'Busy';
    return 'Available';
  }

  // Get rating stars
  String get ratingStars {
    return '⭐' * rating.round();
  }

  // Calculate success rate
  double get successRate {
    if (totalDeliveries == 0) return 0.0;
    return (completedOrders / totalDeliveries) * 100;
  }

  @override
  String toString() {
    return 'DeliveryMan(id: $id, name: $name, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeliveryMan && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}