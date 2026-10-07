enum ProductStatus { active, inactive, outOfStock, pending, rejected }

/// Material & Construction Product Model
class ProductModel {
  final String id;
  final String vendorId;
  final String vendorName;
  final String name;
  final String description;
  final String categoryId;
  final String categoryName;
  final String brand;
  final List<String> images;
  final double price;
  final String unit; // 'bag', 'kg', 'piece', 'metric ton', 'sq.ft'
  final int minimumOrderQuantity;
  final int stock;
  final int lowStockThreshold;
  final bool deliveryAvailable;
  final double deliveryRadiusKm;
  final ProductStatus status;
  final double rating;
  final int reviewCount;
  final String specifications;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.brand,
    required this.images,
    required this.price,
    required this.unit,
    this.minimumOrderQuantity = 1,
    required this.stock,
    this.lowStockThreshold = 10,
    this.deliveryAvailable = true,
    this.deliveryRadiusKm = 25.0,
    this.status = ProductStatus.active,
    this.rating = 4.8,
    this.reviewCount = 50,
    this.specifications = '',
    required this.createdAt,
  });

  bool get isLowStock => stock <= lowStockThreshold && stock > 0;
  bool get isOutOfStock => stock <= 0 || status == ProductStatus.outOfStock;
  bool get isApproved => status == ProductStatus.active || status == ProductStatus.outOfStock;

  Map<String, dynamic> toJson() => {
        'id': id,
        'vendorId': vendorId,
        'vendorName': vendorName,
        'name': name,
        'description': description,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'brand': brand,
        'images': images,
        'price': price,
        'unit': unit,
        'minimumOrderQuantity': minimumOrderQuantity,
        'stock': stock,
        'lowStockThreshold': lowStockThreshold,
        'deliveryAvailable': deliveryAvailable,
        'deliveryRadiusKm': deliveryRadiusKm,
        'status': status.name,
        'rating': rating,
        'reviewCount': reviewCount,
        'specifications': specifications,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as String? ?? '',
        vendorId: json['vendorId'] as String? ?? '',
        vendorName: json['vendorName'] as String? ?? '',
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        categoryId: json['categoryId'] as String? ?? '',
        categoryName: json['categoryName'] as String? ?? '',
        brand: json['brand'] as String? ?? '',
        images: List<String>.from(json['images'] ?? []),
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        unit: json['unit'] as String? ?? 'piece',
        minimumOrderQuantity: (json['minimumOrderQuantity'] as num?)?.toInt() ?? 1,
        stock: (json['stock'] as num?)?.toInt() ?? 0,
        lowStockThreshold: (json['lowStockThreshold'] as num?)?.toInt() ?? 10,
        deliveryAvailable: json['deliveryAvailable'] as bool? ?? true,
        deliveryRadiusKm: (json['deliveryRadiusKm'] as num?)?.toDouble() ?? 25.0,
        status: ProductStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => ProductStatus.active,
        ),
        rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
        reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 50,
        specifications: json['specifications'] as String? ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
            : DateTime.now(),
      );
}