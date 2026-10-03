class Offer {
  final String id;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final String imageUrl;
  final String buttonText;
  final String buttonLink;
  final bool isActive;
  final int displayOrder;

  String get image => imageUrl;

  Offer({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.imageUrl,
    required this.buttonText,
    required this.buttonLink,
    this.isActive = true,
    this.displayOrder = 0,
  });

  factory Offer.fromMap(String id, Map<String, dynamic> map) {
    return Offer(
      id: id,
      title: map['title'] ?? '',
      titleAr: map['titleAr'] ?? '',
      description: map['description'] ?? '',
      descriptionAr: map['descriptionAr'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      buttonText: map['buttonText'] ?? 'استكشف',
      buttonLink: map['buttonLink'] ?? '',
      isActive: map['isActive'] ?? true,
      displayOrder: map['displayOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'titleAr': titleAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'imageUrl': imageUrl,
      'buttonText': buttonText,
      'buttonLink': buttonLink,
      'isActive': isActive,
      'displayOrder': displayOrder,
    };
  }
}
