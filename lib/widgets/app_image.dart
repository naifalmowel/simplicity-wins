import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final double? height;
  final double? width;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.color,
    this.colorBlendMode,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        height: height,
        width: width,
        errorBuilder: (context, error, stackTrace) => Container(
          height: height,
          width: width,
          color: const Color(0xFFEFE9D8),
          child: const Center(
            child: Icon(Icons.image, color: Colors.black38),
          ),
        ),
      );
    } else if (kIsWeb) {
      // Fast Native Image.network for Web & Safari WebKit compatibility
      return Image.network(
        imageUrl,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        height: height,
        width: width,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            width: width,
            color: const Color(0xFFF2ECE1),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1A1A1A)),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          height: height,
          width: width,
          color: const Color(0xFFEFE9D8),
          child: const Center(
            child: Icon(Icons.image_not_supported, color: Colors.black38),
          ),
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        height: height,
        width: width,
        placeholder: (context, url) => Container(
          height: height,
          width: width,
          color: const Color(0xFFF2ECE1),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1A1A1A)),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: height,
          width: width,
          color: const Color(0xFFEFE9D8),
          child: const Center(
            child: Icon(Icons.image_not_supported, color: Colors.black38),
          ),
        ),
      );
    }
  }
}
