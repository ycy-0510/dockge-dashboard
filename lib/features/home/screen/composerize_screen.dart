import 'dart:developer';

import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:dockge_dashboard/core/providers/toast_notifier.dart';
import 'package:dockge_dashboard/routing/routes.dart';
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
  bool _isConverting = false;

  @override
  void dispose() {
    _commandController.dispose();
    super.dispose();
  }

  Future<void> _convert() async {
    if (_isConverting) return;

    final command = _commandController.text.trim();
    if (command.isEmpty) {
      ref
          .read(toastProvider.notifier)
          .showError(message: 'Enter a docker run command');
      return;
    }

    final socket = ref.read(dockgeClientProvider).socket;
    if (socket == null || !socket.connected) {
      ref
          .read(toastProvider.notifier)
          .showError(message: 'Not connected to server');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isConverting = true);

    try {
      final response = await socket.emitWithAckAsync('composerize', command);
      if (!mounted) return;

      if (response is! Map) {
        ref
            .read(toastProvider.notifier)
            .showError(message: 'Invalid response from server');
        return;
      }

      if (response['ok'] != true) {
        ref
            .read(toastProvider.notifier)
            .showError(
              message:
                  response['msg']?.toString() ?? 'Failed to convert command',
            );
        return;
      }

      final composeTemplate = response['composeTemplate'];
      if (composeTemplate is! String || composeTemplate.trim().isEmpty) {
        ref
            .read(toastProvider.notifier)
            .showError(message: 'Server returned an empty compose template');
        return;
      }

      context.replaceNamed(
        AppRouteName.stackNew,
        queryParameters: {'prefillCompose': composeTemplate},
      );
    } catch (error, stackTrace) {
      log(
        'Failed to convert docker run command',
        error: error,
        stackTrace: stackTrace,
        name: 'Composerize',
      );
      if (!mounted) return;
      ref
          .read(toastProvider.notifier)
          .showError(message: 'Failed to convert command: $error');
    } finally {
      if (mounted) {
        setState(() => _isConverting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onPress: _isConverting
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      _convert();
                    },
              size: .lg,
              prefix: _isConverting ? const FCircularProgress() : null,
              child: const Text('Convert'),
            ),
          ),
        ],
      ),
    );
  }
}
