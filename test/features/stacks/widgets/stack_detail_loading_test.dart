import 'package:dockge_dashboard/features/stacks/models/stack_details_view_model.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_terminal_view_model.dart';
import 'package:dockge_dashboard/features/stacks/views/stack_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';

void main() {
  testWidgets('shows stack-shaped shimmer content while details load', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stackDetailsViewModelProvider.overrideWithValue(
            const StackDetailsViewState(isLoading: true),
          ),
          stackTerminalViewModelProvider.overrideWithValue(null),
        ],
        child: MaterialApp(
          home: FTheme(
            data: FThemes.neutral.light.touch,
            child: const Scaffold(body: StackDetailServices()),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('loading-skeleton')), findsOneWidget);
    expect(find.text('Loading stack'), findsOneWidget);
    expect(find.text('Application service'), findsOneWidget);
    expect(find.byType(FCircularProgress), findsNothing);
  });
}
