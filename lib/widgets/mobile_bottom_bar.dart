import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';

class MobileBottomBar extends StatelessWidget {
  final VoidCallback onHome;
  final VoidCallback onOffers;
  final VoidCallback onCatalog;
  final VoidCallback onContact;

  const MobileBottomBar({
    super.key,
    required this.onHome,
    required this.onOffers,
    required this.onCatalog,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: ink.withValues(alpha: 0.96),
              border: Border.all(color: Colors.white12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _barItem(FontAwesomeIcons.house, 'الرئيسية', onHome),
                _barItem(FontAwesomeIcons.tag, 'العروض', onOffers),
                _barItem(FontAwesomeIcons.borderAll, 'المنتجات', onCatalog),
                _barItem(FontAwesomeIcons.headset, 'تواصل', onContact),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _barItem(dynamic icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 17, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
