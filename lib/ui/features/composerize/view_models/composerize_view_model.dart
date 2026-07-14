import 'dart:developer';

import 'package:dockge_dashboard/ui/core/view_models/toast_notifier.dart';
import 'package:dockge_dashboard/data/repositories/dockge_stack_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'composerize_view_model.g.dart';

@riverpod
class ComposerizeViewModel extends _$ComposerizeViewModel {
  @override
  bool build() => false;

  Future<String?> convert(String command) async {
    if (state) return null;
    final trimmedCommand = command.trim();
    if (trimmedCommand.isEmpty) {
      ref.read(toastProvider.notifier).showError(message: 'Enter a docker run command');
      return null;
    }
    state = true;
    try {
      return await ref.read(stackRepositoryProvider).convertDockerRunCommand(trimmedCommand);
    } catch (error, stackTrace) {
      log(
        'Failed to convert docker run command',
        name: 'ComposerizeViewModel',
        error: error,
        stackTrace: stackTrace,
      );
      if (ref.mounted) {
        ref.read(toastProvider.notifier).showError(message: 'Failed to convert command: $error');
      }
      return null;
    } finally {
      if (ref.mounted) state = false;
    }
  }
}
