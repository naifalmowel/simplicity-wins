import 'package:flutter/material.dart';
import '../models/store_settings.dart';
import '../theme/app_theme.dart';

class StoreStatusBanner extends StatelessWidget {
  final StoreSettings settings;

  const StoreStatusBanner({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    if (settings.isClosed) {
      return Container(
        width: double.infinity,
        color: const Color(0xFFC0392B),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.storefront_outlined, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'المحل مغلق حالياً - يستأنف استقبال الزوار وساعات العمل: ${settings.openingHours}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (settings.isBusy) {
      return Container(
        width: double.infinity,
        color: olive,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.access_time_filled_outlined, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'المحل يشهد أوقات ذروة حالياً - قد يستغرق الرد عبر الواتساب بضع دقائق إضافية',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
