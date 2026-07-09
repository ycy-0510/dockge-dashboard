import 'package:dockge_dashboard/features/auth/providers/auth_controller.dart';
import 'package:dockge_dashboard/features/auth/screen/login_screen.dart';
import 'package:dockge_dashboard/features/home/screen/home_screen.dart';
import 'package:dockge_dashboard/features/home/screen/stack_detail_screen.dart';
import 'package:dockge_dashboard/features/home/screen/stack_edit_screen.dart';
import 'package:dockge_dashboard/routing/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/widgets.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutePath.login,
    refreshListenable: notifier,
    redirect: (context, state) {
      final status = ref.read(authControllerProvider).loginStatus;
      final isLoginRoute = state.matchedLocation == AppRoutePath.login;

      // When the app launches, the path might be '/' or '/login'.
      // If it's loading, we want to stay on the login route to show the spinner.
      if (status == LoginStatus.loading) {
        if (state.matchedLocation == '/') return AppRoutePath.login;
        return null;
      }
      if (status == LoginStatus.unauthenticated && !isLoginRoute) {
        return AppRoutePath.login;
      }
      if (status == LoginStatus.authenticated && isLoginRoute) {
        return AppRoutePath.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutePath.login,
        name: AppRouteName.login,
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: AppRoutePath.home,
        name: AppRouteName.home,
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: AppRoutePath.stackNew,
        name: AppRouteName.stackNew,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            fullscreenDialog: true,
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 250),
            child: const StackEditPage(isAdd: true),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              );
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutePath.stackDetail,
        name: AppRouteName.stackDetail,
        redirect: (context, state) {
          final name = state.pathParameters['name'];
          if (name == null || name.trim().isEmpty) {
            return AppRoutePath.home;
          }
          return null;
        },
        builder: (context, state) {
          final stackName = state.pathParameters['name']!;
          return StackDetailPage(stackName: stackName);
        },
        routes: [
          GoRoute(
            path: AppRoutePath.stackEdit,
            name: AppRouteName.stackEdit,
            pageBuilder: (context, state) {
              final stackName = state.pathParameters['name']!;
              return CustomTransitionPage(
                key: state.pageKey,
                fullscreenDialog: true,
                transitionDuration: const Duration(milliseconds: 300),
                reverseTransitionDuration: const Duration(milliseconds: 250),
                child: StackEditPage(stackName: stackName),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  final curved = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                    reverseCurve: Curves.easeInCubic,
                  );
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(curved),
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
    ],
  );
});
