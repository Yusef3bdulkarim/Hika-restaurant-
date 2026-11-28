import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import 'not_found_page.dart';
import 'placeholder_page.dart';

/// Called once by `App`, which owns and disposes the router.
GoRouter createRouter() => GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.homeName,
      builder: (context, state) => const PlaceholderPage(),
    ),
  ],
  errorBuilder: (context, state) => const NotFoundPage(),
);
