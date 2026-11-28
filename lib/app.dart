import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/config/flavor.dart';
import 'core/l10n/generated/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/hika_theme.dart';

class App extends StatefulWidget {
  const App({required this.flavor, super.key});

  final Flavor flavor;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router = createRouter(flavor: widget.flavor);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: HikaTheme.light(),
      routerConfig: _router,
    );
  }
}
