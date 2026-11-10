import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/store_service.dart';
import '../models/store_settings.dart';
import '../theme/app_theme.dart';
import '../screens/catalog_screen.dart';
import '../screens/contact_screen.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final storeService = Provider.of<StoreService>(context);
    final settings = storeService.settings;
    final mobile = MediaQuery.of(context).size.width < 850;

    return Container(
      color: ink,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 20 : 64,
        vertical: mobile ? 48 : 64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _brandColumn(settings),
                    const SizedBox(height: 36),
                    const Divider(color: Color(0xFF2C2C29)),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _linksColumn(context)),
                        const SizedBox(width: 20),
                        Expanded(child: _socialColumn(settings)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _deliveryColumn(settings),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _brandColumn(settings)),
                    const SizedBox(width: 48),
                    Expanded(flex: 2, child: _linksColumn(context)),
                    const SizedBox(width: 48),
                    Expanded(flex: 2, child: _socialColumn(settings)),
                    const SizedBox(width: 48),
                    Expanded(flex: 3, child: _deliveryColumn(settings)),
                  ],
                ),
          const SizedBox(height: 48),
          const Divider(color: Color(0xFF2C2C29)),
          const SizedBox(height: 24),
          mobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '© ${DateTime.now().year} ${settings.storeName.toUpperCase()}. ALL RIGHTS RESERVED.',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'سيمبليسيتي وينز , جميع الحقوق محفوظة 2026',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '© ${DateTime.now().year} ${settings.storeName.toUpperCase()}. ALL RIGHTS RESERVED.',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const Text(
                      'سيمبليسيتي وينز , جميع الحقوق محفوظة 2026',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _brandColumn(StoreSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          settings.storeName.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            fontSize: 20,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 6),
        Text(
          settings.slogan,
          style: const TextStyle(
            color: olive,
            fontSize: 10,
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'متجر أزياء عراقي / سوري راقٍ، يقدم أرقى القطع العصرية المصنوعة بعناية لتناسب أناقتك اليومية.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
            height: 1.7,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _linksColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'روابط سريعة',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 16),
        _footerLinkItem('الرئيسية', () {
          Navigator.popUntil(context, (route) => route.isFirst);
        }),
        const SizedBox(height: 10),
        _footerLinkItem('المنتجات والمجموعات', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CatalogScreen()),
          );
        }),
        const SizedBox(height: 10),
        _footerLinkItem('تواصل معنا', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactScreen()),
          );
        }),
      ],
    );
  }

  Widget _socialColumn(StoreSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'قنوات التواصل',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 16),
        _footerSocialItem(FontAwesomeIcons.whatsapp, 'واتساب', 'https://wa.me/${settings.whatsapp}'),
        const SizedBox(height: 10),
        _footerSocialItem(FontAwesomeIcons.instagram, 'إنستغرام', 'https://instagram.com/${settings.instagram}'),
        const SizedBox(height: 10),
        _footerSocialItem(FontAwesomeIcons.facebookF, 'فيسبوك', settings.facebookUrl),
        const SizedBox(height: 10),
        _footerSocialItem(FontAwesomeIcons.phone, 'اتصال', 'tel:${settings.phone}'),
      ],
    );
  }

  Widget _deliveryColumn(StoreSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'خدمة العملاء والشحن',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.locationDot, size: 13, color: olive),
            const SizedBox(width: 8),
            Text(settings.addressAr, style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Cairo')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.clock, size: 13, color: olive),
            const SizedBox(width: 8),
            Text('ساعات العمل: ${settings.openingHours}', style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Cairo')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.truckFast, size: 13, color: olive),
            const SizedBox(width: 8),
            Expanded(child: Text(settings.deliveryTextAr, style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Cairo', height: 1.5))),
          ],
        ),
      ],
    );
  }

  Widget _footerLinkItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.75),
          fontSize: 12,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  Widget _footerSocialItem(dynamic icon, String label, String url) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 13, color: Colors.white54),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 12,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}

class MaxWidthContainer extends StatelessWidget {
  final Widget child;
  const MaxWidthContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: child,
      ),
    );
  }
}
