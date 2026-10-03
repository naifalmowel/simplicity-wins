class StoreSettings {
  final String storeName;
  final String storeNameAr;
  final String logoUrl;
  final String storeImageUrl;
  final String phone;
  final String whatsapp;
  final String instagram;
  final String address;
  final String addressAr;
  final double latitude;
  final double longitude;
  final String googleMapsUrl;
  final String deliveryText;
  final String deliveryTextAr;
  final String slogan;
  final String sloganAr;
  final bool isClosed;
  final bool isBusy;
  final bool whatsappAlwaysActive;
  final String openingHours;

  String get mobileLogoUrl => logoUrl;
  String get locationTitle => 'موقع المحل في التل، ريف دمشق';

  StoreSettings({
    required this.storeName,
    required this.storeNameAr,
    required this.logoUrl,
    required this.storeImageUrl,
    required this.phone,
    required this.whatsapp,
    required this.instagram,
    required this.address,
    required this.addressAr,
    required this.latitude,
    required this.longitude,
    required this.googleMapsUrl,
    required this.deliveryText,
    required this.deliveryTextAr,
    required this.slogan,
    required this.sloganAr,
    this.isClosed = false,
    this.isBusy = false,
    this.whatsappAlwaysActive = true,
    this.openingHours = '10:00 صباحاً - 10:00 مساءً',
  });

  factory StoreSettings.fromMap(Map<String, dynamic> map) {
    return StoreSettings(
      storeName: map['storeName'] ?? 'Simplicity Wins',
      storeNameAr: map['storeNameAr'] ?? 'سيمليسيتي وينز',
      logoUrl: map['logoUrl'] ?? 'assets/images/logo.webp',
      storeImageUrl: map['storeImageUrl'] ?? 'assets/images/cover.webp',
      phone: map['phone'] ?? '0969598176',
      whatsapp: map['whatsapp'] ?? '+963969598176',
      instagram: map['instagram'] ?? 'simplicity__wins',
      address: map['address'] ?? 'Al-Tal, Damascus Suburb, Syria',
      addressAr: map['addressAr'] ?? 'التل، ريف دمشق، سوريا',
      latitude: (map['latitude'] ?? 33.6142).toDouble(),
      longitude: (map['longitude'] ?? 36.3115).toDouble(),
      googleMapsUrl: map['googleMapsUrl'] ?? 'https://maps.google.com/?q=Al-Tal+Damascus',
      deliveryText: map['deliveryText'] ?? 'Delivery within Damascus & shipping to all Syrian governorates',
      deliveryTextAr: map['deliveryTextAr'] ?? 'توصيل ضمن دمشق وشحن لباقي المحافظات السورية',
      slogan: map['slogan'] ?? 'SIMPLICITY ALWAYS WINS',
      sloganAr: map['sloganAr'] ?? 'البساطة دائماً بتربح',
      isClosed: map['isClosed'] ?? false,
      isBusy: map['isBusy'] ?? false,
      whatsappAlwaysActive: map['whatsappAlwaysActive'] ?? true,
      openingHours: map['openingHours'] ?? '10:00 صباحاً - 10:00 مساءً',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storeName': storeName,
      'storeNameAr': storeNameAr,
      'logoUrl': logoUrl,
      'storeImageUrl': storeImageUrl,
      'phone': phone,
      'whatsapp': whatsapp,
      'instagram': instagram,
      'address': address,
      'addressAr': addressAr,
      'latitude': latitude,
      'longitude': longitude,
      'googleMapsUrl': googleMapsUrl,
      'deliveryText': deliveryText,
      'deliveryTextAr': deliveryTextAr,
      'slogan': slogan,
      'sloganAr': sloganAr,
      'isClosed': isClosed,
      'isBusy': isBusy,
      'whatsappAlwaysActive': whatsappAlwaysActive,
      'openingHours': openingHours,
    };
  }
}
