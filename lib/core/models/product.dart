class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final String categoryId;
  final String? categoryName;
  final int stockQuantity;
  final String? mainImage;
  final List<String>? images;
  final String size;
  final String color;
  final String material;
  final bool isActive;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int viewCount;
  final int salesCount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.categoryId,
    this.categoryName,
    required this.stockQuantity,
    this.mainImage,
    this.images,
    required this.size,
    required this.color,
    required this.material,
    this.isActive = true,
    this.isFeatured = false,
    required this.createdAt,
    this.updatedAt,
    this.viewCount = 0,
    this.salesCount = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      discountPrice: json['discount_price'] != null
          ? double.tryParse(json['discount_price']?.toString() ?? '0')
          : null,
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name'],
      stockQuantity: int.tryParse(json['stock_quantity']?.toString() ?? '0') ?? 0,
      mainImage: json['main_image'],
      images: json['images'] != null
          ? (json['images'] as String).split(',')
          : null,
      size: json['size'] ?? '',
      color: json['color'] ?? '',
      material: json['material'] ?? '',
      isActive: json['is_active'] == '1' || json['is_active'] == true,
      isFeatured: json['is_featured'] == '1' || json['is_featured'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      viewCount: int.tryParse(json['view_count']?.toString() ?? '0') ?? 0,
      salesCount: int.tryParse(json['sales_count']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'category_id': categoryId,
      'category_name': categoryName,
      'stock_quantity': stockQuantity,
      'main_image': mainImage,
      'images': images?.join(','),
      'size': size,
      'color': color,
      'material': material,
      'is_active': isActive ? '1' : '0',
      'is_featured': isFeatured ? '1' : '0',
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'view_count': viewCount,
      'sales_count': salesCount,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    String? categoryId,
    String? categoryName,
    int? stockQuantity,
    String? mainImage,
    List<String>? images,
    String? size,
    String? color,
    String? material,
    bool? isActive,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? viewCount,
    int? salesCount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      mainImage: mainImage ?? this.mainImage,
      images: images ?? this.images,
      size: size ?? this.size,
      color: color ?? this.color,
      material: material ?? this.material,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      viewCount: viewCount ?? this.viewCount,
      salesCount: salesCount ?? this.salesCount,
    );
  }

  // Get main image URL
  String? get mainImageUrl {
    if (mainImage != null && mainImage!.isNotEmpty) {
      return 'http://yasserashraf.atwebpages.com/newphp/upload/products/$mainImage';
    }
    return null;
  }

  // Get all image URLs
  List<String> get imageUrls {
    if (images != null && images!.isNotEmpty) {
      return images!.map((img) =>
      'http://yasserashraf.atwebpages.com/newphp/upload/products/$img'
      ).toList();
    }
    return [];
  }

  // Calculate discount percentage
  double? get discountPercentage {
    if (discountPrice != null && price > 0) {
      return ((price - discountPrice!) / price) * 100;
    }
    return null;
  }

  // Get final price (with discount if available)
  double get finalPrice {
    return discountPrice ?? price;
  }

  // Check if in stock
  bool get inStock => stockQuantity > 0;

  // Get stock status
  String get stockStatus {
    if (stockQuantity == 0) return 'Out of Stock';
    if (stockQuantity < 10) return 'Low Stock';
    return 'In Stock';
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price)';
  }
}