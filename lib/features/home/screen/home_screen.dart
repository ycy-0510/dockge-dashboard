import 'package:dockge_dashboard/features/auth/providers/auth_controller.dart';
import 'package:dockge_dashboard/features/home/model/stack_info.dart';
import 'package:dockge_dashboard/features/home/model/status.dart';
import 'package:dockge_dashboard/features/home/providers/stack_list.dart';
import 'package:dockge_dashboard/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          FHeaderAction(
            onPress: () async {
              HapticFeedback.lightImpact();
              final result = await showFDialog<bool>(
                context: context,
                builder: (dialogContext, style, animation) => FDialog(
                  title: const Text('Log out?'),
                  body: const Text('Are you sure to log out?'),
                  actions: <Widget>[
                    FButton(
                      variant: FButtonVariant.destructive,
                      onPress: () => Navigator.of(dialogContext).pop(true),
                      child: const Text('Log out'),
                    ),
                    FButton(
                      variant: FButtonVariant.outline,
                      onPress: () => Navigator.of(dialogContext).pop(false),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              );
              if (result == true && context.mounted) {
                ref.read(authControllerProvider.notifier).logout();
                context.replaceNamed(AppRouteName.login);
              }
            },
            icon: Icon(FLucideIcons.logOut),
          ),
        ],
      ),
      child: HomeStackList(),
    );
  }
}

class HomeStackList extends ConsumerWidget {
  const HomeStackList({super.key});

  Icon statusIcon(StackStatus status) {
    switch (status) {
      case .unknown:
        return Icon(FLucideIcons.circleQuestionMark, size: 25);
      case .inactive:
        return Icon(FLucideIcons.circlePause, size: 25, color: Colors.grey);
      case .deploying:
        return Icon(FLucideIcons.circlePause, size: 25, color: Colors.grey);
      case .active:
        return Icon(FLucideIcons.circleDot, size: 25, color: Colors.blue);
      case .exited:
        return Icon(FLucideIcons.circleStop, size: 25, color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StackInfo? stacks = ref.watch(stackListProvider);
    if (stacks == null) {
      return const Center(child: Text("No stacks found"));
    }
    final items = stacks.stackList.values.toList();
    return ListView(
      padding: EdgeInsets.only(bottom: 50),
      children: [
        FTileGroup.builder(
          count: items.length,
          tileBuilder: (context, idx) {
            final item = items[idx];
            return FTile(
              onPress: item.isManagedByDockge
                  ? () {
                      HapticFeedback.lightImpact();
                      context.pushNamed(
                        AppRouteName.stackDetail,
                        pathParameters: {'name': item.name},
                      );
                    }
                  : null,
              prefix: statusIcon(item.status),
              title: Text(item.name),
              subtitle: Text(
                [item.status.label, if (item.isManagedByDockge) "Managed by Dockge"].join(" | "),
              ),
              suffix: item.isManagedByDockge ? Icon(FLucideIcons.chevronRight) : null,
            );
          },
        ),
      ],
    );
  }
}
