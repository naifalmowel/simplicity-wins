import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/offer.dart';
import '../models/store_settings.dart';

class StoreService extends ChangeNotifier {
  StoreSettings _settings = StoreSettings(
    storeName: 'Simplicity Wins',
    storeNameAr: 'سيمليسيتي وينز',
    logoUrl: '',
    storeImageUrl: 'assets/images/cover.webp',
    phone: '0969598176',
    whatsapp: '+963969598176',
    instagram: 'simplicity__wins',
    address: 'Al-Tal, Damascus Suburb, Syria',
    addressAr: 'التل، ريف دمشق، سوريا',
    latitude: 33.6142,
    longitude: 36.3115,
    googleMapsUrl: 'https://maps.google.com/?q=Al-Tal+Damascus',
    deliveryText: 'Delivery within Damascus & shipping to all Syrian governorates',
    deliveryTextAr: 'توصيل ضمن دمشق وشحن لباقي المحافظات السورية',
    slogan: 'SIMPLICITY ALWAYS WINS',
    sloganAr: 'البساطة دائماً بتربح',
  );

  List<CategoryModel> _categories = [
    CategoryModel(id: 'cat_all', name: 'All', nameAr: 'الكل', imageUrl: 'assets/images/cover.webp', displayOrder: 1),
    CategoryModel(id: 'cat_new', name: 'New Collection', nameAr: 'جديد', imageUrl: 'assets/images/cover1.webp', displayOrder: 2),
    CategoryModel(id: 'cat_mens', name: 'Men', nameAr: 'رجالي', imageUrl: 'assets/images/cover.webp', displayOrder: 3),
    CategoryModel(id: 'cat_womens', name: 'Women', nameAr: 'نسائي', imageUrl: 'assets/images/cover1.webp', displayOrder: 4),
    CategoryModel(id: 'cat_tees', name: 'T-Shirts', nameAr: 'تيشيرتات', imageUrl: 'assets/images/cover.webp', displayOrder: 5),
    CategoryModel(id: 'cat_pants', name: 'Pants', nameAr: 'بناطيل', imageUrl: 'assets/images/cover1.webp', displayOrder: 6),
    CategoryModel(id: 'cat_jackets', name: 'Jackets', nameAr: 'جاكيتات', imageUrl: 'assets/images/cover.webp', displayOrder: 7),
    CategoryModel(id: 'cat_outfits', name: 'Outfits', nameAr: 'أطقم', imageUrl: 'assets/images/cover1.webp', displayOrder: 8),
  ];

  List<Offer> _offers = [
    Offer(
      id: 'offer_1',
      title: 'New Season Drop',
      titleAr: 'مجموعة الموسم الجديد',
      description: 'Carefully curated minimal styles designed for confidence and everyday elegance.',
      descriptionAr: 'قطع مختارة بعناية، ستايل عصري، وتفاصيل بتفرق.',
      imageUrl: 'assets/images/cover.webp',
      buttonText: 'استكشف المجموعة',
      buttonLink: 'cat_new',
      displayOrder: 1,
    ),
    Offer(
      id: 'offer_2',
      title: 'Limited Edition Hoodies',
      titleAr: 'هوديز إصدار محدود',
      description: 'Premium heavyweight cotton with refined minimalist branding.',
      descriptionAr: 'قطن فاخر عالي الجودة بتصميم مميز يجمع بين الراحة والأناقة.',
      imageUrl: 'assets/images/cover1.webp',
      buttonText: 'تسوق الآن',
      buttonLink: 'cat_jackets',
      displayOrder: 2,
    ),
  ];

