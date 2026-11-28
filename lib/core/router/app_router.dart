import 'package:go_router/go_router.dart';

import '../config/flavor.dart';
import '../dev/design_gallery/design_gallery_page.dart';
import 'app_routes.dart';
import 'not_found_page.dart';
import 'placeholder_page.dart';

/// Called once by `App`, which owns and disposes the router.
/// Dev opens on the design gallery until E2 adds the splash; prod has no gallery route.
GoRouter createRouter({required Flavor flavor}) {
  final isDev = flavor == Flavor.dev;
  return GoRouter(
    initialLocation: isDev ? AppRoutes.devGallery : AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) => const PlaceholderPage(),
      ),
      if (isDev)
        GoRoute(
          path: AppRoutes.devGallery,
          name: AppRoutes.devGalleryName,
          builder: (context, state) => const DesignGalleryPage(),
        ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
