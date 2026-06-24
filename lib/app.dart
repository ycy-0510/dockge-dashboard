import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:dockge_dashboard/core/providers/error_notifier.dart';
import 'package:dockge_dashboard/routing/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

class Application extends ConsumerWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(dockgeClientProvider);
    final theme = MediaQuery.of(context).platformBrightness == .light
        ? const <TargetPlatform>{.android, .iOS, .fuchsia}.contains(defaultTargetPlatform)
              ? FThemes.neutral.light.touch
              : FThemes.neutral.light.desktop
        : const <TargetPlatform>{.android, .iOS, .fuchsia}.contains(defaultTargetPlatform)
        ? FThemes.neutral.dark.touch
        : FThemes.neutral.dark.desktop;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // TODO: replace with your application's supported locales.
      supportedLocales: FLocalizations.supportedLocales,
      // TODO: add your application's localizations delegates.
      localizationsDelegates: const [...FLocalizations.localizationsDelegates],
      // MaterialApp's theme is also animated by default with the same duration and curve.
      // See https://api.flutter.dev/flutter/material/MaterialApp/themeAnimationStyle.html for how to configure this.
      //
      // There is a known issue with implicitly animated widgets where their transition occurs AFTER the theme's.
      // See https://github.com/duobaseio/forui/issues/670.
      theme: theme.toApproximateMaterialTheme(),
      builder: (_, child) => FTheme(
        data: theme,
        child: FToaster(
          child: FTooltipGroup(child: _ErrorListener(child: child!)),
        ),
      ),
      // You can also replace FScaffold with Material Scaffold.
      routerConfig: ref.watch(routerProvider),
    );
  }
}

class _ErrorListener extends ConsumerWidget {
  final Widget child;
  const _ErrorListener({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(errorProvider, (prev, next) {
      if (next != null) {
        showFToast(
          context: context,
          icon: Icon(FLucideIcons.circleAlert),
          title: Text("Error"),
          description: Text(next.message),
        );
      }
    });
    return child;
  }
}
