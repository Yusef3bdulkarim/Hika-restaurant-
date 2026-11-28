import 'package:flutter/material.dart';

import 'hika_fonts.dart';

/// The type scale (source: design `M1-Type`). Read with `context.textStyles`.
/// Styles carry no color: the color comes from where the text is used.
@immutable
class HikaTextStyles extends ThemeExtension<HikaTextStyles> {
  const HikaTextStyles({
    required this.display,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.title,
    required this.body,
    required this.bodyStrong,
    required this.label,
    required this.caption,
    required this.micro,
    required this.price,
    required this.priceLarge,
  });

  static const standard = HikaTextStyles(
    display: TextStyle(
      fontFamily: HikaFonts.baloo,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 40 / 32,
    ),
    h1: TextStyle(
      fontFamily: HikaFonts.baloo,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 32 / 24,
    ),
    h2: TextStyle(
      fontFamily: HikaFonts.baloo,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 28 / 20,
    ),
    h3: TextStyle(
      fontFamily: HikaFonts.readex,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 26 / 17,
    ),
    title: TextStyle(
      fontFamily: HikaFonts.readex,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 24 / 16,
    ),
    body: TextStyle(
      fontFamily: HikaFonts.readex,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 24 / 15,
    ),
    bodyStrong: TextStyle(
      fontFamily: HikaFonts.readex,
      fontSize: 15,
      fontWeight: FontWeight.w500,
      height: 24 / 15,
    ),
    label: TextStyle(
      fontFamily: HikaFonts.readex,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 20 / 14,
    ),
    caption: TextStyle(
      fontFamily: HikaFonts.readex,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 20 / 13,
    ),
    micro: TextStyle(
      fontFamily: HikaFonts.readex,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
    ),
    price: TextStyle(
      fontFamily: HikaFonts.readex,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 24 / 16,
    ),
    priceLarge: TextStyle(
      fontFamily: HikaFonts.readex,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 28 / 20,
    ),
  );

  /// Big numbers: amount, expected time.
  final TextStyle display;

  /// Screen titles. Baloo headings: two lines max.
  final TextStyle h1;

  /// Block titles.
  final TextStyle h2;

  /// Item name.
  final TextStyle h3;

  /// Row titles.
  final TextStyle title;
  final TextStyle body;
  final TextStyle bodyStrong;

  /// Input labels.
  final TextStyle label;

  /// Secondary details.
  final TextStyle caption;

  /// Badges only.
  final TextStyle micro;
  final TextStyle price;

  /// Totals.
  final TextStyle priceLarge;

  @override
  HikaTextStyles copyWith({
    TextStyle? display,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? title,
    TextStyle? body,
    TextStyle? bodyStrong,
    TextStyle? label,
    TextStyle? caption,
    TextStyle? micro,
    TextStyle? price,
    TextStyle? priceLarge,
  }) => HikaTextStyles(
    display: display ?? this.display,
    h1: h1 ?? this.h1,
    h2: h2 ?? this.h2,
    h3: h3 ?? this.h3,
    title: title ?? this.title,
    body: body ?? this.body,
    bodyStrong: bodyStrong ?? this.bodyStrong,
    label: label ?? this.label,
    caption: caption ?? this.caption,
    micro: micro ?? this.micro,
    price: price ?? this.price,
    priceLarge: priceLarge ?? this.priceLarge,
  );

  @override
  HikaTextStyles lerp(HikaTextStyles? other, double t) {
    if (other is! HikaTextStyles) return this;
    TextStyle mix(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return HikaTextStyles(
      display: mix(display, other.display),
      h1: mix(h1, other.h1),
      h2: mix(h2, other.h2),
      h3: mix(h3, other.h3),
      title: mix(title, other.title),
      body: mix(body, other.body),
      bodyStrong: mix(bodyStrong, other.bodyStrong),
      label: mix(label, other.label),
      caption: mix(caption, other.caption),
      micro: mix(micro, other.micro),
      price: mix(price, other.price),
      priceLarge: mix(priceLarge, other.priceLarge),
    );
  }
}
