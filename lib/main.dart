import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/store_service.dart';
import 'services/cart_service.dart';
import 'theme/app_theme.dart';
import 'widgets/navbar.dart';
import 'widgets/mobile_bottom_bar.dart';
import 'widgets/store_status_banner.dart';
import 'widgets/cart_modal.dart';
import 'screens/home_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/contact_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreService()),
        ChangeNotifierProvider(create: (_) => CartService()),
      ],
      child: const SimplicityApp(),
    ),
  );
}

class SimplicityApp extends StatelessWidget {
  const SimplicityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simplicity Wins | ملابس عصرية في التل',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const CatalogHome(),
    );
  }
}

class CatalogHome extends StatefulWidget {
  const CatalogHome({super.key});

  @override
  State<CatalogHome> createState() => _CatalogHomeState();
}

class _CatalogHomeState extends State<CatalogHome> {
  final scroll = ScrollController();
  final GlobalKey scaffoldKey = GlobalKey();

  final GlobalKey topKey = GlobalKey();
  final GlobalKey offersKey = GlobalKey();
  final GlobalKey productsKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  int currentIndex = 0;

  void _scrollToKey(GlobalKey key) {
    final contextKey = key.currentContext;
    if (contextKey != null) {
      Scrollable.ensureVisible(
        contextKey,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _scrollTo(String id) {
    if (id == '#top') {
      _scrollToKey(topKey);
    } else if (id == '#offers') {
      _scrollToKey(offersKey);
    } else if (id == '#products') {
      _scrollToKey(productsKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeService = Provider.of<StoreService>(context);
    final cartService = Provider.of<CartService>(context);
    final store = storeService.settings;
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 720;

    // Automatically purge any out-of-stock products from cart
    cartService.validateCartWithLiveProducts(storeService.products);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: scaffoldKey,
        appBar: Navbar(
          selectedIndex: currentIndex,
          onTabSelected: (index) {
            setState(() => currentIndex = index);
            if (index == 0) _scrollTo('#top');
            if (index == 1) _scrollTo('#offers');
          },
        ),
        drawer: Drawer(
          backgroundColor: paper,
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: ink),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        store.storeName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        store.slogan,
                        style: const TextStyle(
                          fontSize: 9,
                          letterSpacing: 2,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home_outlined, color: ink),
                  title: const Text('الرئيسية', style: TextStyle(fontWeight: FontWeight.w600, color: ink, fontFamily: 'Cairo')),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => currentIndex = 0);
                    _scrollTo('#top');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.local_offer_outlined, color: ink),
                  title: const Text('العروض', style: TextStyle(fontWeight: FontWeight.w600, color: ink, fontFamily: 'Cairo')),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => currentIndex = 1);
                    _scrollTo('#offers');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.grid_view_rounded, color: ink),
                  title: const Text('المنتجات', style: TextStyle(fontWeight: FontWeight.w600, color: ink, fontFamily: 'Cairo')),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CatalogScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_bag_outlined, color: ink),
                  title: Text('سلة المشتريات (${cartService.totalItems})', style: const TextStyle(fontWeight: FontWeight.w600, color: ink, fontFamily: 'Cairo')),
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: paper,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                      builder: (ctx) => const CartModal(),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.chat_bubble_outline, color: ink),
                  title: const Text('تواصل معنا', style: TextStyle(fontWeight: FontWeight.w600, color: ink, fontFamily: 'Cairo')),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ContactScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            StoreStatusBanner(settings: store),
            Expanded(
              child: Stack(
                children: [
                  HomeScreen(
                    scrollController: scroll,
                    topKey: topKey,
                    offersKey: offersKey,
                    productsKey: productsKey,
                    contactKey: contactKey,
                    onSelectCategory: (cat) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CatalogScreen(initialCategory: cat)),
                      );
                    },
                  ),
                  if (mobile)
                    MobileBottomBar(
                      onHome: () {
                        setState(() => currentIndex = 0);
                        _scrollTo('#top');
                      },
                      onOffers: () {
                        setState(() => currentIndex = 1);
                        _scrollTo('#offers');
                      },
                      onCatalog: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CatalogScreen()),
                        );
                      },
                      onContact: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ContactScreen()),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
