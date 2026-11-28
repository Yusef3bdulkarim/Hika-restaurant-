import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/theme_context.dart';

/// Parts of the logo, one color each (vectorized from the design's masks).
enum HikaLogoVariant {
  /// Rings + word: splash, welcome.
  full,

  /// Rings only: the stamp's outline.
  rings,

  /// Word only: inside the stamp.
  word;

  String get asset => 'assets/logo/logo_$name.svg';
}

/// The Hika logo in one color, `primary` by default. The height follows the
/// variant's aspect ratio. Decorative unless [semanticLabel] is given.
class HikaLogo extends StatelessWidget {
  const HikaLogo({
    required this.width,
    this.variant = HikaLogoVariant.full,
    this.color,
    this.semanticLabel,
    super.key,
  });

  final double width;
  final HikaLogoVariant variant;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      variant.asset,
      width: width,
      colorFilter: ColorFilter.mode(
        color ?? context.colors.primary,
        BlendMode.srcIn,
      ),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}
