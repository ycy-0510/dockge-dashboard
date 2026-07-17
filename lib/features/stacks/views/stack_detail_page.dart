import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_details.dart';
import 'package:dockge_dashboard/app/routing/routes.dart';
import 'package:dockge_dashboard/app/shared/theme/badge_styles.dart';
import 'package:dockge_dashboard/app/shared/loading/loading_skeleton.dart';
import 'package:dockge_dashboard/features/stacks/models/admin_access_view_model.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_details_view_model.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_terminal_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:xterm/ui.dart';

part '../widgets/stack_detail_content.dart';

Future<void> _runAuthorized(
  WidgetRef ref,
  Future<void> Function() action,
) async {
  final authorized = await ref.read(adminAccessViewModelProvider.notifier).authorize();
  if (authorized) await action();
}

enum _StackDetailTab { services, terminal }

extension on _StackDetailTab {
  Widget get label => switch (this) {
    .services => const Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [Icon(FLucideIcons.server), Text('Services')],
    ),
    .terminal => const Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [Icon(FLucideIcons.squareTerminal), Text('Terminal')],
    ),
  };
}

class StackDetailPage extends StatelessWidget {
  final String stackName;
  const StackDetailPage({super.key, required this.stackName});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      childPad: false,
      header: StackDetailHeader(stackName: stackName, showBackButton: true),
      child: StackDetailPane(stackName: stackName),
    );
  }
}
