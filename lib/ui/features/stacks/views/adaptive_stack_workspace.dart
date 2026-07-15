import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

const double stackWorkspaceTwoPaneMinWidth = 700;
const double stackWorkspaceCatalogWidth = 280;

/// Switches the stack workspace between push navigation and a master-detail
/// layout with headers aligned to each pane.
class AdaptiveStackWorkspace extends StatelessWidget {
  const AdaptiveStackWorkspace({
    required this.compact,
    required this.catalogHeader,
    required this.catalog,
    required this.detailHeader,
    required this.detail,
    super.key,
  });

  final Widget compact;
  final Widget catalogHeader;
  final Widget catalog;
  final Widget detailHeader;
  final Widget detail;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < stackWorkspaceTwoPaneMinWidth) {
          return compact;
        }

        return Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: stackWorkspaceCatalogWidth,
                    child: catalogHeader,
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: detailHeader),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(width: stackWorkspaceCatalogWidth, child: catalog),
                  const VerticalDivider(width: 1),
                  Expanded(child: detail),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

@Preview(
  name: 'Stack workspace — iPad portrait',
  group: 'Adaptive stack navigation',
  size: Size(768, 900),
)
Widget stackWorkspacePortraitPreview() => const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Scaffold(
    body: AdaptiveStackWorkspace(
      compact: _PreviewPane(label: 'Catalog'),
      catalogHeader: _PreviewHeader(label: 'Stacks'),
      catalog: _PreviewPane(label: 'Catalog'),
      detailHeader: _PreviewHeader(label: 'Selected stack'),
      detail: _PreviewPane(label: 'Services / Terminal'),
    ),
  ),
);

@Preview(
  name: 'Stack workspace — iPad landscape',
  group: 'Adaptive stack navigation',
  size: Size(1180, 820),
)
Widget stackWorkspaceLandscapePreview() => const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Scaffold(
    body: AdaptiveStackWorkspace(
      compact: _PreviewPane(label: 'Catalog'),
      catalogHeader: _PreviewHeader(label: 'Stacks'),
      catalog: _PreviewPane(label: 'Catalog'),
      detailHeader: _PreviewHeader(label: 'Selected stack'),
      detail: _PreviewPane(label: 'Services / Terminal'),
    ),
  ),
);

class _PreviewHeader extends StatelessWidget {
  const _PreviewHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 64, child: _PreviewPane(label: label));
  }
}

class _PreviewPane extends StatelessWidget {
  const _PreviewPane({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Center(child: Text(label)),
    );
  }
}
