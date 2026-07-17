part of '../views/dashboard_page.dart';

const _loadingStackSummaries = <StackSummary>[
  StackSummary(
    name: 'Primary services',
    status: .active,
    isManagedByDockge: true,
    composeFileName: 'compose.yaml',
  ),
  StackSummary(
    name: 'Monitoring tools',
    status: .active,
    isManagedByDockge: true,
    composeFileName: 'compose.yaml',
  ),
  StackSummary(
    name: 'Development apps',
    status: .inactive,
    isManagedByDockge: true,
    composeFileName: 'compose.yaml',
  ),
  StackSummary(
    name: 'Archived services',
    status: .inactive,
    isManagedByDockge: true,
    composeFileName: 'compose.yaml',
  ),
];

class StackCatalogView extends ConsumerWidget {
  const StackCatalogView({
    this.selectedStackName,
    this.onStackSelected,
    super.key,
  });

  final String? selectedStackName;
  final ValueChanged<StackSummary>? onStackSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(stackCatalogViewModelProvider);
    final isLoading = catalog == null;
    final items = catalog?.stacks ?? _loadingStackSummaries;
    final activeItem = items.where((item) => item.status == .active).toList();
    final stoppedItem = items.where((item) => item.status != .active).toList();
    return LoadingSkeleton(
      enabled: isLoading,
      label: 'Loading stacks',
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Wrap(
                spacing: 10,
                children: [
                  FBadge(
                    variant: .secondary,
                    child: Text('${activeItem.length} Active'),
                  ),
                  FBadge(
                    variant: .outline,
                    child: Text('${stoppedItem.length} Stopped'),
                  ),
                ],
              ),
            ),
          ),
          StackListView(
            title: 'ACTIVE',
            items: activeItem,
            selectedStackName: selectedStackName,
            onStackSelected: onStackSelected,
            key: const ValueKey('active-section'),
          ),
          StackListView(
            title: 'STOPPED',
            items: stoppedItem,
            selectedStackName: selectedStackName,
            onStackSelected: onStackSelected,
            key: const ValueKey('stopped-section'),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.bottom),
          ),
        ],
      ),
    );
  }
}

class StackListView extends StatelessWidget {
  const StackListView({
    required this.title,
    required this.items,
    this.selectedStackName,
    this.onStackSelected,
    super.key,
  });

  final String title;
  final List<StackSummary> items;
  final String? selectedStackName;
  final ValueChanged<StackSummary>? onStackSelected;

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
            final (
              iconBackground,
              iconForeground,
            ) = HashColorGenerator.colorFor(
              item.name,
              Theme.of(context).brightness,
            );
            return FTile(
              selected: selectedStackName == item.name,
              onPress: item.isManagedByDockge
                  ? () {
                      HapticFeedback.lightImpact();
                      final onSelected = onStackSelected;
                      if (onSelected != null) {
                        onSelected(item);
                      } else {
                        context.pushNamed(
                          AppRouteName.stackDetail,
                          pathParameters: {'name': item.name},
                        );
                      }
                    }
                  : null,
              title: Text(item.name),
              prefix: Container(
                padding: .all(5),
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: .circular(5),
                ),
                child: Icon(FLucideIcons.server, color: iconForeground),
              ),
              subtitle: Text(
                [
                  item.status.label,
                  if (item.isManagedByDockge) "Managed by Dockge",
                ].join(" | "),
              ),
              details: statusIcon(item.status),
              suffix: Icon(
                item.isManagedByDockge ? FLucideIcons.chevronRight : null,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 20),
        ),
      ],
    );
  }
}
