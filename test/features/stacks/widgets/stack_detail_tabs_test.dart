import 'package:dockge_dashboard/features/stacks/views/stack_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';

void main() {
  testWidgets('switches detail content with FTabs without nested navigation', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FTheme(
          data: FThemes.neutral.light.touch,
          child: const Scaffold(
            body: StackDetailTabs(
              services: Text('services content'),
              terminal: Text('terminal content'),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(FTabs), findsOneWidget);
    expect(find.text('Services'), findsOneWidget);
    expect(find.text('Terminal'), findsOneWidget);
    expect(find.text('services content'), findsOneWidget);
    expect(find.text('terminal content'), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is FHeader), findsNothing);
    expect(find.byType(FBottomNavigationBar), findsNothing);

    await tester.tap(find.text('Terminal'));
    await tester.pumpAndSettle();

    expect(find.text('services content'), findsNothing);
    expect(find.text('terminal content'), findsOneWidget);

    final tabs = find.byType(FTabs);
    final terminalSurface = find.byKey(const Key('stack-terminal-surface'));
    final clip = tester.widget<ClipRRect>(terminalSurface);

    expect(tester.getSize(terminalSurface).width, tester.getSize(tabs).width);
    expect(tester.getTopLeft(tabs).dx, 16);
    expect(tester.getTopRight(tabs).dx, 784);
    expect(clip.borderRadius, BorderRadius.circular(20));
    expect(
      tester.getBottomRight(tabs).dy - tester.getBottomRight(terminalSurface).dy,
      16,
    );
  });
}
