import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/cart_service.dart';
import '../services/store_service.dart';
import '../theme/app_theme.dart';
import 'app_image.dart';

class CartModal extends StatelessWidget {
  const CartModal({super.key});

  String _formatPrice(double n) => '${(n / 1000).round()} ألف ل.س';

  String _formatWhatsappNumber(String whatsapp) {
    final number = whatsapp.replaceAll(RegExp(r'\D'), '');
    if (number.startsWith('0')) return '963${number.substring(1)}';
    if (number.startsWith('9')) return '963$number';
    return number;
  }

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final storeService = Provider.of<StoreService>(context);
    final settings = storeService.settings;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.85,
        decoration: const BoxDecoration(
          color: paper,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: ink,
              child: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.bagShopping, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    'سلة المشتريات (${cartService.totalItems})',
                    style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.xmark, color: Colors.white, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Cart Items List
            Expanded(
              child: cartService.items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(FontAwesomeIcons.bagShopping, size: 48, color: muted),
                          const SizedBox(height: 16),
                          Text(
                            'السلة فارغة حالياً',
                            style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: ink),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'تصفحي المجموعات واختاري ملابسك المفضلة وحفظها بالسلة',
                            style: GoogleFonts.cairo(fontSize: 13, color: muted),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: cartService.items.length,
                      separatorBuilder: (_, __) => const Divider(color: line, height: 24),
                      itemBuilder: (context, index) {
                        final item = cartService.items[index];
                        return Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
                              clipBehavior: Clip.antiAlias,
                              child: AppImage(imageUrl: item.product.image, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.nameAr,
                                    style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold, color: ink),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 6,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(border: Border.all(color: line)),
                                        child: Text('المقاس: ${item.selectedSize}', style: const TextStyle(fontSize: 10, color: ink, fontFamily: 'Cairo')),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(border: Border.all(color: line)),
                                        child: Text('اللون: ${item.selectedColor}', style: const TextStyle(fontSize: 10, color: ink, fontFamily: 'Cairo')),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _formatPrice(item.product.price * item.quantity),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ink, fontFamily: 'Cairo'),
                                  ),
                                ],
                              ),
                            ),

                            // Quantity Controls
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => cartService.updateQuantity(item.id, -1),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(border: Border.all(color: line)),
                                    child: const Center(child: FaIcon(FontAwesomeIcons.minus, size: 10, color: ink)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    '${item.quantity}',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ink),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => cartService.updateQuantity(item.id, 1),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(border: Border.all(color: line)),
                                    child: const Center(child: FaIcon(FontAwesomeIcons.plus, size: 10, color: ink)),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(width: 10),
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.trashCan, size: 16, color: Colors.redAccent),
                              onPressed: () => cartService.removeItem(item.id),
                            ),
                          ],
                        );
                      },
                    ),
            ),

            // Footer / Order Summary
            if (cartService.items.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: line)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'المجموع الكلي:',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ink, fontFamily: 'Cairo'),
                        ),
                        Text(
                          _formatPrice(cartService.totalPrice),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ink, fontFamily: 'Cairo'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () async {
                          final num = _formatWhatsappNumber(settings.whatsapp);
                          final itemsList = cartService.items.asMap().entries.map((e) {
                            final i = e.key + 1;
                            final item = e.value;
                            return '$i. ${item.product.nameAr}\n- المقاس: ${item.selectedSize}\n- اللون: ${item.selectedColor}\n- الكمية: ${item.quantity}\n- السعر: ${_formatPrice(item.product.price * item.quantity)}';
                          }).join('\n\n');

                          final message = '''مرحباً سيمليسيتي وينز 👋
أود طلب المنتجات التالية من السلة:

$itemsList

📌 الإجمالي الكلي: ${_formatPrice(cartService.totalPrice)}''';

                          final url = 'https://wa.me/$num?text=${Uri.encodeComponent(message)}';
                          final uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                        icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 16),
                        label: Text(
                          'اطلب السلة عبر الواتساب الآن',
                          style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: ink,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(),
                        ),
                      ),
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
