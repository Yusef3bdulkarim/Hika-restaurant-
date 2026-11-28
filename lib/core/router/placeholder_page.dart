import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

/// Temporary start screen until E2 adds splash and the tab shell.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(AppLocalizations.of(context).appTitle)),
    );
  }
}
