import 'package:dockge_dashboard/core/providers/toast_notifier.dart';
import 'package:dockge_dashboard/features/auth/providers/local_auth.dart';
import 'package:dockge_dashboard/features/home/model/stack_detail_info.dart';
import 'package:dockge_dashboard/features/home/model/status.dart';
import 'package:dockge_dashboard/features/home/providers/stack_detail.dart';
import 'package:dockge_dashboard/routing/routes.dart';
import 'package:dockge_dashboard/theme/styles/badge_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:xterm/ui.dart';

class StackDetailPage extends ConsumerStatefulWidget {
  final String stackName;
  const StackDetailPage({super.key, required this.stackName});

  @override
  ConsumerState<StackDetailPage> createState() => _StackDetailPageState();
}

class _StackDetailPageState extends ConsumerState<StackDetailPage> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(stackDetailProvider.notifier).fetch(widget.stackName);
      ref.read(stackTerminalProvider.notifier).join(widget.stackName);
    });
  }

  Future<void> _authGuard(Future<void> Function() action) async {
    try {
      final result = await ref
          .read(localAuthProvider)
          .authenticate(localizedReason: 'Verify identity for admin access');
      if (result) {
        await action();
      }
    } on LocalAuthException catch (e) {
      ref.read(toastProvider.notifier).showError(message: e.description ?? e.toString());
    } catch (e) {
      ref.read(toastProvider.notifier).showError(message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(stackDetailProvider, (prev, next) {
      if (prev?.info != null && next?.info == null) {
        context.pop();
      }
    });

    ref.watch(stackDetailProvider);
    ref.watch(stackTerminalProvider);
    return FScaffold(
      childPad: _index != 1,
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.back(
            onPress: () {
              HapticFeedback.lightImpact();
              context.pop();
            },
          ),
        ],
        title: Text(widget.stackName),
        suffixes: [
          FHeaderAction(
            icon: Icon(FLucideIcons.edit),
            onPress: () {
              HapticFeedback.mediumImpact();
              _authGuard(
                () => context.pushNamed(
                  AppRouteName.stackEdit,
                  pathParameters: {'name': widget.stackName},
                ),
              );
            },
          ),
        ],
      ),
      footer: FBottomNavigationBar(
        index: _index,
        onChange: (index) {
          HapticFeedback.lightImpact();
          setState(() => _index = index);
        },
        children: const [
          FBottomNavigationBarItem(icon: Icon(FLucideIcons.server), label: Text('Services')),
          FBottomNavigationBarItem(
            icon: Icon(FLucideIcons.squareTerminal),
            label: Text('Terminal'),
          ),
        ],
      ),
      child: [StackDetailServices(), StackDetailTerminal()][_index],
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

  Future<void> _authGuard(Future<void> Function() action) async {
    try {
      final result = await ref
          .read(localAuthProvider)
          .authenticate(localizedReason: 'Verify identity for admin access');
      if (result) {
        await action();
      }
    } on LocalAuthException catch (e) {
      ref.read(toastProvider.notifier).showError(message: e.description ?? e.toString());
    } catch (e) {
      ref.read(toastProvider.notifier).showError(message: e.toString());
    }
  }

  Future<void> _confirmDelete() async {
    final stackName = ref.read(stackDetailProvider)?.name;
    if (stackName == null) return;
    final confirmed = await showFSheet<bool>(
      context: context,
      side: FLayout.btt,
      useSafeArea: true,
      builder: (context) => _DeleteConfirmSheet(stackName: stackName),
    );
    if (confirmed != true) return;
    await _authGuard(() => ref.read(stackDetailProvider.notifier).delete());
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
    StackDetailInfo? detailInfo = ref.watch(stackDetailProvider);
    if (detailInfo == null) {
      return Center(child: Text("No details info"));
    }
    final terminalState = ref.watch(stackTerminalProvider);
    final info = detailInfo.info;

    return CustomScrollView(
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
                                        _authGuard(
                                          () => ref.read(stackDetailProvider.notifier).start(),
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
                                        _authGuard(
                                          () => ref.read(stackDetailProvider.notifier).restart(),
                                        );
                                      },
                                    ),
                                  .item(
                                    prefix: Icon(FLucideIcons.downloadCloud),
                                    title: Text("Update"),
                                    onPress: () {
                                      HapticFeedback.lightImpact();
                                      _controller.hide();
                                      _authGuard(
                                        () => ref.read(stackDetailProvider.notifier).update(),
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
                                                prefix: Icon(FLucideIcons.square),
                                                title: Text("Stop"),
                                                onPress: () {
                                                  HapticFeedback.lightImpact();
                                                  _controller.hide();
                                                  _authGuard(
                                                    () => ref
                                                        .read(stackDetailProvider.notifier)
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
                                                _authGuard(
                                                  () =>
                                                      ref.read(stackDetailProvider.notifier).down(),
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
          itemCount: detailInfo.services.length,
          itemBuilder: (context, idx) {
            ServiceInfo serviceInfo = detailInfo.services[idx];
            return IntrinsicHeight(
              child: Row(
                spacing: 10,
                crossAxisAlignment: .stretch,
                children: [
                  SizedBox(width: 2, child: ColoredBox(color: context.theme.colors.border)),
                  Expanded(
                    child: FCard(
                      title: Text(serviceInfo.name),
                      subtitle: Text(serviceInfo.imageName),
                      child: Wrap(
                        spacing: 5,
                        children: [
                          FBadge(
                            style: statusBadgeStyles(
                              colors: context.theme.colors,
                              typography: context.theme.typography,
                              style: context.theme.style,
                              touch: true,
                            ).variants[serviceStatusVariant(serviceInfo.status)]!,
                            child: Text(serviceInfo.status),
                          ),
                          for (final port in serviceInfo.ports)
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
              SizedBox(width: 2, height: 10, child: ColoredBox(color: context.theme.colors.border)),
            ],
          ),
        ),
      ],
    );
  }
}

class StackDetailTerminal extends ConsumerWidget {
  const StackDetailTerminal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stackTerminalProvider);
    if (state == null) {
      return Center(child: FCircularProgress(size: .xl));
    }
    return TerminalView(state.combinedTerminal, readOnly: true, padding: EdgeInsets.all(10));
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
                const TextSpan(text: 'This permanently deletes the stack and its files. Type '),
                TextSpan(
                  text: widget.stackName,
                  style: TextStyle(fontWeight: .w600, color: context.theme.colors.foreground),
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
