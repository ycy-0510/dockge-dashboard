import 'package:dockge_dashboard/features/dashboard/models/network_topology.dart';
import 'package:dockge_dashboard/features/dashboard/models/network_topology_view_model.dart';
import 'package:dockge_dashboard/features/dashboard/views/dashboard_page.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_catalog_view_model.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';

void main() {
  Widget buildCatalog(StackCatalog? catalog) => ProviderScope(
    overrides: [stackCatalogViewModelProvider.overrideWithValue(catalog)],
    child: MaterialApp(
      home: FTheme(
        data: FThemes.neutral.light.touch,
        child: const Scaffold(body: StackCatalogView()),
      ),
    ),
  );

  testWidgets('shows a shimmer skeleton while the stack catalog loads', (tester) async {
    await tester.pumpWidget(buildCatalog(null));

    expect(find.byKey(const Key('loading-skeleton')), findsOneWidget);
    expect(find.text('Primary services'), findsOneWidget);
    expect(find.text('No stacks found'), findsNothing);
  });

  testWidgets('shows stack content without a skeleton after loading', (tester) async {
    await tester.pumpWidget(
      buildCatalog(
        StackCatalog(
          isSuccessful: true,
          stacks: const [
            StackSummary(
              name: 'Production',
              status: .active,
              isManagedByDockge: true,
              composeFileName: 'compose.yaml',
            ),
          ],
        ),
      ),
    );

    expect(find.byKey(const Key('loading-skeleton')), findsNothing);
    expect(find.text('Production'), findsOneWidget);
  });

  testWidgets('shows shimmer cards while overview metrics load', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stackCatalogViewModelProvider.overrideWithValue(null),
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
            child: const Scaffold(body: DashboardOverview()),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('loading-skeleton')), findsOneWidget);
    expect(find.text('Stacks'), findsOneWidget);
  });
}
