import 'package:dockge_dashboard/features/auth/providers/auth_controller.dart';
import 'package:dockge_dashboard/features/home/model/stack_info.dart';
import 'package:dockge_dashboard/features/home/providers/stack_list.dart';
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
      case .paused:
        return Icon(FLucideIcons.circlePause, size: 25, color: Colors.grey);
      case .active:
        return Icon(FLucideIcons.circleDot, size: 25, color: Colors.blue);
      case .exited:
        return Icon(FLucideIcons.circleStop, size: 25, color: Colors.red);
    }
  }

  FBadgeVariantConstraint statusVariant(StackStatus status) {
    switch (status) {
      case .unknown:
        return .outline;
      case .inactive:
        return .secondary;
      case .paused:
        return .secondary;
      case .active:
        return .primary;
      case .exited:
        return .destructive;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StackInfo? stacks = ref.watch(stackListProvider);
    if (stacks == null) {
      return const Center(child: Text("No stacks found"));
    }
    return ListView(
      padding: EdgeInsets.only(bottom: 50),
      children: [
        FTileGroup.builder(
          count: stacks.stackList.length,
          tileBuilder: (context, idx) {
            final item = stacks.stackList.values.toList()[idx];
            return FTile(
              prefix: statusIcon(item.status),
              title: Text(item.name),
              subtitle: Text(
                [item.status.label, if (item.isManagedByDockge) "Managed by Dockge"].join(" | "),
              ),
              suffix: Icon(FLucideIcons.chevronRight),
            );
          },
        ),
      ],
    );
  }
}
