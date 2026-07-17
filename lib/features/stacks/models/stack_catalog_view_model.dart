import 'dart:async';
import 'dart:developer';

import 'package:dockge_dashboard/app/shared/toast/toast_notifier.dart';
import 'package:dockge_dashboard/features/stacks/services/dockge_stack_repository.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stack_catalog_view_model.g.dart';

@riverpod
class StackCatalogViewModel extends _$StackCatalogViewModel {
  @override
  StackCatalog? build() {
    final subscription = ref
        .watch(stackRepositoryProvider)
        .watchCatalog()
        .listen(
          (catalog) {
            if (ref.mounted) state = catalog;
          },
          onError: (Object error, StackTrace stackTrace) {
            log(
              'Failed to update stack catalog',
              name: 'StackCatalogViewModel',
              error: error,
              stackTrace: stackTrace,
            );
            if (ref.mounted) {
              ref.read(toastProvider.notifier).showError(message: 'Failed to update stack list');
            }
          },
        );
    ref.onDispose(() => unawaited(subscription.cancel()));
    return null;
  }
}
