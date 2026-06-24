import 'package:dockge_dashboard/features/home/model/stack_detail_info.dart';
import 'package:dockge_dashboard/features/home/providers/stack_detail.dart';
import 'package:dockge_dashboard/theme/styles/badge_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

class StackDetailPage extends ConsumerStatefulWidget {
  final String stackName;
  const StackDetailPage({super.key, required this.stackName});

  @override
  ConsumerState<StackDetailPage> createState() => _StackDetailPageState();
}

class _StackDetailPageState extends ConsumerState<StackDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(stackDetailProvider.notifier).fetch(widget.stackName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.back(
            onPress: () {
              HapticFeedback.lightImpact();
              context.pop();
            },
          )
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
      child: StackDetailBody(),
    );
  }
}

class StackDetailBody extends ConsumerWidget {
  const StackDetailBody({super.key});

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
    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
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
                            port.hostIp == null
                                ? '${port.hostPort}'
                                : '${port.hostIp}:${port.hostPort}',
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
          ),
        ],
      ),
    );
  }
}
