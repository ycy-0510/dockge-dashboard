import 'package:dockge_dashboard/app/shared/utils/hash_color.dart';
import 'package:dockge_dashboard/app/shared/loading/loading_skeleton.dart';
import 'package:dockge_dashboard/features/dashboard/models/network_topology.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_network_snapshot.dart';
import 'package:dockge_dashboard/features/auth/models/auth_view_model.dart';
import 'package:dockge_dashboard/app/routing/routes.dart';
import 'package:dockge_dashboard/features/dashboard/models/network_topology_view_model.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_catalog_view_model.dart';
import 'package:dockge_dashboard/features/stacks/widgets/adaptive_stack_workspace.dart';
import 'package:dockge_dashboard/features/stacks/views/stack_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

part '../widgets/dashboard_overview.dart';
part '../widgets/network_topology_view.dart';
part '../widgets/stack_catalog_view.dart';

enum _DashboardTab { overview, stacks, network }

extension on _DashboardTab {
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
}

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  _DashboardTab _selectedTab = _DashboardTab.overview;
  String? _selectedStackName;

  Widget _tabContent(_DashboardTab tab) => switch (tab) {
    .overview => const DashboardOverview(),
    .stacks => AdaptiveStackWorkspace(
      compact: const StackCatalogView(),
      catalogHeader: FHeader(
        title: const Text('Stacks'),
        suffixes: [_stackCreationMenu()],
      ),
      catalog: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: StackCatalogView(
          selectedStackName: _selectedStackName,
          onStackSelected: (stack) {
            setState(() => _selectedStackName = stack.name);
          },
        ),
      ),
      detailHeader: _selectedStackName == null
          ? FHeader(
              title: const Text('Details'),
              suffixes: _accountActions(),
            )
          : StackDetailHeader(
              stackName: _selectedStackName!,
              suffixes: _accountActions(),
            ),
      detail: _selectedStackName == null
          ? const _StackSelectionPlaceholder()
          : StackDetailPane(
              key: ValueKey('stack-detail-$_selectedStackName'),
              stackName: _selectedStackName!,
              onDeleted: () => setState(() => _selectedStackName = null),
            ),
    ),
    .network => const NetworkTopologyView(),
  };

  Widget _stackCreationMenu() {
    return FPopoverMenu(
      autofocus: true,
      menuAnchor: .topRight,
      childAnchor: .bottomRight,
      menuBuilder: (context, controller, _) => [
        .group(
          divider: .indented,
          children: [
            .item(
              prefix: const Icon(FLucideIcons.server),
              title: const Text('New Stack'),
              onPress: () {
                HapticFeedback.lightImpact();
                controller.hide();
                this.context.pushNamed(AppRouteName.stackNew);
              },
            ),
            .item(
              prefix: const Icon(FLucideIcons.arrowLeftRight),
              title: const Text('Convert from docker run'),
              onPress: () {
                HapticFeedback.lightImpact();
                controller.hide();
                this.context.pushNamed(AppRouteName.composerize);
              },
            ),
          ],
        ),
      ],
      builder: (_, controller, _) => FHeaderAction(
        icon: const Icon(FLucideIcons.plus),
        onPress: () {
          HapticFeedback.lightImpact();
          controller.toggle();
        },
      ),
    );
  }

  List<Widget> _accountActions() => [
    const SizedBox(width: 10),
    FAvatar.raw(
      child: Text(
        (ref.watch(authViewModelProvider).username ?? 'U').toUpperCase()[0],
      ),
    ),
    const SizedBox(width: 10),
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
                variant: .destructive,
                onPress: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Log out'),
              ),
              FButton(
                variant: .outline,
                onPress: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
        if (result == true && mounted) {
          ref.read(authViewModelProvider.notifier).logout();
        }
      },
      icon: const Icon(FLucideIcons.logOut),
    ),
  ];

  Widget _rootHeader() => FHeader(
    title: const Text('Home'),
    suffixes: [
      _stackCreationMenu(),
      ..._accountActions(),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final splitStackHeader =
            _selectedTab == .stacks && constraints.maxWidth >= stackWorkspaceTwoPaneMinWidth;

        return FScaffold(
          childPad: !splitStackHeader,
          header: splitStackHeader ? null : _rootHeader(),
          footer: FBottomNavigationBar(
            index: _selectedTab.index,
            children: _DashboardTab.values.map((tab) => tab.navigationItem).toList(growable: false),
            onChange: (index) {
              HapticFeedback.lightImpact();
              setState(() => _selectedTab = _DashboardTab.values[index]);
            },
          ),
          child: IndexedStack(
            index: _selectedTab.index,
            children: _DashboardTab.values.map(_tabContent).toList(growable: false),
          ),
        );
      },
    );
  }
}

class _StackSelectionPlaceholder extends StatelessWidget {
  const _StackSelectionPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Icon(
            FLucideIcons.panelRightOpen,
            size: 36,
            color: context.theme.colors.mutedForeground,
          ),
          Text(
            'Select a stack',
            style: context.theme.typography.body.lg.copyWith(
              color: context.theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
