import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;
import 'dart:ui_web' as ui_web;

import '../services/store_service.dart';
import '../theme/app_theme.dart';
import '../widgets/footer.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storeService = Provider.of<StoreService>(context);
    final store = storeService.settings;
    final mobile = MediaQuery.sizeOf(context).width < 720;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: paper,
        appBar: AppBar(
          backgroundColor: paper,
          elevation: 0,
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.chevronRight, color: ink, size: 16),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'تواصل معنا وزيارة المتجر',
            style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold, color: ink),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Editorial Header Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: mobile ? 20 : 58, vertical: 42),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: line)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(width: 6, height: 20, color: olive),
                        const SizedBox(width: 8),
                        const Text(
                          'تواصل معنا وزيارة المتجر',
                          style: TextStyle(
                            fontSize: 11,
                            color: olive,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      store.locationTitle,
                      style: TextStyle(
                        fontSize: mobile ? 24 : 36,
                        fontWeight: FontWeight.w800,
                        color: ink,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${store.addressAr} — ${store.deliveryTextAr}',
                      style: const TextStyle(color: muted, fontSize: 13, height: 1.6, fontFamily: 'Cairo'),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.clock, size: 13, color: olive),
                        const SizedBox(width: 6),
                        Text(
                          'ساعات العمل: ${store.openingHours}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ink, fontFamily: 'Cairo'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Equal-Sized Luxury Contact Cards Grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mobile ? 18 : 58),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.start,
                  children: [
                    _contactCard(
                      icon: FontAwesomeIcons.whatsapp,
                      iconColor: const Color(0xFF25D366),
                      title: 'محادثة الواتساب المباشرة',
                      value: store.whatsapp,
                      subtitle: 'لطلب المنتجات والاستفسار عن المقاسات',
                      buttonText: 'محادثة واتساب',
                      onTap: () => _open('https://wa.me/${store.whatsapp}?text=مرحباً سيمليسيتي وينز 👋'),
                    ),
                    _contactCard(
                      icon: FontAwesomeIcons.phone,
                      iconColor: ink,
                      title: 'رقم الهاتف المباشر',
                      value: store.phone,
                      subtitle: 'اتصل بنا مباشرة خلال ساعات العمل لاستقبال طلبك',
                      buttonText: 'اتصال هاتف',
                      onTap: () => _open('tel:${store.phone}'),
                    ),
                    _contactCard(
                      icon: FontAwesomeIcons.instagram,
                      iconColor: const Color(0xFFE1306C),
                      title: 'حساب الإنستغرام',
                      value: '@${store.instagram}',
                      subtitle: 'تابع التغطيات واليوميات والقطع الحصرية',
                      buttonText: 'زيارة إنستغرام',
                      onTap: () => _open('https://instagram.com/${store.instagram}'),
                    ),
                    _contactCard(
                      icon: FontAwesomeIcons.facebookF,
                      iconColor: const Color(0xFF1877F2),
                      title: 'صفحة الفيسبوك',
                      value: store.facebook,
                      subtitle: 'تابع آخر التشكيلات والتحديثات اليومية',
                      buttonText: 'زيارة فيسبوك',
                      onTap: () => _open(store.facebookUrl),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Location & Embedded Google Map Section
              Padding(
                padding: EdgeInsets.fromLTRB(mobile ? 18 : 58, 0, mobile ? 18 : 58, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: line),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.locationDot, size: 18, color: ink),
                        const SizedBox(width: 8),
                        Text(
                          'موقعنا على الخريطة',
                          style: TextStyle(
                            fontSize: mobile ? 20 : 26,
                            fontWeight: FontWeight.bold,
                            color: ink,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const GoogleMapsEmbedWidget(),
                  ],
                ),
              ),

              // Complete Footer
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactCard({
    required dynamic icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 320,
      height: 215,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: line),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FaIcon(icon, color: iconColor, size: 22),
                    Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: muted, fontFamily: 'Cairo')),
                  ],
                ),
                const SizedBox(height: 8),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ink, fontFamily: 'Cairo'), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: muted, height: 1.4, fontFamily: 'Cairo'), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onTap,
                style: FilledButton.styleFrom(
                  backgroundColor: ink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: const RoundedRectangleBorder(),
                ),
                child: Text(buttonText, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _open(String value) async {
    final uri = Uri.tryParse(value);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class GoogleMapsEmbedWidget extends StatelessWidget {
  const GoogleMapsEmbedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // ignore: undefined_prefixed_name
      ui_web.platformViewRegistry.registerViewFactory(
        'google-maps-embed-iframe',
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
        height: 380,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: line),
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        child: const HtmlElementView(viewType: 'google-maps-embed-iframe'),
      );
    } else {
      return Container(
        height: 250,
        alignment: Alignment.center,
        color: const Color(0xffe9e7e0),
        child: const Text('خريطة الموقع - التل، ريف دمشق', style: TextStyle(fontFamily: 'Cairo')),
      );
    }
  }
}
