import 'package:flutter/material.dart';

import '../../theme/hika_spacing.dart';
import '../../theme/theme_context.dart';

/// A titled block in the design gallery.
class GallerySection extends StatelessWidget {
  const GallerySection({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HikaSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: context.textStyles.h2),
          const SizedBox(height: HikaSpacing.md),
          child,
        ],
      ),
    );
  }
}
