class Order {
  final String id;
  final String userId;
  final String? userName;
  final String? userEmail;
  final String? userPhone;
  final String addressId;
  final String? addressName;
  final String? addressDetails;
  final String type; // 0: delivery, 1: pickup
  final double deliveryPrice;
  final double itemsPrice;
  final double totalPrice;
  final String? couponId;
  final double couponDiscount;
  final String paymentMethod; // 0: cash, 1: card
  final String status; // 0: pending, 1: preparing, 2: ready, 3: on way, 4: delivered, 5: cancelled
  final DateTime orderDate;
  final String? deliveryManId;
  final String? deliveryManName;
  final String? notes;
  final List<OrderItem>? items;
  final String? cancellationReason;

  Order({
    required this.id,
    required this.userId,
    this.userName,
    this.userEmail,
    this.userPhone,
    required this.addressId,
    this.addressName,
    this.addressDetails,
    required this.type,
    required this.deliveryPrice,
    required this.itemsPrice,
    required this.totalPrice,
    this.couponId,
    this.couponDiscount = 0,
    required this.paymentMethod,
    required this.status,
    required this.orderDate,
    this.deliveryManId,
    this.deliveryManName,
    this.notes,
    this.items,
    this.cancellationReason,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name'],
      userEmail: json['user_email'],
      userPhone: json['user_phone'],
      addressId: json['address_id']?.toString() ?? '',
      addressName: json['address_name'],
      addressDetails: json['address_details'],
      type: json['type']?.toString() ?? '0',
      deliveryPrice: double.tryParse(json['delivery_price']?.toString() ?? '0') ?? 0.0,
      itemsPrice: double.tryParse(json['items_price']?.toString() ?? '0') ?? 0.0,
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      couponId: json['coupon_id']?.toString(),
      couponDiscount: double.tryParse(json['coupon_discount']?.toString() ?? '0') ?? 0.0,
      paymentMethod: json['payment_method']?.toString() ?? '0',
      status: json['status']?.toString() ?? '0',
      orderDate: json['order_date'] != null
          ? DateTime.parse(json['order_date'])
          : DateTime.now(),
      deliveryManId: json['delivery_man_id']?.toString(),
      deliveryManName: json['delivery_man_name'],
      notes: json['notes'],
      items: json['items'] != null
          ? (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList()
          : null,
      cancellationReason: json['cancellation_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'user_phone': userPhone,
      'address_id': addressId,
      'address_name': addressName,
      'address_details': addressDetails,
      'type': type,
      'delivery_price': deliveryPrice,
      'items_price': itemsPrice,
      'total_price': totalPrice,
      'coupon_id': couponId,
      'coupon_discount': couponDiscount,
      'payment_method': paymentMethod,
      'status': status,
      'order_date': orderDate.toIso8601String(),
      'delivery_man_id': deliveryManId,
      'delivery_man_name': deliveryManName,
      'notes': notes,
      'items': items?.map((i) => i.toJson()).toList(),
      'cancellation_reason': cancellationReason,
    };
  }

  // Get status text
  String get statusText {
    switch (status) {
      case '0': return 'Pending Approval';
      case '1': return 'Preparing';
      case '2': return 'Ready for Pickup';
      case '3': return 'On the Way';
      case '4': return 'Delivered';
      case '5': return 'Cancelled';
      default: return 'Unknown';
    }
  }

  // Get delivery type text
  String get deliveryTypeText {
    return type == '0' ? 'Home Delivery' : 'Store Pickup';
  }

  // Get payment method text
  String get paymentMethodText {
    return paymentMethod == '0' ? 'Cash on Delivery' : 'Payment Card';
  }

  // Check if order can be cancelled
  bool get canBeCancelled {
    return status == '0' || status == '1';
  }

  // Check if order can be edited
  bool get canBeEdited {
    return status == '0';
  }

  @override
  String toString() {
    return 'Order(id: $id, status: $statusText, total: $totalPrice)';
  }
}

class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;
  final double total;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
    required this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name'] ?? '',
      productImage: json['product_image'],
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'price': price,
      'quantity': quantity,
      'total': total,
    };
  }

  // Get product image URL
  String? get productImageUrl {
    if (productImage != null && productImage!.isNotEmpty) {
      return 'http://yasserashraf.atwebpages.com/newphp/upload/products/$productImage';
    }
    return null;
  }
}