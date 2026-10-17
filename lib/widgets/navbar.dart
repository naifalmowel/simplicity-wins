import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/store_service.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import '../screens/catalog_screen.dart';
import '../screens/contact_screen.dart';
import 'app_image.dart';
import 'cart_modal.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const Navbar({super.key, required this.selectedIndex, required this.onTabSelected});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final storeService = Provider.of<StoreService>(context);
    final settings = storeService.settings;
    final isMobile = MediaQuery.of(context).size.width < 850;

    final navContent = Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
      decoration: BoxDecoration(
        color: paper.withValues(alpha: kIsWeb ? 0.98 : 0.92),
        border: const Border(
          bottom: BorderSide(color: line, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Mobile Drawer Button
          if (isMobile)
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.bars, size: 18, color: ink),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),

          // Logo & Brand Wordmark
          GestureDetector(
            onTap: () => onTabSelected(0),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: olive, width: 1),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: const AppImage(
                    imageUrl: 'assets/images/logo.webp',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      settings.storeName.toUpperCase(),
                      style: GoogleFonts.cairo(
                        fontSize: isMobile ? 13 : 16,
                        fontWeight: FontWeight.w800,
                        color: ink,
                        letterSpacing: isMobile ? 1.2 : 2,
                      ),
                    ),
                    if (!isMobile)
                      Text(
                        settings.slogan,
                        style: const TextStyle(
                          fontSize: 8,
                          letterSpacing: 2,
                          color: muted,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Desktop Nav Links
          if (!isMobile)
            Row(
              children: [
                _navItem('الرئيسية', 0, () => onTabSelected(0)),
                const SizedBox(width: 24),
                _navItem('العروض', 1, () => onTabSelected(1)),
                const SizedBox(width: 24),
                _navItem('المنتجات', 2, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CatalogScreen()),
                  );
                }),
                const SizedBox(width: 24),
                _navItem('تواصل معنا', 3, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContactScreen()),
                  );
                }),
              ],
            ),

          if (!isMobile) const Spacer(),

          // Shopping Cart Button with Live Badge Counter
          Consumer<CartService>(
            builder: (context, cart, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.bagShopping, color: ink, size: 18),
                    onPressed: () {
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
                  if (cart.totalItems > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: ink,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '${cart.totalItems}',
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 6),

          // Mobile WhatsApp Icon Button | Desktop Full CTA Button
          if (isMobile)
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 20, color: ink),
              tooltip: 'طلب عبر الواتساب',
              onPressed: () async {
                final url = Uri.parse('https://wa.me/${settings.whatsapp}?text=مرحباً سيمليسيتي وينز 👋 أود الاستفسار عن التشكيلة المتوفرة');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            )
          else
            ElevatedButton.icon(
              onPressed: () async {
                final url = Uri.parse('https://wa.me/${settings.whatsapp}?text=مرحباً سيمليسيتي وينز 👋 أود الاستفسار عن التشكيلة المتوفرة');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 15, color: Colors.white),
              label: Text(
                'طلب عبر الواتساب',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ink,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: const RoundedRectangleBorder(),
              ),
            ),
        ],
      ),
    );

    return ClipRRect(child: navContent);
  }

  Widget _navItem(String title, int index, VoidCallback onTap) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? ink : muted,
            fontFamily: 'Cairo',
          ),
          child: Text(title),
        ),
      ),
    );
  }
}
