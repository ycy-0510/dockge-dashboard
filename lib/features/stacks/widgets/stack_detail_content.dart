part of '../views/stack_detail_page.dart';

final _loadingStackDetails = StackDetails(
  name: 'Loading stack',
  composeFileName: 'compose.yaml',
  composeYaml: '',
  composeEnv: '',
  summary: const StackSummary(
    name: 'Loading stack',
    status: .active,
    isManagedByDockge: true,
    composeFileName: 'compose.yaml',
  ),
  services: [
    StackService(
      name: 'Application service',
      status: 'running',
      imageName: 'registry.example/application:latest',
      ports: const [],
    ),
    StackService(
      name: 'Database service',
      status: 'healthy',
      imageName: 'registry.example/database:latest',
      ports: const [],
    ),
    StackService(
      name: 'Background worker',
      status: 'running',
      imageName: 'registry.example/worker:latest',
      ports: const [],
    ),
  ],
);

class StackDetailHeader extends ConsumerWidget {
  const StackDetailHeader({
    required this.stackName,
    this.showBackButton = false,
    this.suffixes = const [],
    super.key,
  });

  final String stackName;
  final bool showBackButton;
  final List<Widget> suffixes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FHeader(
      title: showBackButton
          ? Row(
              children: [
                FButton.icon(
                  size: .sm,
                  variant: .ghost,
                  onPress: () {
                    HapticFeedback.lightImpact();
                    context.pop();
                  },
                  child: const Icon(FLucideIcons.arrowLeft),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    stackName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          : Text(stackName),
      suffixes: [
        FHeaderAction(
          icon: const Icon(FLucideIcons.edit),
          onPress: () {
            HapticFeedback.mediumImpact();
            _runAuthorized(
              ref,
              () => context.pushNamed(
                AppRouteName.stackEdit,
                pathParameters: {'name': stackName},
              ),
            );
          },
        ),
        ...suffixes,
      ],
    );
  }
}

class StackDetailPane extends ConsumerStatefulWidget {
  const StackDetailPane({
    required this.stackName,
    this.onDeleted,
    super.key,
  });

  final String stackName;
  final VoidCallback? onDeleted;

  @override
  ConsumerState<StackDetailPane> createState() => _StackDetailPaneState();
}

class _StackDetailPaneState extends ConsumerState<StackDetailPane> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStack());
  }

  @override
  void didUpdateWidget(covariant StackDetailPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stackName != widget.stackName) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadStack());
    }
  }

  void _loadStack() {
    if (!mounted) return;
    ref.read(stackDetailsViewModelProvider.notifier).fetch(widget.stackName);
    ref.read(stackTerminalViewModelProvider.notifier).join(widget.stackName);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(stackDetailsViewModelProvider, (previous, next) {
      if (next.wasDeleted && previous?.wasDeleted != true) {
        final onDeleted = widget.onDeleted;
        if (onDeleted != null) {
          onDeleted();
        } else if (context.canPop()) {
          context.pop();
        } else {
          context.goNamed(AppRouteName.home);
        }
      }
    });

    ref.watch(stackDetailsViewModelProvider);
    ref.watch(stackTerminalViewModelProvider);
    return StackDetailTabs(
      key: ValueKey('stack-detail-tabs-${widget.stackName}'),
    );
  }
}

class StackDetailTabs extends StatelessWidget {
  const StackDetailTabs({
    this.services = const StackDetailServices(),
    this.terminal = const StackDetailTerminal(),
    super.key,
  });

  final Widget services;
  final Widget terminal;

