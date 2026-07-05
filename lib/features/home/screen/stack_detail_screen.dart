import 'package:dockge_dashboard/core/providers/toast_notifier.dart';
import 'package:dockge_dashboard/features/auth/providers/local_auth.dart';
import 'package:dockge_dashboard/features/home/model/stack_detail_info.dart';
import 'package:dockge_dashboard/features/home/model/status.dart';
import 'package:dockge_dashboard/features/home/providers/stack_detail.dart';
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

  @override
  Widget build(BuildContext context) {
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
              HapticFeedback.lightImpact();
            },
          ), // TODO: implement edit
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

  FBadgeVariantConstraint serviceStatusVariant(String status) {
    if (status == 'running' || status == 'healthy') return .primary;
    if (status == 'unhealthy') return .destructive;
    return .secondary;
  }

  FBadgeVariantConstraint stackStatusVariant(StackStatus status) {
    if (status == .active) return .primary;
    if (status == .exited) return .destructive;
    if (status == .deploying || status == .inactive) return .destructive;
    return .outline;
  }

  @override
  Widget build(BuildContext context) {
    StackDetailInfo? detailInfo = ref.watch(stackDetailProvider);
    if (detailInfo == null) {
      return Center(child: Text("No details info"));
    }
    final terminalState = ref.watch(stackTerminalProvider);

    return CustomScrollView(
      slivers: [
        if (ref.watch(stackDetailProvider)?.info != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: FCard(
                title: Row(
                  children: [
                    Text(ref.watch(stackDetailProvider)!.info!.name),
                    Spacer(),
                    FBadge(
                      style: statusBadgeStyles(
                        colors: context.theme.colors,
                        typography: context.theme.typography,
                        style: context.theme.style,
                        touch: true,
                      ).variants[stackStatusVariant(ref.watch(stackDetailProvider)!.info!.status)]!,
                      child: Text(ref.watch(stackDetailProvider)!.info!.status.label),
                    ),
                    FPopoverMenu(
                      control: .managed(controller: _controller),
                      menuAnchor: .topRight,
                      menu: [
                        .group(
                          divider: .indented,
                          children: [
                            .item(
                              prefix: Icon(FLucideIcons.refreshCcw),
                              title: Text("Restart"),
                              onPress: () {
                                HapticFeedback.lightImpact();
                                _controller.hide();
                              }, // TODO: implement
                            ),
                            .item(
                              prefix: Icon(FLucideIcons.downloadCloud),
                              title: Text("Update"),
                              onPress: () async {
                                HapticFeedback.lightImpact();
                                _controller.hide();
                                try {
                                  final result = await ref
                                      .read(localAuthProvider)
                                      .authenticate(
                                        localizedReason: 'Verify identity for admin access',
                                      );
                                  if (result) {
                                    ref.read(stackDetailProvider.notifier).update();
                                  }
                                } on LocalAuthException catch (e) {
                                  ref
                                      .read(toastProvider.notifier)
                                      .showError(message: e.description ?? e.toString());
                                } catch (e) {
                                  ref.read(toastProvider.notifier).showError(message: e.toString());
                                }
                              },
                            ),
                            .submenu(
                              menuAnchor: .topCenter,
                              itemAnchor: .center,
                              prefix: Icon(FLucideIcons.square),
                              title: Text("Stop"),
                              submenu: [
                                .group(
                                  children: [
                                    .item(
                                      prefix: Icon(FLucideIcons.square),
                                      title: Text("Stop"),
                                      onPress: () {
                                        HapticFeedback.lightImpact();
                                        _controller.hide();
                                      }, // TODO: implement
                                    ),
                                    .item(
                                      prefix: Icon(FLucideIcons.square),
                                      title: Text("Stop & Inactive"),
                                      onPress: () {
                                        HapticFeedback.lightImpact();
                                        _controller.hide();
                                      }, // TODO: implement
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
                                HapticFeedback.lightImpact();
                                _controller.hide();
                              }, // TODO: implement
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
                subtitle: Text(ref.watch(stackDetailProvider)!.info!.composeFileName),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            switchInCurve: Easing.standard,
            switchOutCurve: Easing.standard,
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: (terminalState != null && terminalState.composeTerminal != null)
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Card.filled(
                      key: ValueKey('show'),
                      clipBehavior: .antiAlias,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Text('Compose Output'),
                              Spacer(),
                              FButton.icon(
                                variant: .ghost,
                                onPress: () {
                                  HapticFeedback.lightImpact();
                                  ref.read(stackTerminalProvider.notifier).closeComposeTerminal();
                                },
                                child: Icon(FLucideIcons.x),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 200,
                            child: TerminalView(
                              terminalState.composeTerminal!,
                              readOnly: true,
                              padding: EdgeInsets.all(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
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
