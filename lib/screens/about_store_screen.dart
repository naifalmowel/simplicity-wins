import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/store_service.dart';
import '../widgets/footer.dart';
import '../widgets/app_image.dart';

class AboutStoreScreen extends StatelessWidget {
  const AboutStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storeService = Provider.of<StoreService>(context);
    final settings = storeService.settings;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            color: Colors.white,
            child: Center(
              child: MaxWidthContainer(
                child: Column(
                  children: [
                    Text(
                      settings.storeNameAr,
                      style: GoogleFonts.cairo(fontSize: 36, fontWeight: FontWeight.bold, color: const Color(0xFF111111)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      settings.slogan,
                      style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFFC5A880), letterSpacing: 2),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Story Section
          MaxWidthContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'هوية الماركة والقصة',
                          style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF111111)),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'نؤمن بأن البساطة هي عنوان الأناقة الحقيقية. تأسست علامة سيمبيليتي وينز (Simplicity Wins) في ريف دمشق العريق، وتحديداً في مدينة التل، لنقدم قطع أزياء عصرية تجمع بين الراحة، الجودة العالية، والتفاصيل الدقيقة.',
                          style: GoogleFonts.cairo(fontSize: 16, color: Colors.black87, height: 1.6),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'شعارنا الدائم هو SIMPLICITY ALWAYS WINS، حيث نسعى لتقديم تصاميم متميزة ترضي أصحاب الذوق الرفيع وتمنحهم الثقة في كل إطلالة.',
                          style: GoogleFonts.cairo(fontSize: 16, color: Colors.black87, height: 1.6),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF111111)),
                            const SizedBox(width: 10),
                            Text('توصيل سريع ضمن دمشق', style: GoogleFonts.cairo(fontSize: 15, color: const Color(0xFF111111), fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF111111)),
                            const SizedBox(width: 10),
                            Text('شحن آمن لكافة المحافظات السورية', style: GoogleFonts.cairo(fontSize: 15, color: const Color(0xFF111111), fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  if (MediaQuery.of(context).size.width > 900)
                    Expanded(
                      flex: 6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AppImage(
                          imageUrl: settings.storeImageUrl,
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Location & Contact Card
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            child: MaxWidthContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'موقع المحل وطرق التواصل',
                    style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF111111)),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      _contactCard(Icons.location_on, 'العنوان', settings.addressAr),
                      _contactCard(Icons.phone, 'رقم الهاتف', settings.phone),
                      _contactCard(Icons.camera_alt, 'إنستغرام', '@${settings.instagram}'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(settings.googleMapsUrl);
                      if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
                    },
                    icon: const Icon(Icons.map, color: Colors.white),
                    label: Text(
                      'فتح الخريطة والحصول على الاتجاهات',
                      style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF111111),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Footer(),
        ],
      ),
    );
  }

  Widget _contactCard(IconData icon, String title, String subtitle) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF111111).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF111111)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.cairo(fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 4),
              Text(subtitle, style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF111111))),
            ],
          ),
        ],
      ),
    );
  }
}
