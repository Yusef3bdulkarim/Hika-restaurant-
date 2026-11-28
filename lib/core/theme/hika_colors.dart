import 'package:flutter/material.dart';

/// Every color allowed in the app (source: design `M1-Colors`).
/// Read with `context.colors`. Any color not here is not allowed.
@immutable
class HikaColors extends ThemeExtension<HikaColors> {
  const HikaColors({
    required this.primary,
    required this.primaryPressed,
    required this.primaryDeep,
    required this.primaryTint,
    required this.positive,
    required this.positiveDeep,
    required this.positiveTint,
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.border,
    required this.borderStrong,
    required this.borderInput,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.onPrimary,
    required this.scrim,
    required this.successFg,
    required this.successBg,
    required this.infoFg,
    required this.infoBg,
    required this.warningFg,
    required this.warningIcon,
    required this.warningBg,
    required this.errorFg,
    required this.errorBg,
    required this.star,
    required this.tierBronze,
    required this.tierBronzeTint,
    required this.tierSilver,
    required this.tierSilverTint,
    required this.tierGold,
    required this.tierGoldTint,
  });

  static const light = HikaColors(
    primary: Color(0xFF8E1B25),
    primaryPressed: Color(0xFF74161E),
    primaryDeep: Color(0xFF5C1118),
    primaryTint: Color(0xFFF7E9EA),
    positive: Color(0xFF2E7D4F),
    positiveDeep: Color(0xFF1F4D36),
    positiveTint: Color(0xFFE9F2EC),
    background: Color(0xFFFAF6F0),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF3EDE5),
    border: Color(0xFFE8E0D6),
    borderStrong: Color(0xFFCFC4B8),
    borderInput: Color(0xFF8F8378),
    textPrimary: Color(0xFF2B2523),
    textSecondary: Color(0xFF6B5F58),
    textDisabled: Color(0xFFA69B92),
    onPrimary: Color(0xFFFFFFFF),
    scrim: Color(0x802B2523),
    successFg: Color(0xFF1F4D36),
    successBg: Color(0xFFE9F2EC),
    infoFg: Color(0xFF1A5FD0),
    infoBg: Color(0xFFE8F0FE),
    warningFg: Color(0xFF8A4B00),
    warningIcon: Color(0xFFE08A00),
    warningBg: Color(0xFFFFF1DC),
    errorFg: Color(0xFFC4161C),
    errorBg: Color(0xFFFDECEC),
    star: Color(0xFFF2A900),
    tierBronze: Color(0xFF8C5A3C),
    tierBronzeTint: Color(0xFFF5E8DF),
    tierSilver: Color(0xFF5F6670),
    tierSilverTint: Color(0xFFEDEEF0),
    tierGold: Color(0xFF7F5700),
    tierGoldTint: Color(0xFFFFF4D6),
  );

  // Brand. Green = customer gain only (discount, balance, free delivery, done).
  final Color primary;
  final Color primaryPressed;
  final Color primaryDeep;
  final Color primaryTint;
  final Color positive;
  final Color positiveDeep;
  final Color positiveTint;

  // Warm neutrals.
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color border;
  final Color borderStrong;

  /// Input, checkbox and radio borders only.
  final Color borderInput;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color onPrimary;

  /// Behind sheets and dialogs: textPrimary at 50 %.
  final Color scrim;

  // Status: Fg = text / icon on its Bg. Blue (info) = waiting only.
  final Color successFg;
  final Color successBg;
  final Color infoFg;
  final Color infoBg;
  final Color warningFg;
  final Color warningIcon;
  final Color warningBg;
  final Color errorFg;
  final Color errorBg;
  final Color star;

  // Loyalty tiers: text color / background. Gold progress bar uses [star].
  final Color tierBronze;
  final Color tierBronzeTint;
  final Color tierSilver;
  final Color tierSilverTint;
  final Color tierGold;
  final Color tierGoldTint;

  @override
  HikaColors copyWith({
    Color? primary,
    Color? primaryPressed,
    Color? primaryDeep,
    Color? primaryTint,
    Color? positive,
    Color? positiveDeep,
    Color? positiveTint,
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? border,
    Color? borderStrong,
    Color? borderInput,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? onPrimary,
    Color? scrim,
    Color? successFg,
    Color? successBg,
    Color? infoFg,
    Color? infoBg,
    Color? warningFg,
    Color? warningIcon,
    Color? warningBg,
    Color? errorFg,
    Color? errorBg,
    Color? star,
    Color? tierBronze,
    Color? tierBronzeTint,
    Color? tierSilver,
    Color? tierSilverTint,
    Color? tierGold,
    Color? tierGoldTint,
  }) => HikaColors(
    primary: primary ?? this.primary,
    primaryPressed: primaryPressed ?? this.primaryPressed,
    primaryDeep: primaryDeep ?? this.primaryDeep,
    primaryTint: primaryTint ?? this.primaryTint,
    positive: positive ?? this.positive,
    positiveDeep: positiveDeep ?? this.positiveDeep,
    positiveTint: positiveTint ?? this.positiveTint,
    background: background ?? this.background,
    surface: surface ?? this.surface,
    surfaceMuted: surfaceMuted ?? this.surfaceMuted,
    border: border ?? this.border,
    borderStrong: borderStrong ?? this.borderStrong,
    borderInput: borderInput ?? this.borderInput,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textDisabled: textDisabled ?? this.textDisabled,
    onPrimary: onPrimary ?? this.onPrimary,
    scrim: scrim ?? this.scrim,
    successFg: successFg ?? this.successFg,
    successBg: successBg ?? this.successBg,
    infoFg: infoFg ?? this.infoFg,
    infoBg: infoBg ?? this.infoBg,
    warningFg: warningFg ?? this.warningFg,
    warningIcon: warningIcon ?? this.warningIcon,
    warningBg: warningBg ?? this.warningBg,
    errorFg: errorFg ?? this.errorFg,
    errorBg: errorBg ?? this.errorBg,
    star: star ?? this.star,
    tierBronze: tierBronze ?? this.tierBronze,
    tierBronzeTint: tierBronzeTint ?? this.tierBronzeTint,
    tierSilver: tierSilver ?? this.tierSilver,
    tierSilverTint: tierSilverTint ?? this.tierSilverTint,
    tierGold: tierGold ?? this.tierGold,
    tierGoldTint: tierGoldTint ?? this.tierGoldTint,
  );

  @override
  HikaColors lerp(HikaColors? other, double t) {
    if (other is! HikaColors) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return HikaColors(
      primary: mix(primary, other.primary),
      primaryPressed: mix(primaryPressed, other.primaryPressed),
      primaryDeep: mix(primaryDeep, other.primaryDeep),
      primaryTint: mix(primaryTint, other.primaryTint),
      positive: mix(positive, other.positive),
      positiveDeep: mix(positiveDeep, other.positiveDeep),
      positiveTint: mix(positiveTint, other.positiveTint),
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      surfaceMuted: mix(surfaceMuted, other.surfaceMuted),
      border: mix(border, other.border),
      borderStrong: mix(borderStrong, other.borderStrong),
      borderInput: mix(borderInput, other.borderInput),
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      textDisabled: mix(textDisabled, other.textDisabled),
      onPrimary: mix(onPrimary, other.onPrimary),
      scrim: mix(scrim, other.scrim),
      successFg: mix(successFg, other.successFg),
      successBg: mix(successBg, other.successBg),
      infoFg: mix(infoFg, other.infoFg),
      infoBg: mix(infoBg, other.infoBg),
      warningFg: mix(warningFg, other.warningFg),
      warningIcon: mix(warningIcon, other.warningIcon),
      warningBg: mix(warningBg, other.warningBg),
      errorFg: mix(errorFg, other.errorFg),
      errorBg: mix(errorBg, other.errorBg),
      star: mix(star, other.star),
      tierBronze: mix(tierBronze, other.tierBronze),
      tierBronzeTint: mix(tierBronzeTint, other.tierBronzeTint),
      tierSilver: mix(tierSilver, other.tierSilver),
      tierSilverTint: mix(tierSilverTint, other.tierSilverTint),
      tierGold: mix(tierGold, other.tierGold),
      tierGoldTint: mix(tierGoldTint, other.tierGoldTint),
    );
  }
}
