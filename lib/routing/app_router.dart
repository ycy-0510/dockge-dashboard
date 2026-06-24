import 'package:dockge_dashboard/features/auth/providers/auth_controller.dart';
import 'package:dockge_dashboard/features/auth/screen/login_screen.dart';
import 'package:dockge_dashboard/features/home/screen/home_screen.dart';
import 'package:dockge_dashboard/features/home/screen/stack_detail_screen.dart';
import 'package:dockge_dashboard/routing/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // final authState = ref.watch(authStateProvider);
  return GoRouter(
    redirect: (context, state) {
      final isLoggedIn = ref.read(authControllerProvider).loginStatus == .authenticated;
      if (!isLoggedIn && state.matchedLocation != AppRoutePath.login) return AppRoutePath.login;
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
      ),
    ],
  );
});
