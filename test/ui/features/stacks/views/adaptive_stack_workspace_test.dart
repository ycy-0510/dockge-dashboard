import 'package:dockge_dashboard/ui/features/stacks/views/adaptive_stack_workspace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpWorkspace(WidgetTester tester, double width) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size(width, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AdaptiveStackWorkspace(
            compact: Text('compact'),
            catalogHeader: ColoredBox(
              key: Key('catalog-header'),
              color: Colors.transparent,
              child: Text('catalog header'),
            ),
            catalog: ColoredBox(
              key: Key('catalog-content'),
              color: Colors.transparent,
              child: Text('catalog'),
            ),
            detailHeader: ColoredBox(
              key: Key('detail-header'),
              color: Colors.transparent,
              child: Text('detail header'),
            ),
            detail: ColoredBox(
              key: Key('detail-content'),
              color: Colors.transparent,
              child: Text('detail'),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('uses push-navigation content on compact widths', (tester) async {
    await pumpWorkspace(tester, stackWorkspaceTwoPaneMinWidth - 1);

    expect(find.text('compact'), findsOneWidget);
    expect(find.text('catalog header'), findsNothing);
    expect(find.text('catalog'), findsNothing);
    expect(find.text('detail header'), findsNothing);
    expect(find.text('detail'), findsNothing);
  });

  testWidgets('splits the header and content into matching panes', (tester) async {
    await pumpWorkspace(tester, stackWorkspaceTwoPaneMinWidth);

    expect(find.text('compact'), findsNothing);
    expect(find.text('catalog header'), findsOneWidget);
    expect(find.text('catalog'), findsOneWidget);
    expect(find.text('detail header'), findsOneWidget);
    expect(find.text('detail'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('catalog-header'))).width,
      stackWorkspaceCatalogWidth,
    );
    expect(
      tester.getSize(find.byKey(const Key('catalog-header'))).width,
      tester.getSize(find.byKey(const Key('catalog-content'))).width,
    );
    expect(
      tester.getSize(find.byKey(const Key('detail-header'))).width,
      tester.getSize(find.byKey(const Key('detail-content'))).width,
    );
  });

  testWidgets('keeps the tabbed detail layout on landscape widths', (tester) async {
    await pumpWorkspace(tester, 1180);

    expect(find.text('compact'), findsNothing);
    expect(find.text('catalog header'), findsOneWidget);
    expect(find.text('catalog'), findsOneWidget);
    expect(find.text('detail header'), findsOneWidget);
    expect(find.text('detail'), findsOneWidget);
  });
}
