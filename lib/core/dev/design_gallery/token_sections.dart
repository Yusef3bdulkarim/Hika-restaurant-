import 'package:flutter/material.dart';

import '../../theme/hika_colors.dart';
import '../../theme/hika_radii.dart';
import '../../theme/hika_shadows.dart';
import '../../theme/hika_spacing.dart';
import '../../theme/hika_text_styles.dart';
import '../../theme/theme_context.dart';
import 'gallery_section.dart';

class ColorsSection extends StatelessWidget {
  const ColorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GallerySection(
      title: 'Colors',
      child: Column(
        children: [
          for (final (name, color) in _colors(c)) _Swatch(name, color),
        ],
      ),
    );
  }

  static List<(String, Color)> _colors(HikaColors c) => [
    ('primary', c.primary),
    ('primaryPressed', c.primaryPressed),
    ('primaryDeep', c.primaryDeep),
    ('primaryTint', c.primaryTint),
    ('positive', c.positive),
    ('positiveDeep', c.positiveDeep),
    ('positiveTint', c.positiveTint),
    ('background', c.background),
    ('surface', c.surface),
    ('surfaceMuted', c.surfaceMuted),
    ('border', c.border),
    ('borderStrong', c.borderStrong),
    ('borderInput', c.borderInput),
    ('textPrimary', c.textPrimary),
    ('textSecondary', c.textSecondary),
    ('textDisabled', c.textDisabled),
    ('onPrimary', c.onPrimary),
    ('scrim', c.scrim),
    ('successFg', c.successFg),
    ('successBg', c.successBg),
    ('infoFg', c.infoFg),
    ('infoBg', c.infoBg),
    ('warningFg', c.warningFg),
    ('warningIcon', c.warningIcon),
    ('warningBg', c.warningBg),
    ('errorFg', c.errorFg),
    ('errorBg', c.errorBg),
    ('star', c.star),
    ('tierBronze', c.tierBronze),
    ('tierBronzeTint', c.tierBronzeTint),
    ('tierSilver', c.tierSilver),
    ('tierSilverTint', c.tierSilverTint),
    ('tierGold', c.tierGold),
    ('tierGoldTint', c.tierGoldTint),
  ];
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.name, this.color);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final argb = color
        .toARGB32()
        .toRadixString(16)
        .toUpperCase()
        .padLeft(8, '0');
    // Same format as M1-Colors: 6 digits, alpha only when not opaque.
    final hex = argb.startsWith('FF') ? argb.substring(2) : argb;
    return Padding(
      padding: const EdgeInsets.only(bottom: HikaSpacing.sm),
      child: Row(
        children: [
          Container(
            width: HikaSpacing.xxxl,
            height: HikaSpacing.xxl,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: context.colors.border),
              borderRadius: BorderRadius.circular(HikaRadii.sm),
            ),
          ),
          const SizedBox(width: HikaSpacing.md),
          Expanded(child: Text(name, style: context.textStyles.label)),
          Text(
            '#$hex',
            textDirection: TextDirection.ltr,
            style: context.textStyles.caption.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class TypeSection extends StatelessWidget {
  const TypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.textStyles;
    return GallerySection(
      title: 'Type',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (name, style, sample) in _samples(s))
            Padding(
              padding: const EdgeInsets.only(bottom: HikaSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: s.micro.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  Text(sample, style: style),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Design rule: non-breaking space before «ج.م».
  static final _nbsp = String.fromCharCode(0xA0);

  // Sample text from M1-Type.
  static List<(String, TextStyle, String)> _samples(HikaTextStyles s) => [
    ('display', s.display, 'كومبو السهرة'),
    ('h1', s.h1, 'تم تأكيد طلبك'),
    ('h2', s.h2, 'الأكثر طلباً'),
    ('h3', s.h3, 'بيتزا ميكس لحوم'),
    ('title', s.title, 'مساء الخير، أحمد'),
    ('body', s.body, 'عجينة رفيعة، صلصة طماطم، موتزاريلا'),
    ('bodyStrong', s.bodyStrong, 'جارٍ تحضير طلبك'),
    ('label', s.label, 'وصف المكان وأقرب علامة مميزة'),
    ('caption', s.caption, 'تبقّى 5,000$_nbspج.م للوصول إلى المستوى الفضي'),
    ('micro', s.micro, 'الأكثر طلباً'),
    ('price', s.price, '220$_nbspج.م'),
    ('priceLarge', s.priceLarge, '265$_nbspج.م'),
  ];
}

class SpacingSection extends StatelessWidget {
  const SpacingSection({super.key});

  static const _scale = [
    ('xs', HikaSpacing.xs),
    ('sm', HikaSpacing.sm),
    ('md', HikaSpacing.md),
    ('lg', HikaSpacing.lg),
    ('xl', HikaSpacing.xl),
    ('xxl', HikaSpacing.xxl),
    ('xxxl', HikaSpacing.xxxl),
  ];

  @override
  Widget build(BuildContext context) {
    return GallerySection(
      title: 'Spacing',
      child: Wrap(
        spacing: HikaSpacing.lg,
        runSpacing: HikaSpacing.md,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          for (final (name, size) in _scale)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: size,
                  child: ColoredBox(color: context.colors.primary),
                ),
                const SizedBox(height: HikaSpacing.xs),
                Text('$name ${size.toInt()}', style: context.textStyles.micro),
              ],
            ),
        ],
      ),
    );
  }
}

class RadiiSection extends StatelessWidget {
  const RadiiSection({super.key});

  static const _radii = [
    ('sm', HikaRadii.sm),
    ('md', HikaRadii.md),
    ('lg', HikaRadii.lg),
    ('full', HikaRadii.full),
  ];

  @override
  Widget build(BuildContext context) {
    return GallerySection(
      title: 'Radii',
      child: Wrap(
        spacing: HikaSpacing.md,
        runSpacing: HikaSpacing.md,
        children: [
          for (final (name, radius) in _radii)
            Container(
              width: 2 * HikaSpacing.xxxl,
              height: HikaSpacing.xxxl,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.colors.surfaceMuted,
                border: Border.all(color: context.colors.borderStrong),
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Text(name, style: context.textStyles.label),
            ),
        ],
      ),
    );
  }
}

class ShadowsSection extends StatelessWidget {
  const ShadowsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GallerySection(
      title: 'Shadows',
      child: Row(
        children: [
          _shadowBox(context, 'elevation1', HikaShadows.elevation1),
          const SizedBox(width: HikaSpacing.lg),
          _shadowBox(context, 'elevation2', HikaShadows.elevation2),
        ],
      ),
    );
  }

  Widget _shadowBox(BuildContext context, String name, List<BoxShadow> shadow) {
    return Expanded(
      child: Container(
        height: 2 * HikaSpacing.xxxl,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(HikaRadii.md),
          boxShadow: shadow,
        ),
        child: Text(name, style: context.textStyles.label),
      ),
    );
  }
}
