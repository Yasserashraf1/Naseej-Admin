class Store {
  final String id;
  final String name;
  final String nameAr;
  final String address;
  final String city;
  final String? phone;
  final String? email;
  final double latitude;
  final double longitude;
  final String? image;
  final bool isActive;
  final String openingHours;
  final String closingHours;
  final List<String>? workingDays;
  final String? managerName;
  final String? managerPhone;
  final DateTime createdAt;

  Store({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.address,
    required this.city,
    this.phone,
    this.email,
    required this.latitude,
    required this.longitude,
    this.image,
    this.isActive = true,
    required this.openingHours,
    required this.closingHours,
    this.workingDays,
    this.managerName,
    this.managerPhone,
    required this.createdAt,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      phone: json['phone'],
      email: json['email'],
      latitude: double.tryParse(json['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0') ?? 0.0,
      image: json['image'],
      isActive: json['is_active'] == '1' || json['is_active'] == true,
      openingHours: json['opening_hours'] ?? '09:00',
      closingHours: json['closing_hours'] ?? '18:00',
      workingDays: json['working_days'] != null
          ? (json['working_days'] as String).split(',')
          : null,
      managerName: json['manager_name'],
      managerPhone: json['manager_phone'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'address': address,
      'city': city,
      'phone': phone,
      'email': email,
      'latitude': latitude,
      'longitude': longitude,
      'image': image,
      'is_active': isActive ? '1' : '0',
      'opening_hours': openingHours,
      'closing_hours': closingHours,
      'working_days': workingDays?.join(','),
      'manager_name': managerName,
      'manager_phone': managerPhone,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Store copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? address,
    String? city,
    String? phone,
    String? email,
    double? latitude,
    double? longitude,
    String? image,
    bool? isActive,
    String? openingHours,
    String? closingHours,
    List<String>? workingDays,
    String? managerName,
    String? managerPhone,
    DateTime? createdAt,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      address: address ?? this.address,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      openingHours: openingHours ?? this.openingHours,
      closingHours: closingHours ?? this.closingHours,
      workingDays: workingDays ?? this.workingDays,
      managerName: managerName ?? this.managerName,
      managerPhone: managerPhone ?? this.managerPhone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Get store image URL
  String? get imageUrl {
    if (image != null && image!.isNotEmpty) {
      return 'http://yasserashraf.atwebpages.com/newphp/upload/stores/$image';
    }
    return null;
  }

  // Get status text
  String get statusText => isActive ? 'Active' : 'Inactive';

  // Get Google Maps URL
  String get googleMapsUrl {
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }

  // Get full address
  String get fullAddress {
    return '$address, $city';
  }

  // Check if store is open now
  bool get isOpenNow {
    if (!isActive) return false;

    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);

    if (workingDays != null && !workingDays!.contains(dayName)) {
      return false;
    }

    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return currentTime.compareTo(openingHours) >= 0 &&
        currentTime.compareTo(closingHours) <= 0;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }

  @override
  String toString() {
    return 'Store(id: $id, name: $name, city: $city)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Store && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}