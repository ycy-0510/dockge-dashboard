import 'package:dockge_dashboard/app/routing/routes.dart';
import 'package:dockge_dashboard/features/composerize/models/composerize_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

class ComposerizePage extends StatelessWidget {
  const ComposerizePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.x(
            onPress: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).maybePop();
            },
          ),
        ],
        title: const Text('Convert from docker run'),
      ),
      child: const ComposerizeBody(),
    );
  }
}

class ComposerizeBody extends ConsumerStatefulWidget {
  const ComposerizeBody({super.key});

  @override
  ConsumerState<ComposerizeBody> createState() => _ComposerizeBodyState();
}

class _ComposerizeBodyState extends ConsumerState<ComposerizeBody> {
  final TextEditingController _commandController = TextEditingController();

  @override
  void dispose() {
    _commandController.dispose();
    super.dispose();
  }

  Future<void> _convert() async {
    FocusScope.of(context).unfocus();
    final composeTemplate = await ref
        .read(composerizeViewModelProvider.notifier)
        .convert(_commandController.text);
    if (composeTemplate != null && mounted) {
      context.replaceNamed(
        AppRouteName.stackNew,
        queryParameters: {'prefillCompose': composeTemplate},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConverting = ref.watch(composerizeViewModelProvider);
    return SafeArea(
      top: false,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          FTextField.multiline(
            autofocus: true,
            autocorrect: false,
            control: .managed(controller: _commandController),
            enableSuggestions: false,
            keyboardType: TextInputType.multiline,
            smartDashesType: SmartDashesType.disabled,
            smartQuotesType: SmartQuotesType.disabled,
            textCapitalization: TextCapitalization.none,
            label: const Text('docker run command'),
            hint: 'docker run ...',
            maxLines: 6,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: FButton(
              onPress: isConverting
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      _convert();
                    },
              size: .lg,
              prefix: isConverting ? const FCircularProgress() : null,
              child: const Text('Convert'),
            ),
          ),
        ],
      ),
    );
  }
}
