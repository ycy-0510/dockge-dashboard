import 'package:dockge_dashboard/core/utils/hash_color.dart';
import 'package:dockge_dashboard/features/auth/providers/auth_controller.dart';
import 'package:dockge_dashboard/features/home/model/network_state.dart';
import 'package:dockge_dashboard/features/home/model/stack_info.dart';
import 'package:dockge_dashboard/features/home/model/status.dart';
import 'package:dockge_dashboard/features/home/providers/network.dart';
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
    .overview => const HomeOverview(),
    .stacks => const HomeStackList(),
    .network => const HomeNetwork(),
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

class HomeOverview extends ConsumerWidget {
  const HomeOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(overviewProvider);
    final cards = <Widget>[
      _OverviewCard(
        label: 'Stacks',
        description: 'All stacks',
        value: metrics.stacks,
        icon: FLucideIcons.server,
        color: Colors.blue,
      ),
      _OverviewCard(
        label: 'Active',
        description: 'Running',
        value: metrics.active,
        icon: FLucideIcons.circlePlay,
        color: Colors.green,
      ),
      _OverviewCard(
        label: 'Exited',
        description: 'Stopped with exit',
        value: metrics.exited,
        icon: FLucideIcons.circleStop,
        color: Colors.red,
      ),
      _OverviewCard(
        label: 'Inactive',
        description: 'Not running',
        value: metrics.inactive,
        icon: FLucideIcons.circlePause,
        color: Colors.grey,
      ),
      _OverviewCard(
        label: 'Services',
        description: 'Managed stacks',
        value: metrics.services,
        icon: FLucideIcons.boxes,
        color: Colors.purple,
      ),
      _OverviewCard(
        label: 'Ports',
        description: 'Unique host ports',
        value: metrics.ports,
        icon: FLucideIcons.ethernetPort,
        color: Colors.orange,
      ),
    ];

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisExtent: 150,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => cards[index],
              childCount: cards.length,
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom)),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.label,
    required this.description,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String description;
  final int value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      child: FCard.raw(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: context.theme.typography.body.sm.copyWith(
                      color: context.theme.colors.mutedForeground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Icon(icon, size: 20, color: color),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '$value',
                style: context.theme.typography.display.lg.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.theme.typography.body.xs.copyWith(
                  color: context.theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
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

class HomeNetwork extends ConsumerWidget {
  const HomeNetwork({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NetworkState network = ref.watch(networkProvider);
    return CustomScrollView(
      slivers: [
        PortList(ports: network.ports),
        GlobalNetworkList(globalNetworks: network.globalNetworks),
        SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.bottom)),
      ],
    );
  }
}

class PortList extends StatelessWidget {
  const PortList({super.key, required this.ports});
  final List<PortState> ports;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: Text(
              'Ports',
              style: context.theme.typography.display.xs.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ports.isEmpty
              ? FTile(title: const Text('No published ports found'))
              : FTileGroup.builder(
                  count: ports.length,
                  tileBuilder: (context, idx) => FTile(
                    prefix: SizedBox(width: 50, child: Text('${ports[idx].port ?? 'NA'}')),
                    title: Wrap(
                      spacing: 5,
                      children: [
                        Text(ports[idx].stackName),
                        Icon(FLucideIcons.chevronRight),
                        Text(ports[idx].serviceName),
                      ],
                    ),
                    subtitle: Text(_portServiceName(ports[idx].port)),
                  ),
                ),
        ),
      ],
    );
  }
}

String _portServiceName(int? port) => switch (port) {
  null => 'Dynamic host port',
  20 => 'FTP data',
  21 => 'FTP',
  22 => 'SSH',
  23 => 'Telnet',
  25 => 'SMTP',
  53 => 'DNS',
  67 => 'DHCP server',
  68 => 'DHCP client',
  69 => 'TFTP',
  80 => 'HTTP',
  110 => 'POP3',
  123 => 'NTP',
  143 => 'IMAP',
  161 => 'SNMP',
  162 => 'SNMP trap',
  389 => 'LDAP',
  443 => 'HTTPS',
  445 => 'SMB',
  465 => 'SMTPS',
  514 => 'Syslog',
  587 => 'SMTP submission',
  636 => 'LDAPS',
  853 => 'DNS over TLS',
  993 => 'IMAPS',
  995 => 'POP3S',
  1883 => 'MQTT',
  3306 => 'MySQL',
  3389 => 'RDP',
  5432 => 'PostgreSQL',
  5672 => 'AMQP',
  6379 => 'Redis',
  8080 => 'HTTP alternate',
  8443 => 'HTTPS alternate',
  9092 => 'Kafka',
  27017 => 'MongoDB',
  _ => 'Custom service',
};

class GlobalNetworkList extends StatelessWidget {
  const GlobalNetworkList({super.key, required this.globalNetworks});
  final List<GlobalNetworkState> globalNetworks;
  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: Text(
              'Global Network',
              style: context.theme.typography.display.xs.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ),
        ),
        if (globalNetworks.isEmpty)
          SliverToBoxAdapter(child: FTile(title: const Text('No shared networks found'))),
        for (final networkState in globalNetworks)
          SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 2),
                  child: Text(networkState.network),
                ),
              ),
              SliverList.separated(
                itemCount: networkState.stackNames.length,
                itemBuilder: (context, idx) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: FTile(title: Text(networkState.stackNames[idx])),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: 22,
                        child: _TreeBranch(
                          color: context.theme.colors.border,
                          isLast: idx == networkState.stackNames.length - 1,
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  width: 22,
                  height: 10,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 2,
                      height: double.infinity,
                      child: ColoredBox(color: context.theme.colors.border),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _TreeBranch extends StatelessWidget {
  const _TreeBranch({required this.color, required this.isLast});

  final Color color;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: FractionallySizedBox(
            heightFactor: isLast ? 0.5 : 1,
            child: SizedBox(width: 2, child: ColoredBox(color: color)),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: double.infinity,
            height: 2,
            child: ColoredBox(color: color),
          ),
        ),
      ],
    );
  }
}
