import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;
import 'dart:ui_web' as ui_web;

import '../services/store_service.dart';
import '../models/product.dart';
import '../models/offer.dart';
import '../models/store_settings.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import '../widgets/product_detail_modal.dart';
import '../widgets/app_image.dart';
import '../widgets/footer.dart';
import 'catalog_screen.dart';

class HomeScreen extends StatelessWidget {
  final ScrollController scrollController;
  final GlobalKey topKey;
  final GlobalKey offersKey;
  final GlobalKey productsKey;
  final GlobalKey contactKey;
  final Function(String) onSelectCategory;

  const HomeScreen({
    super.key,
    required this.scrollController,
    required this.topKey,
    required this.offersKey,
    required this.productsKey,
    required this.contactKey,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final storeService = Provider.of<StoreService>(context);
    final store = storeService.settings;
    final offers = storeService.offers;
    final allProducts = storeService.products;
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 720;

    // Dynamically group products by their Badge
    final Map<String, List<Product>> badgeGroups = {};
    for (var p in allProducts) {
      final badgeName = (p.badge != null && p.badge!.trim().isNotEmpty) ? p.badge!.trim() : 'جديد';
      badgeGroups.putIfAbsent(badgeName, () => []).add(p);
    }

    if (badgeGroups.isEmpty && allProducts.isNotEmpty) {
      badgeGroups['تشكيلة مميزة'] = allProducts;
    }

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HERO COVER SECTION (#top)
          _hero(context, mobile, store),

          // 2. OFFERS SECTION (Side-by-side if 2 on web, or swipeable carousel) (#offers)
          Container(
            key: offersKey,
            child: OffersCarouselWidget(
              mobile: mobile,
              offers: offers,
            ),
          ),

          // 3. PRODUCTS BY BADGES HORIZONTAL SCROLL RAILS (#products)
          Container(
            key: productsKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: badgeGroups.entries.map((entry) {
                final badgeTitle = entry.key;
                final badgeProducts = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge Section Header
                    Padding(
                      padding: EdgeInsets.fromLTRB(mobile ? 18 : 58, 36, mobile ? 18 : 58, 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 22,
                                color: olive,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                badgeTitle,
                                style: TextStyle(
                                  fontSize: mobile ? 20 : 28,
                                  fontWeight: FontWeight.w800,
                                  color: ink,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CatalogScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'عرض كل المنتجات ←',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: ink,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Horizontal Scrolling Product Rail
                    SizedBox(
                      height: mobile ? 310 : 360,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: mobile ? 18 : 58,
                        ),
                        itemCount: badgeProducts.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final product = badgeProducts[index];
                          return SizedBox(
                            width: mobile ? 190 : 230,
                            child: ProductCard(
                              product: product,
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: paper,
                                  barrierColor: ink.withOpacity(.55),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                  ),
                                  builder: (ctx) => ProductDetailModal(product: product, store: store),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 50),

          // 4. CIRCULAR SOCIAL ICONS & MAP SECTION BEFORE FOOTER
          _circularSocialAndMapSection(mobile, store),

          const SizedBox(height: 20),

          // 5. FOOTER (#contact)
          Container(
            key: contactKey,
            child: const Footer(),
          ),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context, bool mobile, StoreSettings store) {
    final coverImage = mobile ? 'assets/images/cover1.webp' : 'assets/images/cover.webp';

    return Container(
      key: topKey,
      margin: EdgeInsets.fromLTRB(mobile ? 12 : 30, 4, mobile ? 12 : 30, 0),
      height: mobile ? 580 : clampDouble(MediaQuery.sizeOf(context).height * .74, 560, 780),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppImage(
            imageUrl: coverImage,
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Colors.black.withOpacity(.75),
                  Colors.black.withOpacity(.35),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            right: mobile ? 25 : 80,
            top: mobile ? 42 : 58,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                'AL-TAL  /  DAMASCUS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            right: mobile ? 20 : 80,
            bottom: mobile ? 50 : 110,
            left: mobile ? 20 : 80,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 24 * (1 - value)),
                  child: child,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.28),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      store.storeName.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mobile
                            ? 28
                            : clampDouble(
                                MediaQuery.sizeOf(context).width * .055,
                                54,
                                86,
                              ),
                        fontWeight: FontWeight.w800,
                        letterSpacing: mobile ? 3 : 9,
                        height: 1.1,
                        shadows: const [Shadow(color: Colors.black, blurRadius: 8)],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      store.sloganAr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mobile ? 18 : 26,
                        fontWeight: FontWeight.w600,
                        shadows: const [Shadow(color: Colors.black, blurRadius: 6)],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: mobile ? 280 : 390,
                      child: Text(
                        'قطع مختارة بعناية، ستايل عصري، وتفاصيل بتفرق.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(.9),
                          fontSize: mobile ? 12 : 15,
                          height: 1.7,
                          shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CatalogScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: paper,
                        foregroundColor: ink,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('استكشف المجموعة الكاملة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                          SizedBox(width: 12),
                          FaIcon(FontAwesomeIcons.arrowLeft, size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: mobile ? 20 : 62,
            bottom: 16,
            child: const Text(
              '01 — NEW SEASON',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                letterSpacing: 2.2,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black, blurRadius: 6)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Circular Social Icons & Map Section before Footer
  Widget _circularSocialAndMapSection(bool mobile, StoreSettings store) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: mobile ? double.infinity : 900),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: mobile ? 18 : 0),
          padding: EdgeInsets.all(mobile ? 20 : 32),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: line),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              // Circular Social Icon Buttons Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _circularIconButton(
                    icon: FontAwesomeIcons.whatsapp,
                    color: const Color(0xFF25D366),
                    url: 'https://wa.me/${store.whatsapp}?text=مرحباً سيمليسيتي وينز 👋',
                  ),
                  const SizedBox(width: 16),
                  _circularIconButton(
                    icon: FontAwesomeIcons.instagram,
                    color: const Color(0xFFE1306C),
                    url: 'https://instagram.com/${store.instagram}',
                  ),
                  const SizedBox(width: 16),
                  _circularIconButton(
                    icon: FontAwesomeIcons.facebookF,
                    color: const Color(0xFF1877F2),
                    url: store.facebookUrl,
                  ),
                  const SizedBox(width: 16),
                  _circularIconButton(
                    icon: FontAwesomeIcons.phone,
                    color: ink,
                    url: 'tel:${store.phone}',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Google Maps Embed
              const GoogleMapsEmbedWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circularIconButton({required dynamic icon, required Color color, required String url}) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: paper,
          border: Border.all(color: line, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FaIcon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

// Offers Widget: Side-by-side if 2 on web, or swipeable carousel
class OffersCarouselWidget extends StatelessWidget {
  final bool mobile;
  final List<Offer> offers;

  const OffersCarouselWidget({
    super.key,
    required this.mobile,
    required this.offers,
  });

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) return const SizedBox.shrink();

    // If on Web/Desktop and exactly 2 offers -> Display them side by side simultaneously!
    if (!mobile && offers.length == 2) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mobile ? 18 : 0, vertical: 36),
            child: Row(
              children: [
                Expanded(child: _buildOfferCard(context, offers[0], 0)),
                const SizedBox(width: 24),
                Expanded(child: _buildOfferCard(context, offers[1], 1)),
              ],
            ),
          ),
        ),
      );
    }

    // Otherwise (Mobile or 1 offer or 3+ offers) -> Interactive Carousel
    return _OffersSwipeableCarousel(mobile: mobile, offers: offers);
  }

  Widget _buildOfferCard(BuildContext context, Offer offer, int index) {
    return Container(
      height: 380,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xffdedbd2),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppImage(imageUrl: offer.image, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(.85),
                  Colors.black.withOpacity(.40),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            right: 24,
            bottom: 24,
            left: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.28),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'CURATED FOR YOU  /  0${index + 1}',
                    style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 2),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    offer.titleAr,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, shadows: [Shadow(color: Colors.black, blurRadius: 6)]),
                  ),
                  const SizedBox(height: 4),
                  Text(offer.descriptionAr, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CatalogScreen()),
                      );
                    },
                    icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 14, color: Colors.white),
                    label: Text(offer.buttonText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 20,
            child: Text(
              'S/W  —  DROP 0${index + 1}',
              style: const TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, blurRadius: 6)]),
            ),
          ),
        ],
      ),
    );
  }
}