  @override
  Widget build(BuildContext context) {
    final content = {
      _StackDetailTab.services: services,
      _StackDetailTab.terminal: _StackTerminalSurface(child: terminal),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FTabs(
        expands: true,
        contentPhysics: const NeverScrollableScrollPhysics(),
        onPress: (_) => HapticFeedback.lightImpact(),
        children: _StackDetailTab.values
            .map(
              (tab) => FTabEntry(label: tab.label, child: content[tab]!),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _StackTerminalSurface extends StatelessWidget {
  const _StackTerminalSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      minimum: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        key: const Key('stack-terminal-surface'),
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}

class StackDetailServices extends ConsumerStatefulWidget {
  const StackDetailServices({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StackDetailServicesState();
}

class _StackDetailServicesState extends ConsumerState<StackDetailServices>
    with SingleTickerProviderStateMixin {
  late final _controller = FPopoverController(vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete() async {
    final stackName = ref.read(stackDetailsViewModelProvider).details?.name;
    if (stackName == null) return;
    final confirmed = await showFSheet<bool>(
      context: context,
      side: FLayout.btt,
      useSafeArea: true,
      builder: (context) => _DeleteConfirmSheet(stackName: stackName),
    );
    if (confirmed != true) return;
    await _runAuthorized(
      ref,
      () => ref.read(stackDetailsViewModelProvider.notifier).delete(),
    );
  }

  FBadgeVariantConstraint serviceStatusVariant(String status) {
    if (status == 'running' || status == 'healthy') return .primary;
    if (status == 'unhealthy') return .destructive;
    return .secondary;
  }

  FBadgeVariantConstraint stackStatusVariant(StackStatus status) {
    if (status == .active) return .primary;
    if (status == .exited) return .destructive;
    if (status == .deploying || status == .inactive) return .secondary;
    return .outline;
  }

  @override
  Widget build(BuildContext context) {
    final viewState = ref.watch(stackDetailsViewModelProvider);
    final details = viewState.details;
    if (details == null && !viewState.isLoading) {
      return Center(
        child: Text(viewState.errorMessage ?? 'No stack details found'),
      );
    }
    final visibleDetails = details ?? _loadingStackDetails;
    final terminalState = ref.watch(stackTerminalViewModelProvider);
    final info = visibleDetails.summary;

    return LoadingSkeleton(
      enabled: viewState.isLoading,
      label: 'Loading stack details',
      child: CustomScrollView(
        slivers: [
          if (info != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: FCard.raw(
                  clipBehavior: .antiAlias,
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: .stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                info.name,
                                style: context.theme.typography.display.lg.copyWith(
                                  fontWeight: .w500,
                                  color: context.theme.colors.foreground,
                                ),
                                overflow: .ellipsis,
                              ),
                            ),
                            FBadge(
                              style: statusBadgeStyles(
                                colors: context.theme.colors,
                                typography: context.theme.typography,
                                style: context.theme.style,
                                touch: true,
                              ).variants[stackStatusVariant(info.status)]!,
                              child: Text(info.status.label),
                            ),
                            FPopoverMenu(
                              control: .managed(controller: _controller),
                              menuAnchor: .topRight,
                              menu: [
                                .group(
                                  divider: .indented,
                                  children: [
                                    if (info.status != .active)
                                      .item(
                                        prefix: Icon(FLucideIcons.play),
                                        title: Text("Start"),
                                        onPress: () {
                                          HapticFeedback.lightImpact();
                                          _controller.hide();
                                          _runAuthorized(
                                            ref,
                                            () => ref
                                                .read(
                                                  stackDetailsViewModelProvider.notifier,
                                                )
                                                .start(),
                                          );
                                        },
                                      ),
                                    if (info.status == .active)
                                      .item(
                                        prefix: Icon(FLucideIcons.refreshCcw),
                                        title: Text("Restart"),
                                        onPress: () {
                                          HapticFeedback.lightImpact();
                                          _controller.hide();
                                          _runAuthorized(
                                            ref,
                                            () => ref
                                                .read(
                                                  stackDetailsViewModelProvider.notifier,
                                                )
                                                .restart(),
                                          );
                                        },
                                      ),
                                    .item(
                                      prefix: Icon(FLucideIcons.downloadCloud),
                                      title: Text("Update"),
                                      onPress: () {
                                        HapticFeedback.lightImpact();
                                        _controller.hide();
                                        _runAuthorized(
                                          ref,
                                          () => ref
                                              .read(
                                                stackDetailsViewModelProvider.notifier,
                                              )
                                              .update(),
                                        );
                                      },
                                    ),
                                    if (info.status != .inactive)
                                      .submenu(
                                        menuAnchor: .topCenter,
                                        itemAnchor: .center,
                                        prefix: Icon(FLucideIcons.square),
                                        title: Text("Stop"),
                                        submenu: [
                                          .group(
                                            children: [
                                              if (info.status == .active)
                                                .item(
                                                  prefix: Icon(
                                                    FLucideIcons.square,
                                                  ),
                                                  title: Text("Stop"),
                                                  onPress: () {
                                                    HapticFeedback.lightImpact();
                                                    _controller.hide();
                                                    _runAuthorized(
                                                      ref,
                                                      () => ref
                                                          .read(
                                                            stackDetailsViewModelProvider.notifier,
                                                          )
                                                          .stop(),
                                                    );
                                                  },
                                                ),
                                              .item(
                                                prefix: Icon(FLucideIcons.square),
                                                title: Text("Stop & Inactive"),
                                                onPress: () {
                                                  HapticFeedback.lightImpact();
                                                  _controller.hide();
                                                  _runAuthorized(
                                                    ref,
                                                    () => ref
                                                        .read(
                                                          stackDetailsViewModelProvider.notifier,
                                                        )
                                                        .takeDown(),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                .group(
                                  divider: .indented,
                                  children: [
                                    .item(
                                      prefix: Icon(FLucideIcons.trash2),
                                      title: Text("Delete"),
                                      onPress: () {
                                        HapticFeedback.heavyImpact();
                                        _controller.hide();
                                        _confirmDelete();
                                      },
                                      variant: .destructive,
                                    ),
                                  ],
                                ),
                              ],
                              builder: (context, controller, child) => FButton.icon(
                                size: .sm,
                                variant: .ghost,
                                child: Icon(FLucideIcons.moreVertical),
                                onPress: () {
                                  HapticFeedback.lightImpact();
                                  controller.toggle();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        child: Text(
                          info.composeFileName,
                          style: context.theme.typography.body.sm.copyWith(
                            color: context.theme.colors.mutedForeground,
                          ),
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Easing.standard,
                        alignment: Alignment.topCenter,
                        child: (terminalState != null && terminalState.composeTerminal != null)
                            ? SizedBox(
                                height: 200,
                                child: TerminalView(
                                  terminalState.composeTerminal!,
                                  readOnly: true,
                                  padding: EdgeInsets.all(10),
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'SERVICES',
                style: context.theme.typography.display.md.copyWith(
                  color: context.theme.colors.mutedForeground,
                  fontWeight: .w500,
                ),
              ),
            ),
          ),
          SliverList.separated(
            itemCount: visibleDetails.services.length,
            itemBuilder: (context, idx) {
              final service = visibleDetails.services[idx];
              return IntrinsicHeight(
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: .stretch,
                  children: [
                    SizedBox(
                      width: 2,
                      child: ColoredBox(color: context.theme.colors.border),
                    ),
                    Expanded(
                      child: FCard(
                        title: Text(service.name),
                        subtitle: Text(
                          service.imageName ?? 'Image not specified',
                        ),
                        child: Wrap(
                          spacing: 5,
                          children: [
                            FBadge(
                              style: statusBadgeStyles(
                                colors: context.theme.colors,
                                typography: context.theme.typography,
                                style: context.theme.style,
                                touch: true,
                              ).variants[serviceStatusVariant(service.status)]!,
                              child: Text(service.status),
                            ),
                            for (final port in service.ports)
                              FTooltip(
                                tipBuilder: (context, controller) => Text(port.toString()),
                                child: FBadge(
                                  variant: .outline,
                                  child: Text(
                                    port.hostIp == null
                                        ? '${port.hostPort}'
                                        : '${port.hostIp}:${port.hostPort}',
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => Row(
              children: [
                SizedBox(
                  width: 2,
                  height: 10,
                  child: ColoredBox(color: context.theme.colors.border),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StackDetailTerminal extends ConsumerWidget {
  const StackDetailTerminal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stackTerminalViewModelProvider);
    if (state == null) {
      return Center(child: FCircularProgress(size: .xl));
    }
    return TerminalView(
      state.combinedTerminal,
      readOnly: true,
      padding: const EdgeInsets.all(10),
    );
  }
}

class _DeleteConfirmSheet extends StatefulWidget {
  final String stackName;
  const _DeleteConfirmSheet({required this.stackName});

  @override
  State<_DeleteConfirmSheet> createState() => _DeleteConfirmSheetState();
}

class _DeleteConfirmSheetState extends State<_DeleteConfirmSheet> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matches = _controller.text.trim() == widget.stackName;
    const margin = 15.0;
    final screenRadii = MediaQuery.displayCornerRadiiOf(context) ?? BorderRadius.circular(60);
    double inset(Radius r) => (r.x - margin).clamp(0.0, double.infinity);
    final radius = BorderRadius.only(
      topLeft: Radius.circular(inset(screenRadii.topLeft)),
      topRight: Radius.circular(inset(screenRadii.topRight)),
      bottomLeft: Radius.circular(inset(screenRadii.bottomLeft)),
      bottomRight: Radius.circular(inset(screenRadii.bottomRight)),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: context.theme.colors.background,
        border: .all(color: context.theme.colors.border),
      ),
      margin: const .all(margin),
      padding: EdgeInsets.all(25),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        spacing: 12,
        children: [
          Row(
            children: [
              Text(
                'Delete stack',
                style: context.theme.typography.display.lg.copyWith(
                  fontWeight: .w600,
                  color: context.theme.colors.foreground,
                ),
              ),
              Spacer(),
              FButton.icon(
                variant: .outline,
                onPress: () => Navigator.of(context).pop(false),
                child: const Icon(FLucideIcons.x),
              ),
            ],
          ),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'This permanently deletes the stack and its files. Type ',
                ),
                TextSpan(
                  text: widget.stackName,
                  style: TextStyle(
                    fontWeight: .w600,
                    color: context.theme.colors.foreground,
                  ),
                ),
                const TextSpan(text: ' to confirm.'),
              ],
            ),
            style: context.theme.typography.body.sm.copyWith(
              color: context.theme.colors.mutedForeground,
            ),
          ),
          FTextField(
            control: .managed(controller: _controller),
            hint: widget.stackName,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: .done,
            autofocus: true,
            onSubmit: matches ? (_) => Navigator.of(context).pop(true) : null,
          ),
          FButton(
            variant: .destructive,
            onPress: matches ? () => Navigator.of(context).pop(true) : null,
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
