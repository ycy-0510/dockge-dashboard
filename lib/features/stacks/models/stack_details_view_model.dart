import 'dart:async';
import 'dart:developer';

import 'package:dockge_dashboard/app/shared/toast/toast_notifier.dart';
import 'package:dockge_dashboard/features/stacks/services/dockge_stack_repository.dart';
import 'package:dockge_dashboard/features/stacks/models/operation_result.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_details.dart';
import 'package:dockge_dashboard/features/stacks/services/stack_repository.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_catalog_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stack_details_view_model.g.dart';

@immutable
class StackDetailsViewState {
  const StackDetailsViewState({
    this.details,
    this.isLoading = false,
    this.errorMessage,
    this.wasDeleted = false,
  });

  final StackDetails? details;
  final bool isLoading;
  final String? errorMessage;
  final bool wasDeleted;
}

@riverpod
class StackDetailsViewModel extends _$StackDetailsViewModel {
  int _fetchRevision = 0;

  @override
  StackDetailsViewState build() {
    ref.listen(stackCatalogViewModelProvider, (previous, next) {
      final details = state.details;
      if (details == null || next == null) return;
      state = StackDetailsViewState(
        details: details.copyWith(summary: next.findByName(details.name)),
      );
    });
    return const StackDetailsViewState();
  }

  Future<void> fetch(String stackName) async {
    final revision = ++_fetchRevision;
    final currentDetails = state.details;
    state = StackDetailsViewState(
      details: currentDetails?.name == stackName ? currentDetails : null,
      isLoading: true,
    );
    try {
      var details = await ref.read(stackRepositoryProvider).fetchDetails(stackName);
      if (!ref.mounted || revision != _fetchRevision) return;
      final summary = ref.read(stackCatalogViewModelProvider)?.findByName(stackName);
      details = details.copyWith(summary: summary);
      state = StackDetailsViewState(details: details);
    } catch (error, stackTrace) {
      log(
        'Failed to load $stackName',
        name: 'StackDetailsViewModel',
        error: error,
        stackTrace: stackTrace,
      );
      if (!ref.mounted || revision != _fetchRevision) return;
      state = StackDetailsViewState(
        details: state.details,
        errorMessage: 'Failed to load stack details',
      );
      ref.read(toastProvider.notifier).showError(message: 'Failed to load stack details');
    }
  }

  Future<bool> update() => _perform(.update);
  Future<bool> restart() => _perform(.restart);
  Future<bool> start() => _perform(.start);
  Future<bool> stop() => _perform(.stop);
  Future<bool> takeDown() => _perform(.takeDown);
  Future<bool> delete() => _perform(.delete, refetch: false);

  Future<bool> save({
    required String composeYaml,
    required String composeEnv,
    required bool isNew,
    required bool deploy,
    String? stackName,
  }) async {
    final resolvedName = isNew ? stackName : state.details?.name;
    if (resolvedName == null || resolvedName.isEmpty) {
      _showError('Stack name is required');
      return false;
    }
    try {
      final result = await ref
          .read(stackRepositoryProvider)
          .saveStack(
            stackName: resolvedName,
            composeYaml: composeYaml,
            composeEnv: composeEnv,
            isNew: isNew,
            deploy: deploy,
          );
      if (!ref.mounted) return false;
      _reportResult(
        result,
        successMessage: deploy ? 'Stack deployed!' : 'Stack saved!',
        failureMessage: deploy ? 'Failed to deploy the stack.' : 'Failed to save the stack.',
      );
      if (result.isSuccessful && !isNew) unawaited(fetch(resolvedName));
      return result.isSuccessful;
    } catch (error, stackTrace) {
      _reportException(error, stackTrace);
      return false;
    }
  }

  Future<bool> _perform(StackAction action, {bool refetch = true}) async {
    final stackName = state.details?.name;
    if (stackName == null) return false;
    try {
      final result = await ref
          .read(stackRepositoryProvider)
          .performAction(action: action, stackName: stackName);
      if (!ref.mounted) return false;
      _reportResult(
        result,
        successMessage: _successMessage(action),
        failureMessage: _failureMessage(action),
      );
      if (result.isSuccessful && action == .delete) {
        state = const StackDetailsViewState(wasDeleted: true);
      } else if (result.isSuccessful && refetch) {
        unawaited(fetch(stackName));
      }
      return result.isSuccessful;
    } catch (error, stackTrace) {
      _reportException(error, stackTrace);
      return false;
    }
  }

  void _reportResult(
    OperationResult result, {
    required String successMessage,
    required String failureMessage,
  }) {
    final message = result.message ?? (result.isSuccessful ? successMessage : failureMessage);
    if (result.isSuccessful) {
      ref.read(toastProvider.notifier).showSuccess(message: message);
    } else {
      _showError(message);
    }
  }

  void _reportException(Object error, StackTrace stackTrace) {
    log(
      'Stack operation failed',
      name: 'StackDetailsViewModel',
      error: error,
      stackTrace: stackTrace,
    );
    if (ref.mounted) _showError('Stack operation failed: $error');
  }

  void _showError(String message) => ref.read(toastProvider.notifier).showError(message: message);

  String _successMessage(StackAction action) => switch (action) {
    .update => 'Stack updated!',
    .restart => 'Stack restarted!',
    .start => 'Stack started!',
    .stop => 'Stack stopped!',
    .takeDown => 'Stack stopped and made inactive!',
    .delete => 'Stack deleted!',
  };

  String _failureMessage(StackAction action) => switch (action) {
    .update => 'Failed to update the stack.',
    .restart => 'Failed to restart the stack.',
    .start => 'Failed to start the stack.',
    .stop => 'Failed to stop the stack.',
    .takeDown => 'Failed to stop and deactivate the stack.',
    .delete => 'Failed to delete the stack.',
  };
}
