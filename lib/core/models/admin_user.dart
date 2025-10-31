class AdminUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isActive;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.profileImage,
    required this.createdAt,
    this.lastLogin,
    this.isActive = true,
  });

  // From JSON
  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      role: json['role'] ?? 'admin',
      profileImage: json['profile_image'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
      isActive: json['is_active'] == '1' || json['is_active'] == true,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
      'is_active': isActive ? '1' : '0',
    };
  }

  // Copy with
  AdminUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? profileImage,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
  }) {
    return AdminUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
    );
  }

  // Get role display name
  String get roleDisplayName {
    switch (role.toLowerCase()) {
      case 'super_admin':
        return 'Super Admin';
      case 'admin':
        return 'Administrator';
      case 'manager':
        return 'Manager';
      default:
        return role;
    }
  }

  // Check permissions
  bool get isSuperAdmin => role.toLowerCase() == 'super_admin';
  bool get isAdmin => role.toLowerCase() == 'admin' || isSuperAdmin;
  bool get isManager => role.toLowerCase() == 'manager';

  // Get profile image URL
  String? get profileImageUrl {
    if (profileImage != null && profileImage!.isNotEmpty) {
      return 'http://yasserashraf.atwebpages.com/newphp/upload/profiles/$profileImage';
    }
    return null;
  }

  @override
  String toString() {
    return 'AdminUser(id: $id, name: $name, email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}