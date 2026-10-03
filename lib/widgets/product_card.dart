import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import 'app_image.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;

  String _formatPrice(double n) => '${(n / 1000).round()} ألف ل.س';

  void _showQuickSizePicker(BuildContext context, CartService cartService, Product product) {
    String selectedSize = product.sizes.isNotEmpty ? product.sizes.first : 'M';
    String selectedColor = product.colors.isNotEmpty ? product.colors.first : 'أسود';

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختر المقاس المطلوب لـ ${product.nameAr}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ink, fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 16),
              const Text('المقاس:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ink, fontFamily: 'Cairo')),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: product.sizes.map((s) {
                  final isSelected = selectedSize == s;
                  return InkWell(
                    onTap: () => setModalState(() => selectedSize = s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? ink : paper,
                        border: Border.all(color: isSelected ? ink : line),
                      ),
                      child: Text(
                        s,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : ink,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    cartService.addItem(
                      product: product,
                      size: selectedSize,
                      color: selectedColor,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تمت إضافة ${product.nameAr} (مقاس $selectedSize) إلى السلة ✨', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12)),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: ink,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: const Text('إضافة إلى السلة', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final mobile = MediaQuery.sizeOf(context).width < 720;
    final primaryImage = product.image;
    final secondaryImage = product.gallery.length > 1 ? product.gallery[1] : primaryImage;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Hero(
                      tag: product.id,
                      child: AnimatedScale(
                        scale: _isHovered ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 250),
                          crossFadeState: _isHovered && product.gallery.length > 1
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: AppImage(imageUrl: primaryImage, fit: BoxFit.cover),
                          secondChild: AppImage(imageUrl: secondaryImage, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),

                  // Out of Stock Overlay or Badge Chips
                  if (!product.isAvailable)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.35),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            color: paper.withValues(alpha: 0.95),
                            child: const Text(
                              'نفذت الكمية',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ink,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  else if (product.badge != null && product.badge!.isNotEmpty)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        color: paper.withValues(alpha: .95),
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        child: Text(
                          product.badge!,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: ink,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),

                  // Quick Action Buttons on Image Overlay
                  if (product.isAvailable) ...[
                    // Left Arrow Details Button
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _isHovered ? ink : paper.withValues(alpha: .95),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.arrowUpRightFromSquare,
                            size: 11,
                            color: _isHovered ? Colors.white : ink,
                          ),
                        ),
                      ),
                    ),

                    // Exterior Quick Add or Quantity Counter (`- [qty] +`)
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Consumer<CartService>(
                        builder: (context, cartService, child) {
                          final matchingCartItems = cartService.items.where((item) => item.product.id == product.id).toList();
                          final totalQty = matchingCartItems.fold(0, (sum, item) => sum + item.quantity);

                          if (totalQty > 0) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: ink,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (matchingCartItems.isNotEmpty) {
                                        cartService.updateQuantity(matchingCartItems.first.id, -1);
                                      }
                                    },
                                    child: const FaIcon(FontAwesomeIcons.minus, size: 10, color: Colors.white),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      '$totalQty',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Cairo'),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (matchingCartItems.isNotEmpty) {
                                        cartService.updateQuantity(matchingCartItems.first.id, 1);
                                      }
                                    },
                                    child: const FaIcon(FontAwesomeIcons.plus, size: 10, color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          }

                          return InkWell(
                            onTap: () {
                              if (product.sizes.isNotEmpty) {
                                _showQuickSizePicker(context, cartService, product);
                              } else {
                                cartService.addItem(product: product, size: 'M', color: 'أسود');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'تمت إضافة ${product.nameAr} إلى السلة ✨',
                                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
                                    ),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                              decoration: BoxDecoration(
                                color: ink.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(FontAwesomeIcons.cartPlus, size: 11, color: Colors.white),
                                  SizedBox(width: 5),
                                  Text(
                                    'إضافة',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 11),
            Text(
              product.nameAr,
              style: TextStyle(
                fontSize: mobile ? 12 : 14,
                fontWeight: FontWeight.w600,
                color: ink,
                fontFamily: 'Cairo',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Text(
                  _formatPrice(product.price),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ink),
                ),
                if (product.oldPrice != null) ...[
                  const SizedBox(width: 7),
                  Text(
                    _formatPrice(product.oldPrice!),
                    style: const TextStyle(
                      fontSize: 10,
                      color: muted,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
