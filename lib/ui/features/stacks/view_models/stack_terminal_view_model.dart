import 'dart:async';
import 'dart:developer';

import 'package:dockge_dashboard/ui/core/view_models/toast_notifier.dart';
import 'package:dockge_dashboard/data/repositories/dockge_terminal_repository.dart';
import 'package:dockge_dashboard/domain/models/terminal_models.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xterm/xterm.dart';

part 'stack_terminal_view_model.g.dart';

class StackTerminalViewState {
  const StackTerminalViewState({
    required this.stackName,
    required this.combinedTerminal,
    this.composeTerminal,
  });

  final String stackName;
  final Terminal combinedTerminal;
  final Terminal? composeTerminal;

  StackTerminalViewState copyWith({Terminal? composeTerminal}) => StackTerminalViewState(
    stackName: stackName,
    combinedTerminal: combinedTerminal,
    composeTerminal: composeTerminal,
  );
}

@riverpod
class StackTerminalViewModel extends _$StackTerminalViewModel {
  StreamSubscription<TerminalOutput>? _outputSubscription;
  String? _joinedStackName;

  @override
  StackTerminalViewState? build() {
    final repository = ref.read(terminalRepositoryProvider);
    ref.onDispose(() {
      final stackName = _joinedStackName;
      if (stackName != null) {
        repository.leave(stackName);
      }
      unawaited(_outputSubscription?.cancel());
    });
    return null;
  }

  Future<void> join(String stackName) async {
    if (_joinedStackName == stackName) return;
    final repository = ref.read(terminalRepositoryProvider);
    final previousStack = _joinedStackName;
    if (previousStack != null) repository.leave(previousStack);
    await _outputSubscription?.cancel();
    _joinedStackName = stackName;

    final combinedTerminal = _createTerminal(
      stackName,
      TerminalChannel.combined,
    );
    state = StackTerminalViewState(
      stackName: stackName,
      combinedTerminal: combinedTerminal,
    );
    combinedTerminal.write('Terminal connected: $stackName\r\n');
    _outputSubscription = repository
        .watchOutput(stackName)
        .listen(_handleOutput, onError: _handleStreamError);

    try {
      final buffers = await Future.wait<String>([
        repository.join(stackName, TerminalChannel.compose),
        repository.join(stackName, TerminalChannel.combined),
      ]);
      if (!ref.mounted || _joinedStackName != stackName) return;
      if (buffers[0].isNotEmpty) {
        final terminal = _ensureComposeTerminal(stackName);
        terminal.write(buffers[0]);
      }
      combinedTerminal.write(buffers[1]);
    } catch (error, stackTrace) {
      _reportError(error, stackTrace);
    }
  }

  void closeComposeTerminal() {
    final current = state;
    if (current == null) return;
    state = StackTerminalViewState(
      stackName: current.stackName,
      combinedTerminal: current.combinedTerminal,
    );
  }

  void _handleOutput(TerminalOutput output) {
    final current = state;
    if (current == null) return;
    switch (output.channel) {
      case .combined:
        current.combinedTerminal.write(output.text);
      case .compose:
        _ensureComposeTerminal(current.stackName).write(output.text);
    }
  }

  Terminal _ensureComposeTerminal(String stackName) {
    final existing = state?.composeTerminal;
    if (existing != null) return existing;
    final terminal = _createTerminal(stackName, TerminalChannel.compose);
    state = state?.copyWith(composeTerminal: terminal);
    return terminal;
  }

  Terminal _createTerminal(String stackName, TerminalChannel channel) => Terminal(
    maxLines: 10000,
    onBell: HapticFeedback.mediumImpact,
    onResize: (columns, rows, pixelWidth, pixelHeight) {
      ref
          .read(terminalRepositoryProvider)
          .resize(
            stackName: stackName,
            channel: channel,
            rows: rows,
            columns: columns,
          );
    },
  );

  void _handleStreamError(Object error, StackTrace stackTrace) => _reportError(error, stackTrace);

  void _reportError(Object error, StackTrace stackTrace) {
    log(
      'Terminal operation failed',
      name: 'StackTerminalViewModel',
      error: error,
      stackTrace: stackTrace,
    );
    if (ref.mounted) {
      ref.read(toastProvider.notifier).showError(message: error.toString());
    }
  }
}
