class Category {
  final String id;
  final String name;
  final String nameAr;
  final String? description;
  final String? image;
  final int productCount;
  final bool isActive;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.nameAr,
    this.description,
    this.image,
    this.productCount = 0,
    this.isActive = true,
    this.displayOrder = 0,
    required this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
      description: json['description'],
      image: json['image'],
      productCount: int.tryParse(json['product_count']?.toString() ?? '0') ?? 0,
      isActive: json['is_active'] == '1' || json['is_active'] == true,
      displayOrder: int.tryParse(json['display_order']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'image': image,
      'product_count': productCount,
      'is_active': isActive ? '1' : '0',
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? image,
    int? productCount,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      image: image ?? this.image,
      productCount: productCount ?? this.productCount,
      isActive: isActive ?? this.isActive,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get image URL
  String? get imageUrl {
    if (image != null && image!.isNotEmpty) {
      return 'http://yasserashraf.atwebpages.com/newphp/upload/categories/$image';
    }
    return null;
  }

  // Get status text
  String get statusText => isActive ? 'Active' : 'Inactive';

  @override
  String toString() {
    return 'Category(id: $id, name: $name, productCount: $productCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}