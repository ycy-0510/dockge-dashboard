import 'package:dockge_dashboard/app/core/network/dockge_client.dart';
import 'package:dockge_dashboard/features/auth/models/auth_view_model.dart';
import 'package:dockge_dashboard/features/auth/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';

void main() {
  Future<void> pumpLogin(
    WidgetTester tester, {
    required Size size,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWithValue(
            const AuthState(loginStatus: LoginStatus.unauthenticated),
          ),
          dockgeClientProvider.overrideWithValue(
            const DockgeClientState(
              endpoint: null,
              status: SocketStatus.disconnected,
            ),
          ),
        ],
        child: MaterialApp(
          supportedLocales: FLocalizations.supportedLocales,
          localizationsDelegates: const [
            ...FLocalizations.localizationsDelegates,
          ],
          home: FTheme(
            data: FThemes.neutral.light.touch,
            child: const LoginPage(),
          ),
        ),
      ),
    );
  }

  testWidgets('limits the form width on iPad landscape', (tester) async {
    await pumpLogin(tester, size: const Size(1180, 820));

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byKey(const Key('login-form-content'))).width,
      loginFormMaxWidth,
    );
  });

  testWidgets('uses the available width on compact screens', (tester) async {
    await pumpLogin(tester, size: const Size(390, 844));

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byKey(const Key('login-form-content'))).width,
      390 - 48,
    );
  });

  testWidgets('remains scrollable while typing with the landscape keyboard', (
    tester,
  ) async {
    await pumpLogin(tester, size: const Size(1180, 820));
    addTearDown(tester.view.resetViewInsets);

    final username = find.byType(EditableText).at(1);
    await tester.tap(username);
    await tester.pump();

    tester.view.viewInsets = const FakeViewPadding(bottom: 420);
    await tester.pump();
    await tester.enterText(username, 'a-long-ipad-landscape-username');
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.testTextInput.isVisible, isTrue);
  });
}
