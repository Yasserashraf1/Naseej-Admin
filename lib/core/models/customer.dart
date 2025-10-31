class Customer {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final DateTime registeredDate;
  final DateTime? lastLogin;
  final bool isActive;
  final bool isBlocked;
  final int totalOrders;
  final double totalSpent;
  final String? preferredLanguage;
  final String? city;
  final String? country;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    required this.registeredDate,
    this.lastLogin,
    this.isActive = true,
    this.isBlocked = false,
    this.totalOrders = 0,
    this.totalSpent = 0.0,
    this.preferredLanguage,
    this.city,
    this.country,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      profileImage: json['profile_image'],
      registeredDate: json['registered_date'] != null
          ? DateTime.parse(json['registered_date'])
          : DateTime.now(),
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
      isActive: json['is_active'] == '1' || json['is_active'] == true,
      isBlocked: json['is_blocked'] == '1' || json['is_blocked'] == true,
      totalOrders: int.tryParse(json['total_orders']?.toString() ?? '0') ?? 0,
      totalSpent: double.tryParse(json['total_spent']?.toString() ?? '0') ?? 0.0,
      preferredLanguage: json['preferred_language'],
      city: json['city'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'registered_date': registeredDate.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
      'is_active': isActive ? '1' : '0',
      'is_blocked': isBlocked ? '1' : '0',
      'total_orders': totalOrders,
      'total_spent': totalSpent,
      'preferred_language': preferredLanguage,
      'city': city,
      'country': country,
    };
  }

  Customer copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    DateTime? registeredDate,
    DateTime? lastLogin,
    bool? isActive,
    bool? isBlocked,
    int? totalOrders,
    double? totalSpent,
    String? preferredLanguage,
    String? city,
    String? country,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      registeredDate: registeredDate ?? this.registeredDate,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      isBlocked: isBlocked ?? this.isBlocked,
      totalOrders: totalOrders ?? this.totalOrders,
      totalSpent: totalSpent ?? this.totalSpent,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      city: city ?? this.city,
      country: country ?? this.country,
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
    if (isBlocked) return 'Blocked';
    if (!isActive) return 'Inactive';
    return 'Active';
  }

  // Get customer tier based on spending
  String get customerTier {
    if (totalSpent >= 10000) return 'VIP';
    if (totalSpent >= 5000) return 'Gold';
    if (totalSpent >= 2000) return 'Silver';
    return 'Bronze';
  }

  // Calculate average order value
  double get averageOrderValue {
    if (totalOrders == 0) return 0.0;
    return totalSpent / totalOrders;
  }

  @override
  String toString() {
    return 'Customer(id: $id, name: $name, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Customer && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}