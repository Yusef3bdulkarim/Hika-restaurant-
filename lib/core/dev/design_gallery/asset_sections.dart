import 'package:flutter/material.dart';

import '../../theme/hika_spacing.dart';
import '../../theme/theme_context.dart';
import '../../widgets/hika_icon.dart';
import 'gallery_section.dart';

/// Every icon: Regular in textPrimary, Fill in primary (as in M1-Icons).
class IconsSection extends StatelessWidget {
  const IconsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GallerySection(
      title: 'Icons',
      child: Wrap(
        spacing: HikaSpacing.sm,
        runSpacing: HikaSpacing.md,
        children: [for (final icon in HikaIcons.values) _IconTile(icon)],
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile(this.icon);

  final HikaIcons icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2 * HikaSpacing.xxxl,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HikaIcon(icon, color: context.colors.textPrimary),
              const SizedBox(width: HikaSpacing.xs),
              HikaIcon(icon, filled: true, color: context.colors.primary),
            ],
          ),
          const SizedBox(height: HikaSpacing.xs),
          Text(
            icon.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.micro.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
