import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Every Hika illustration (source: design `M1-Illustrations`).
/// Colors are baked in from the tokens, so they are never tinted.
enum HikaIllustrations {
  emptyCart('empty_cart'),
  noOrders('no_orders'),
  noNotifications('no_notifications'),
  noOffers('no_offers'),
  noAddresses('no_addresses'),
  emptyFavorites('empty_favorites'),
  noSearchResults('no_search_results'),
  offline('offline'),
  serverError('server_error'),
  maintenance('maintenance'),
  appUpdate('app_update'),
  linkSent('link_sent'),
  locationPermission('location_permission'),
  notificationPermission('notification_permission'),
  restaurantClosed('restaurant_closed');

  const HikaIllustrations(this._file);

  final String _file;

  String get asset => 'assets/illustrations/ill_$_file.svg';
}

/// The two sizes in the design.
enum HikaIllustrationSize {
  /// Empty-state template inside a screen.
  inline(120),

  /// Full-screen states (offline, error, maintenance).
  screen(140);

  const HikaIllustrationSize(this.dimension);

  final double dimension;
}

/// Always shown above a title that carries the meaning, so it is decorative.
class HikaIllustration extends StatelessWidget {
  const HikaIllustration(
    this.illustration, {
    this.size = HikaIllustrationSize.screen,
    super.key,
  });

  final HikaIllustrations illustration;
  final HikaIllustrationSize size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      illustration.asset,
      width: size.dimension,
      height: size.dimension,
      excludeFromSemantics: true,
    );
  }
}
