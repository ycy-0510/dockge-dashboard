import 'package:dockge_dashboard/core/utils/hash_color.dart';
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

enum _HomeTab { overview, stacks, network }

extension on _HomeTab {
  FBottomNavigationBarItem get navigationItem => switch (this) {
    .overview => const FBottomNavigationBarItem(
      icon: Icon(FLucideIcons.layoutDashboard),
      label: Text('Overview'),
    ),
    .stacks => const FBottomNavigationBarItem(
      icon: Icon(FLucideIcons.listTree),
      label: Text('Stacks'),
    ),
    .network => const FBottomNavigationBarItem(
      icon: Icon(FLucideIcons.network),
      label: Text('Network'),
    ),
  };

  Widget get content => switch (this) {
    .overview => const Placeholder(),
    .stacks => const HomeStackList(),
    .network => const Placeholder(),
  };
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin {
  late final _controller = FPopoverController(vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _HomeTab _selectedTab = _HomeTab.overview;

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: Text("Home"),
        suffixes: [
          FPopoverMenu(
            autofocus: true,
            menuAnchor: .topRight,
            childAnchor: .bottomRight,
            control: .managed(controller: _controller),
            menu: [
              .group(
                divider: .indented,
                children: [
                  .item(
                    prefix: Icon(FLucideIcons.server),
                    title: Text('New Stack'),
                    onPress: () {
                      HapticFeedback.lightImpact();
                      _controller.hide();
                      context.pushNamed(AppRouteName.stackNew);
                    },
                  ),
                  .item(
                    prefix: Icon(FLucideIcons.arrowLeftRight),
                    title: Text('Convert from docker run'),
                    onPress: () {
                      HapticFeedback.lightImpact();
                      _controller.hide();
                      context.pushNamed(AppRouteName.composerize);
                    },
                  ),
                ],
              ),
            ],
            builder: (_, controller, _) => FHeaderAction(
              icon: Icon(FLucideIcons.plus),
              onPress: () {
                HapticFeedback.lightImpact();
                controller.toggle();
              },
            ),
          ),

          SizedBox(width: 10),
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
              }
            },
            icon: Icon(FLucideIcons.logOut),
          ),
        ],
      ),
      footer: FBottomNavigationBar(
        index: _selectedTab.index,
        children: _HomeTab.values.map((tab) => tab.navigationItem).toList(growable: false),
        onChange: (index) {
          setState(() => _selectedTab = _HomeTab.values[index]);
        },
      ),
      child: IndexedStack(
        index: _selectedTab.index,
        children: _HomeTab.values.map((tab) => tab.content).toList(growable: false),
      ),
    );
  }
}

class HomeStackList extends ConsumerWidget {
  const HomeStackList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StackInfo? stacks = ref.watch(stackListProvider);
    if (stacks == null) {
      return const Center(child: Text("No stacks found"));
    }
    final items = stacks.stackList.values;
    final activeItem = items.where((item) => item.status == .active).toList();
    final stoppedItem = items.where((item) => item.status != .active).toList();
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Wrap(
              spacing: 10,
              children: [
                FBadge(variant: .secondary, child: Text('${activeItem.length} Active')),
                FBadge(variant: .outline, child: Text('${stoppedItem.length} Stopped')),
              ],
            ),
          ),
        ),
        StackListView(title: 'ACTIVE', items: activeItem, key: const ValueKey('active-section')),
        StackListView(title: 'STOPPED', items: stoppedItem, key: const ValueKey('stopped-section')),
        SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.bottom)),
      ],
    );
  }
}

class StackListView extends StatelessWidget {
  const StackListView({super.key, required this.title, required this.items});
  final String title;
  final List<StackItem> items;

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
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: Text(
              title,
              style: context.theme.typography.display.xs.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ),
        ),
        SliverList.separated(
          itemCount: items.length,
          itemBuilder: (context, idx) {
            final item = items[idx];
            final (iconBackground, iconForeground) = HashColorGenerator.colorFor(
              item.name,
              Theme.of(context).brightness,
            );
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
              title: Text(item.name),
              prefix: Container(
                padding: .all(5),
                decoration: BoxDecoration(color: iconBackground, borderRadius: .circular(5)),
                child: Icon(FLucideIcons.server, color: iconForeground),
              ),
              subtitle: Text(
                [item.status.label, if (item.isManagedByDockge) "Managed by Dockge"].join(" | "),
              ),
              details: statusIcon(item.status),
              suffix: Icon(item.isManagedByDockge ? FLucideIcons.chevronRight : null),
            );
          },
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 20),
        ),
      ],
    );
  }
}
