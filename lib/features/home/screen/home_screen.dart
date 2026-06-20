import 'package:dockge_dashboard/features/auth/providers/auth_controller.dart';
import 'package:dockge_dashboard/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FScaffold(
      header: FHeader(
        title: Text("Home"),
        suffixes: [
          FAvatar.raw(
            child: Text((ref.watch(authControllerProvider).username ?? "U").toUpperCase()[0]),
          ),
          SizedBox(width: 10),
          FButton.icon(
            onPress: () {
              ref.read(authControllerProvider.notifier).logout();
              context.replaceNamed(AppRouteName.login);
            },
            child: Icon(FLucideIcons.logOut),
          ),
        ],
      ),
      child: Placeholder(child: Text(ref.watch(authControllerProvider).toString())),
    );
  }
}
