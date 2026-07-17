import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Applies a theme-aware shimmer to placeholder content while data is loading.
class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({
    required this.enabled,
    required this.child,
    this.label = 'Loading content',
    super.key,
  });

  final bool enabled;
  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final content = Skeletonizer(
      enabled: enabled,
      effect: ShimmerEffect(
        baseColor: colors.surfaceContainerHighest,
        highlightColor: colors.surface,
        duration: const Duration(milliseconds: 1100),
      ),
      ignorePointers: true,
      child: child,
    );

    if (!enabled) return content;

    return Semantics(
      key: const Key('loading-skeleton'),
      container: true,
      liveRegion: true,
      label: label,
      child: ExcludeSemantics(child: content),
    );
  }
}
