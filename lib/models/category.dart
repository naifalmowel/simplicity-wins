class CategoryModel {
  final String id;
  final String name;
  final String nameAr;
  final String imageUrl;
  final int displayOrder;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.imageUrl,
    this.displayOrder = 0,
    this.isActive = true,
  });

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      nameAr: map['nameAr'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      displayOrder: map['displayOrder'] ?? 0,
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameAr': nameAr,
      'imageUrl': imageUrl,
      'displayOrder': displayOrder,
      'isActive': isActive,
    };
  }
}
