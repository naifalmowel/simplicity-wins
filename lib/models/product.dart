class Product {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final double price;
  final double? oldPrice;
  final int? discountPercent;
  final String categoryId;
  final String categoryName;
  final List<String> imageUrls;
  final List<String> sizes;
  final List<String> colors;
  final String? badge; // جديد, الأكثر مبيعاً, عرض, محدود
  final bool isFeatured;
  final bool isAvailable;
  final bool isActive;
  final int displayOrder;

  String get image => imageUrls.isNotEmpty ? imageUrls.first : '';
  List<String> get gallery => imageUrls.isNotEmpty ? imageUrls : [image];
  String get categoryAr => categoryName;

  Product({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.price,
    this.oldPrice,
    this.discountPercent,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrls,
    required this.sizes,
    required this.colors,
    this.badge,
    this.isFeatured = false,
    this.isAvailable = true,
    this.isActive = true,
    this.displayOrder = 0,
  });

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    double parsedPrice = 0.0;
    if (map['price'] != null) {
      parsedPrice = double.tryParse(map['price'].toString()) ?? 0.0;
    }

    double? parsedOldPrice;
    if (map['oldPrice'] != null) {
      parsedOldPrice = double.tryParse(map['oldPrice'].toString());
    }

    List<String> images = [];
    if (map['imageUrls'] != null && map['imageUrls'] is List) {
      images = List<String>.from((map['imageUrls'] as List).map((e) => e.toString()));
    } else if (map['imageUrl'] != null && map['imageUrl'].toString().isNotEmpty) {
      images = [map['imageUrl'].toString()];
    } else if (map['image'] != null && map['image'].toString().isNotEmpty) {
      images = [map['image'].toString()];
    }

    String catName = map['categoryName'] ?? map['categoryAr'] ?? map['category'] ?? '';

    bool active = map['isActive'] ?? true;
    bool available = map['isAvailable'] ?? true;
    bool featured = map['isFeatured'] == true ||
        map['badge'] == 'جديد' ||
        map['badge'] == 'الأكثر مبيعاً' ||
        map['badge'] == 'عرض' ||
        map['badge'] == 'محدود';

    return Product(
      id: id,
      name: map['name'] ?? '',
      nameAr: (map['nameAr'] != null && map['nameAr'].toString().isNotEmpty)
          ? map['nameAr'].toString()
          : (map['name'] ?? 'منتج'),
      description: map['description'] ?? '',
      descriptionAr: map['descriptionAr'] ?? map['description'] ?? '',
      price: parsedPrice,
      oldPrice: parsedOldPrice,
      discountPercent: map['discountPercent'],
      categoryId: map['categoryId'] ?? '',
      categoryName: catName,
      imageUrls: images,
      sizes: List<String>.from(map['sizes'] ?? ['S', 'M', 'L', 'XL']),
      colors: List<String>.from(map['colors'] ?? ['أسود', 'بيج']),
      badge: map['badge'],
      isFeatured: featured,
      isAvailable: available,
      isActive: active,
      displayOrder: map['displayOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameAr': nameAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'price': price,
      'oldPrice': oldPrice,
      'discountPercent': discountPercent,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'imageUrls': imageUrls,
      'sizes': sizes,
      'colors': colors,
      'badge': badge,
      'isFeatured': isFeatured,
      'isAvailable': isAvailable,
      'isActive': isActive,
      'displayOrder': displayOrder,
    };
  }
}