// Swipeable Carousel for 1 or 3+ offers
class _OffersSwipeableCarousel extends StatefulWidget {
  final bool mobile;
  final List<Offer> offers;

  const _OffersSwipeableCarousel({required this.mobile, required this.offers});

  @override
  State<_OffersSwipeableCarousel> createState() => _OffersSwipeableCarouselState();
}

class _OffersSwipeableCarouselState extends State<_OffersSwipeableCarousel> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (widget.offers.length > 1) {
        if (!mounted) return;
        int nextPage = (_currentPage + 1) % widget.offers.length;
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.mobile ? double.infinity : 900),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(widget.mobile ? 18 : 0, 36, widget.mobile ? 18 : 0, 14),
              height: widget.mobile ? 320 : 390,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xffdedbd2),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.offers.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      final offer = widget.offers[index];
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          AppImage(imageUrl: offer.image, fit: BoxFit.cover),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(.85),
                                  Colors.black.withOpacity(.40),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: widget.mobile ? 16 : 56,
                            bottom: widget.mobile ? 20 : 48,
                            left: widget.mobile ? 16 : 56,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.28),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'CURATED FOR YOU  /  0${index + 1}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 2),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    offer.titleAr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: widget.mobile ? 20 : 32,
                                      fontWeight: FontWeight.w700,
                                      shadows: const [Shadow(color: Colors.black, blurRadius: 6)],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(offer.descriptionAr, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                  const SizedBox(height: 12),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const CatalogScreen()),
                                      );
                                    },
                                    icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 14, color: Colors.white),
                                    label: Text(offer.buttonText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Positioned(
                    left: 20,
                    top: 20,
                    child: Text(
                      'S/W  —  DROP 0${_currentPage + 1}',
                      style: TextStyle(color: Colors.white.withOpacity(.9), fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.bold, shadows: const [Shadow(color: Colors.black, blurRadius: 6)]),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.offers.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.offers.length,
                  (index) {
                    final isSelected = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isSelected ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2980B9) : line,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class GoogleMapsEmbedWidget extends StatelessWidget {
  const GoogleMapsEmbedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // ignore: undefined_prefixed_name
      ui_web.platformViewRegistry.registerViewFactory(
        'google-maps-embed-iframe-home',
        (int viewId) {
          final iframe = web.HTMLIFrameElement();
          iframe.src = 'https://www.google.com/maps/embed?pb=!1m17!1m12!1m3!1d3322.657117640591!2d36.31368868479643!3d33.61419998072737!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m2!1m1!2zMzPCsDM2JzUxLjEiTiAzNsKwMTgnNDEuNCJF!5e0!3m2!1sar!2sae!4v1791014607708!5m2!1sar!2sae';
          iframe.style.border = 'none';
          iframe.style.width = '100%';
          iframe.style.height = '100%';
          return iframe;
        },
      );
      return Container(
        height: 320,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: line),
          borderRadius: BorderRadius.circular(2),
        ),
        clipBehavior: Clip.antiAlias,
        child: const HtmlElementView(viewType: 'google-maps-embed-iframe-home'),
      );
    } else {
      return Container(
        height: 220,
        alignment: Alignment.center,
        color: const Color(0xffe9e7e0),
        child: const Text('خريطة الموقع - التل، ريف دمشق', style: TextStyle(fontFamily: 'Cairo')),
      );
    }
  }
}
