import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Every Hika icon (source: design `M1-Icons`). Each has a Regular and a Fill file.
enum HikaIcons {
  addressHome('address_home'),
  back('back', directional: true),
  bell('bell'),
  branch('branch'),
  calendar('calendar'),
  camera('camera'),
  cart('cart'),
  cash('cash'),
  chat('chat'),
  chevronDown('chevron_down'),
  clear('clear'),
  clock('clock'),
  close('close'),
  copy('copy'),
  delivery('delivery'),
  discountTag('discount_tag'),
  edit('edit'),
  envelope('envelope'),
  error('error'),
  eye('eye'),
  eyeOff('eye_off'),
  gallery('gallery'),
  gift('gift'),
  heart('heart'),
  help('help'),
  home('home'),
  info('info'),
  lock('lock'),
  logout('logout', directional: true),
  menu('menu'),
  minus('minus'),
  mobileWallet('mobile_wallet'),
  moon('moon'),
  more('more'),
  myLocation('my_location'),
  offers('offers'),
  offline('offline'),
  orderBag('order_bag'),
  orders('orders'),
  oven('oven'),
  phone('phone'),
  pin('pin'),
  plus('plus'),
  points('points'),
  profile('profile'),
  receipt('receipt'),
  refresh('refresh'),
  search('search'),
  seeAll('see_all', directional: true),
  settings('settings'),
  star('star'),
  success('success'),
  tier('tier'),
  transfer('transfer'),
  trash('trash'),
  upload('upload'),
  wallet('wallet'),
  warning('warning'),
  work('work');

  const HikaIcons(this._file, {this.directional = false});

  final String _file;

  /// Points a way (back, see all, logout). Drawn for RTL, mirrored in LTR.
  final bool directional;

  String get regularAsset => 'assets/icons/ic_$_file.svg';
  String get fillAsset => 'assets/icons/ic_${_file}_fill.svg';
}

/// Draws a [HikaIcons] tinted with [color], or the `IconTheme` color.
/// Decorative unless [semanticLabel] is given.
class HikaIcon extends StatelessWidget {
  const HikaIcon(
    this.icon, {
    this.filled = false,
    this.size = 24,
    this.color,
    this.semanticLabel,
    super.key,
  });

  final HikaIcons icon;
  final bool filled;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? IconTheme.of(context).color!;
    final picture = SvgPicture.asset(
      filled ? icon.fillAsset : icon.regularAsset,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
    final mirror =
        icon.directional && Directionality.of(context) == TextDirection.ltr;
    return mirror ? Transform.flip(flipX: true, child: picture) : picture;
  }
}
