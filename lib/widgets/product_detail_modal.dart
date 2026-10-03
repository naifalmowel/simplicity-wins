import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/product.dart';
import '../models/store_settings.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import 'app_image.dart';

class ProductDetailModal extends StatefulWidget {
  final Product product;
  final StoreSettings store;

  const ProductDetailModal({super.key, required this.product, required this.store});

  @override
  State<ProductDetailModal> createState() => _ProductDetailModalState();
}

class _ProductDetailModalState extends State<ProductDetailModal> {
  int currentImage = 0;
  final PageController pageController = PageController();

  String? selectedSize;
  String? selectedColor;
  bool isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.product.sizes.isNotEmpty) {
      selectedSize = widget.product.sizes.first;
    }
    if (widget.product.colors.isNotEmpty) {
      selectedColor = widget.product.colors.first;
    }
  }

  String _formatPrice(double n) => '${(n / 1000).round()} ألف ل.س';

  String _formatWhatsappNumber(String whatsapp) {
    final number = whatsapp.replaceAll(RegExp(r'\D'), '');
    if (number.startsWith('0')) return '963${number.substring(1)}';
    if (number.startsWith('9')) return '963$number';
    return number;
  }

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 720;
    final product = widget.product;
    final cartService = Provider.of<CartService>(context, listen: false);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: mobile ? 0.88 : 0.82,
        minChildSize: 0.50,
        maxChildSize: 0.96,
        builder: (ctx, controller) => Container(
          decoration: const BoxDecoration(
            color: paper,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Column(
            children: [
              // Drag Indicator Bar
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Scrollable Details Body
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: EdgeInsets.all(mobile ? 16 : 30),
                  child: mobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _detailImage(product, 220),
                            const SizedBox(height: 16),
                            _detailCopy(product),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _detailImage(product, 420)),
                            const SizedBox(width: 32),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: _detailCopy(product),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              // STICKY ALWAYS-VISIBLE BOTTOM ACTION BAR
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: line, width: 1)),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: !product.isAvailable
                              ? null
                              : () {
                                  cartService.addItem(
                                    product: product,
                                    size: selectedSize ?? (product.sizes.isNotEmpty ? product.sizes.first : 'M'),
                                    color: selectedColor ?? (product.colors.isNotEmpty ? product.colors.first : 'أسود'),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تمت إضافة القطعة إلى السلة ✨', style: TextStyle(fontFamily: 'Cairo')),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                          icon: const FaIcon(FontAwesomeIcons.cartPlus, size: 14, color: ink),
                          label: const Text(
                            'إضافة للسلة',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ink, fontFamily: 'Cairo'),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: ink, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: const RoundedRectangleBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: !product.isAvailable
                              ? null
                              : () async {
                                  final num = _formatWhatsappNumber(widget.store.whatsapp);
                                  final imageUrl = product.imageUrls.isNotEmpty ? product.imageUrls.first : '';
                                  final message = '''مرحباً سيمليسيتي وينز 👋
أود طلب المنتج التالي:
📌 المنتج: ${product.nameAr}
🏷️ السعر: ${_formatPrice(product.price)}
📏 المقاس: ${selectedSize ?? 'غير محدد'}
🎨 اللون: ${selectedColor ?? 'غير محدد'}
🖼️ الصورة: $imageUrl''';

                                  final url = 'https://wa.me/$num?text=${Uri.encodeComponent(message)}';
                                  final uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  }
                                },
                          icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 15),
                          label: Text(
                            product.isAvailable ? 'طلب عبر الواتساب' : 'غير متوفر',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: product.isAvailable ? ink : muted,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: const RoundedRectangleBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailImage(Product p, double h) {
    final images = p.gallery;
    return Column(
      children: [
        SizedBox(
          height: h,
          width: double.infinity,
          child: Stack(
            children: [
              PageView.builder(
                controller: pageController,
                itemCount: images.length,
                onPageChanged: (index) => setState(() => currentImage = index),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => showDialog<void>(
                    context: context,
                    barrierColor: Colors.black,
                    builder: (_) => _fullImageViewer(images, index),
                  ),
                  child: index == 0
                      ? Hero(
                          tag: p.id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: AppImage(imageUrl: images[index], fit: BoxFit.contain),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: AppImage(imageUrl: images[index], fit: BoxFit.contain),
                        ),
                ),
              ),
              if (images.length > 1)
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      images.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == currentImage ? 16 : 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: i == currentImage ? .85 : .35),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (images.length > 1) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() => currentImage = index);
                  pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 44,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: currentImage == index ? ink : line,
                      width: currentImage == index ? 1.5 : 1,
                    ),
                  ),
                  child: AppImage(imageUrl: images[index], fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _fullImageViewer(List<String> images, int initial) => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
              controller: PageController(initialPage: initial),
              itemCount: images.length,
              itemBuilder: (context, index) => Center(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: AppImage(imageUrl: images[index], fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              top: 36,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                color: Colors.white,
                icon: const FaIcon(FontAwesomeIcons.xmark, size: 22, color: Colors.white),
              ),
            ),
          ],
        ),
      );

  Widget _detailCopy(Product p) {
    final hasLongDescription = p.descriptionAr.length > 80;
    final displayDescription = (hasLongDescription && !isDescriptionExpanded)
        ? '${p.descriptionAr.substring(0, 80)}...'
        : p.descriptionAr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          p.categoryAr.toUpperCase(),
          style: const TextStyle(color: olive, fontSize: 10, letterSpacing: 1),
        ),
        const SizedBox(height: 6),
        Text(
          p.nameAr,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: ink, fontFamily: 'Cairo'),
        ),
        if (!p.isAvailable) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            color: Colors.black12,
            child: const Text('نفذت الكمية حالياً', style: TextStyle(color: muted, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          ),
        ],
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              _formatPrice(p.price),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink, fontFamily: 'Cairo'),
            ),
            if (p.oldPrice != null) ...[
              const SizedBox(width: 8),
              Text(
                _formatPrice(p.oldPrice!),
                style: const TextStyle(
                  color: muted,
                  fontSize: 12,
                  decoration: TextDecoration.lineThrough,
                  fontFamily: 'Cairo',
                ),
              ),
              if (p.oldPrice! > p.price) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: const Color(0xFFE9E7E0),
                  child: Text(
                    '-${((p.oldPrice! - p.price) / p.oldPrice! * 100).round()}%',
                    style: const TextStyle(fontSize: 10, color: olive, fontFamily: 'Cairo'),
                  ),
                ),
              ],
            ],
          ],
        ),
        const SizedBox(height: 12),

        // Description with Expandable "اقرأ المزيد"
        Text(
          displayDescription,
          style: const TextStyle(fontSize: 13, height: 1.6, color: muted, fontFamily: 'Cairo'),
        ),
        if (hasLongDescription)
          GestureDetector(
            onTap: () => setState(() => isDescriptionExpanded = !isDescriptionExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                isDescriptionExpanded ? 'اقرأ أقل ▲' : 'اقرأ المزيد... ▼',
                style: const TextStyle(fontSize: 11, color: ink, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
            ),
          ),

        // Sizes Selector
        if (p.sizes.isNotEmpty) ...[
          const SizedBox(height: 14),
          const Text(
            'اختر المقاس:',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ink, fontFamily: 'Cairo'),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: p.sizes.map((s) {
              final isSelected = selectedSize == s;
              return GestureDetector(
                onTap: () => setState(() => selectedSize = s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? ink : paper,
                    border: Border.all(color: isSelected ? ink : line),
                  ),
                  child: Text(
                    s,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.white : ink,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],

        // Colors Selector
        if (p.colors.isNotEmpty) ...[
          const SizedBox(height: 14),
          const Text(
            'اختر اللون:',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ink, fontFamily: 'Cairo'),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: p.colors.map((color) {
              final isSelected = selectedColor == color;
              return GestureDetector(
                onTap: () => setState(() => selectedColor = color),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? ink : paper,
                    border: Border.all(color: isSelected ? ink : line),
                  ),
                  child: Text(
                    color,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.white : ink,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
