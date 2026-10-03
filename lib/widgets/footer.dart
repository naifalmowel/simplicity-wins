import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/store_service.dart';
import '../theme/app_theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final storeService = Provider.of<StoreService>(context);
    final settings = storeService.settings;
    final mobile = MediaQuery.of(context).size.width < 720;

    return Container(
      color: ink,
      padding: EdgeInsets.fromLTRB(mobile ? 18 : 58, 48, mobile ? 18 : 58, 28),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      settings.storeName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      settings.slogan,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 9,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      settings.addressAr,
                      style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Cairo'),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      settings.deliveryTextAr,
                      style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Cairo'),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _footerLink(
                    'Instagram  @${settings.instagram}',
                    'https://instagram.com/${settings.instagram}',
                  ),
                  _footerLink(
                    'اتصل بنا  ${settings.phone}',
                    'tel:${settings.phone}',
                  ),
                  _footerLink(
                    'واتساب',
                    'https://wa.me/${settings.whatsapp}',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 36),
          const Divider(color: Color(0xFF3A3A36)),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '© ${DateTime.now().year} SIMPLICITY WINS',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 9,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Text(
                'مصممة بعناية، من التل.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .6),
                  fontSize: 9,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String text, String url) => TextButton(
        onPressed: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white70,
          padding: const EdgeInsets.symmetric(vertical: 2),
        ),
        child: Text(text, style: const TextStyle(fontSize: 10, fontFamily: 'Cairo')),
      );
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
