import 'package:dockge_dashboard/features/home/model/stack_detail_info.dart';
import 'package:dockge_dashboard/features/home/providers/stack_detail.dart';
import 'package:dockge_dashboard/theme/styles/badge_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
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
          FPopoverMenu(
            menu: [
              .group(
                divider: .indented,
                children: [
                  .item(
                    prefix: Icon(FLucideIcons.refreshCcw),
                    title: Text("Restart"),
                    onPress: () {
                      HapticFeedback.lightImpact();
                    }, // TODO: implement
                  ),
                  .item(
                    prefix: Icon(FLucideIcons.downloadCloud),
                    title: Text("Update"),
                    onPress: () {
                      HapticFeedback.lightImpact();
                    }, // TODO: implement
                  ),
                  .submenu(
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
                            }, // TODO: implement
                          ),
                          .item(
                            prefix: Icon(FLucideIcons.square),
                            title: Text("Stop & Inactive"),
                            onPress: () {
                              HapticFeedback.lightImpact();
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
                    }, // TODO: implement
                    variant: .destructive,
                  ),
                ],
              ),
            ],
            builder: (context, controller, child) => FHeaderAction(
              icon: Icon(FLucideIcons.moreVertical),
              onPress: () {
                HapticFeedback.lightImpact();
                controller.toggle();
              },
            ),
          ),
        ],
      ),
      footer: FBottomNavigationBar(
        index: _index,
        onChange: (index) => setState(() => _index = index),
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

class StackDetailServices extends ConsumerWidget {
  const StackDetailServices({super.key});

  FBadgeVariantConstraint statusVariant(String status) {
    if (status == 'running' || status == 'healthy') return .primary;
    if (status == 'unhealthy') return .destructive;
    return .secondary;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StackDetailInfo? detailInfo = ref.watch(stackDetailProvider);
    if (detailInfo == null) {
      return Center(child: Text("No details info"));
    }
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: detailInfo.services.length,
      itemBuilder: (context, idx) {
        ServiceInfo serviceInfo = detailInfo.services[idx];
        return FCard(
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
                ).variants[statusVariant(serviceInfo.status)]!,
                child: Text(serviceInfo.status),
              ),
              for (final port in serviceInfo.ports)
                FTooltip(
                  tipBuilder: (context, controller) => Text(port.toString()),
                  child: FBadge(
                    variant: .outline,
                    child: Text(
                      port.hostIp == null ? '${port.hostPort}' : '${port.hostIp}:${port.hostPort}',
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 10);
      },
    );
  }
}

class StackDetailTerminal extends ConsumerWidget {
  const StackDetailTerminal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terminal = ref.watch(stackTerminalProvider);
    return TerminalView(terminal, readOnly: true);
  }
}