  List<Product> _products = [
    Product(
      id: 'p1',
      name: 'Minimalist Oversized Hoodie',
      nameAr: 'هوديز أوفرسايز بتصميم أنيق',
      description: 'Crafted from premium organic cotton fleece. Designed for ultimate comfort and modern relaxed fit.',
      descriptionAr: 'مصنوع من صوف القطن العضوي الفاخر. تصميم مريح ومناسب للإطلالات العصرية اليومية.',
      price: 185000,
      oldPrice: 220000,
      discountPercent: 15,
      categoryId: 'cat_jackets',
      categoryName: 'جاكيتات',
      imageUrls: [
        'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['أسود فاخر', 'رمادي فحم', 'أبيض عاجي'],
      badge: 'جديد',
      isFeatured: true,
      displayOrder: 1,
    ),
    Product(
      id: 'p2',
      name: 'Essential Structured Trench Coat',
      nameAr: 'معطف ترنش أساسي أنيق',
      description: 'A timeless silhouette tailored for versatile layering across seasons in Damascus weather.',
      descriptionAr: 'قصة كلاسيكية خالدة مصممة بعناية لتلائم مختلف الأوقات والإطلالات.',
      price: 320000,
      oldPrice: 380000,
      discountPercent: 16,
      categoryId: 'cat_jackets',
      categoryName: 'جاكيتات',
      imageUrls: [
        'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['S', 'M', 'L'],
      colors: ['بيج رملي', 'أسود'],
      badge: 'الأكثر مبيعاً',
      isFeatured: true,
      displayOrder: 2,
    ),
    Product(
      id: 'p3',
      name: 'Simplicity Heavyweight Tee',
      nameAr: 'تيشيرت قطني فاخر ثقيل الوزن',
      description: 'Heavy cotton jersey with subtle chest embroidery representing Simplicity Wins.',
      descriptionAr: 'تيشيرت قطني متين وناعم مع مطرزات أنيقة تحمل هوية سيمبيليتي وينز.',
      price: 95000,
      categoryId: 'cat_tees',
      categoryName: 'تيشيرتات',
      imageUrls: [
        'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      colors: ['أسود', 'أبيض', 'زيتي داكن'],
      badge: 'عرض',
      isFeatured: true,
      displayOrder: 3,
    ),
    Product(
      id: 'p4',
      name: 'Tailored Wide-Leg Trousers',
      nameAr: 'بنطال واسع بتصميم راقٍ',
      description: 'Relaxed tailoring offering immaculate drape and day-long comfort.',
      descriptionAr: 'بنطال واسع مريح يمنح إطلالتك حضوراً راقياً وعصرياً.',
      price: 160000,
      oldPrice: 190000,
      discountPercent: 15,
      categoryId: 'cat_pants',
      categoryName: 'بناطيل',
      imageUrls: [
        'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&w=800&q=80',
      ],
      sizes: ['38', '40', '42', '44'],
      colors: ['أسود', 'رمادي داكن'],
      badge: 'محدود',
      isFeatured: true,
      displayOrder: 4,
    ),
  ];

  StoreSettings get settings => _settings;
  List<CategoryModel> get categories => _categories;
  List<Offer> get offers => _offers;
  List<Product> get products => _products;

  StoreService() {
    _initFirebaseListeners();
  }

  void _initFirebaseListeners() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyDTiaEJKBs42uijM5f7Mfw58RKJXs1guZY",
            authDomain: "simplicity-wins-76c7a.firebaseapp.com",
            projectId: "simplicity-wins-76c7a",
            storageBucket: "simplicity-wins-76c7a.firebasestorage.app",
            messagingSenderId: "810221326447",
            appId: "1:810221326447:web:7c2b5f99f0e6aa7c443d9a",
            measurementId: "G-HRZZFZ1NYQ",
          ),
        );
      }

      final db = FirebaseFirestore.instance;

      // 1. Listen to Store Settings
      db.collection('settings').doc('store').snapshots().listen(
        (snapshot) {
          if (snapshot.exists && snapshot.data() != null) {
            _settings = StoreSettings.fromMap(snapshot.data()!);
            notifyListeners();
          }
        },
        onError: (e) => debugPrint('Firestore settings error: $e'),
      );

      // 2. Listen to Products Stream (Real-Time Live Updates from External Dashboard)
      db.collection('products').snapshots().listen(
        (snapshot) {
          final fetched = snapshot.docs
              .map((doc) => Product.fromMap(doc.id, doc.data()))
              .where((p) => p.isActive)
              .toList();
          if (fetched.isNotEmpty) {
            _products = fetched;
            notifyListeners();
          }
        },
        onError: (e) => debugPrint('Firestore products error: $e'),
      );

      // 3. Listen to Categories Stream
      db.collection('categories').snapshots().listen(
        (snapshot) {
          final fetched = snapshot.docs
              .map((doc) => CategoryModel.fromMap(doc.id, doc.data()))
              .where((c) => c.isActive)
              .toList();
          if (fetched.isNotEmpty) {
            fetched.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
            _categories = fetched;
            notifyListeners();
          }
        },
        onError: (e) => debugPrint('Firestore categories error: $e'),
      );

      // 4. Listen to Offers Stream
      db.collection('offers').snapshots().listen(
        (snapshot) {
          final fetched = snapshot.docs
              .map((doc) => Offer.fromMap(doc.id, doc.data()))
              .where((o) => o.isActive)
              .toList();
          if (fetched.isNotEmpty) {
            fetched.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
            _offers = fetched;
            notifyListeners();
          }
        },
        onError: (e) => debugPrint('Firestore offers error: $e'),
      );

    } catch (e) {
      debugPrint('Firebase Real-Time Listeners note: $e');
    }
  }
}
