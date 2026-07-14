import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:dockge_dashboard/ui/core/view_models/toast_notifier.dart';
import 'package:dockge_dashboard/routing/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

class DockgeDashboardApp extends ConsumerWidget {
  const DockgeDashboardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(dockgeClientProvider);
    final theme = MediaQuery.of(context).platformBrightness == .light
        ? const <TargetPlatform>{
                .android,
                .iOS,
                .fuchsia,
              }.contains(defaultTargetPlatform)
              ? FThemes.neutral.light.touch
              : FThemes.neutral.light.desktop
        : const <TargetPlatform>{
            .android,
            .iOS,
            .fuchsia,
          }.contains(defaultTargetPlatform)
        ? FThemes.neutral.dark.touch
        : FThemes.neutral.dark.desktop;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: const [...FLocalizations.localizationsDelegates],
      theme: theme.toApproximateMaterialTheme(),
      builder: (_, child) => FTheme(
        data: theme,
        child: FToaster(
          child: FTooltipGroup(
            child: _ToastListener(child: child ?? const SizedBox.shrink()),
          ),
        ),
      ),
      // You can also replace FScaffold with Material Scaffold.
      routerConfig: ref.watch(routerProvider),
    );
  }
}

class _ToastListener extends ConsumerWidget {
  final Widget child;
  const _ToastListener({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(toastProvider, (prev, next) {
      if (next != null) {
        showFToast(
          context: context,
          icon: Icon(next.icon),
          title: Text(next.title),
          description: Text(next.message),
        );
      }
    });
    return child;
  }
}
