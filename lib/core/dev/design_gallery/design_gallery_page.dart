import 'package:flutter/material.dart';

import '../../theme/hika_spacing.dart';
import 'token_sections.dart';

/// Dev-only page that shows every token and component with all its states.
/// Each design-system task adds its section here. Text is plain English:
/// this page never ships in prod.
class DesignGalleryPage extends StatelessWidget {
  const DesignGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design gallery')),
      body: ListView(
        padding: const EdgeInsets.all(HikaSpacing.screenMargin),
        children: const [
          ColorsSection(),
          TypeSection(),
          SpacingSection(),
          RadiiSection(),
          ShadowsSection(),
        ],
      ),
    );
  }
}
