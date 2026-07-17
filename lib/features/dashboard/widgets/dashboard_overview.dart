part of '../views/dashboard_page.dart';

class DashboardOverview extends ConsumerWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(stackCatalogViewModelProvider) == null;
    final metrics = ref.watch(overviewMetricsProvider);
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

    return LoadingSkeleton(
      enabled: isLoading,
      label: 'Loading dashboard overview',
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisExtent: 160,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => cards[index],
                childCount: cards.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.paddingOf(context).bottom),
          ),
        ],
      ),
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
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.theme.typography.body.sm.copyWith(
                        color: context.theme.colors.mutedForeground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                style: context.theme.typography.display.xl2.copyWith(
                  fontWeight: FontWeight.w700,
                ),
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
