import 'package:flutter/material.dart';

import '../../theme/hika_spacing.dart';
import '../../theme/theme_context.dart';
import '../../widgets/hika_icon.dart';
import '../../widgets/hika_illustration.dart';
import '../../widgets/hika_logo.dart';
import 'gallery_section.dart';

/// Logo variants at the stamp size (168), in primary and positive.
class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  static const _width = 168.0;

  @override
  Widget build(BuildContext context) {
    return GallerySection(
      title: 'Logo',
      child: Wrap(
        spacing: HikaSpacing.lg,
        runSpacing: HikaSpacing.lg,
        children: [
          for (final variant in HikaLogoVariant.values)
            HikaLogo(width: _width, variant: variant),
          HikaLogo(
            width: _width,
            variant: HikaLogoVariant.rings,
            color: context.colors.positive,
          ),
        ],
      ),
    );
  }
}

/// Every illustration at the inline size (120).
class IllustrationsSection extends StatelessWidget {
  const IllustrationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GallerySection(
      title: 'Illustrations',
      child: Wrap(
        spacing: HikaSpacing.md,
        runSpacing: HikaSpacing.md,
        children: [
          for (final illustration in HikaIllustrations.values)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HikaIllustration(
                  illustration,
                  size: HikaIllustrationSize.inline,
                ),
                Text(
                  illustration.name,
                  style: context.textStyles.micro.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

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
