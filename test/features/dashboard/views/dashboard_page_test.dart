import 'package:dockge_dashboard/features/dashboard/models/network_topology.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';
import 'package:dockge_dashboard/features/auth/models/auth_view_model.dart';
import 'package:dockge_dashboard/features/dashboard/models/network_topology_view_model.dart';
import 'package:dockge_dashboard/features/dashboard/views/dashboard_page.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_catalog_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';

void main() {
  testWidgets('opens the split stack header popover after changing tabs', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1180, 820);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWithValue(
            const AuthState(
              loginStatus: LoginStatus.authenticated,
              username: 'tester',
            ),
          ),
          stackCatalogViewModelProvider.overrideWithValue(
            StackCatalog(isSuccessful: true, stacks: const []),
          ),
          networkTopologyViewModelProvider.overrideWithValue(
            const NetworkTopology.empty(),
          ),
          overviewMetricsProvider.overrideWithValue(
            const OverviewMetrics(
              stacks: 0,
              active: 0,
              exited: 0,
              inactive: 0,
              services: 0,
              ports: 0,
            ),
          ),
        ],
        child: MaterialApp(
          home: FTheme(
            data: FThemes.neutral.light.touch,
            child: const DashboardPage(),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Home'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(FBottomNavigationBar),
        matching: find.text('Stacks'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(FLucideIcons.plus));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('New Stack'), findsOneWidget);
    expect(find.text('Convert from docker run'), findsOneWidget);
  });
}
