import 'package:dockge_dashboard/app/shared/toast/toast_notifier.dart';
import 'package:dockge_dashboard/features/stacks/services/local_admin_authorization_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_access_view_model.g.dart';

@riverpod
class AdminAccessViewModel extends _$AdminAccessViewModel {
  @override
  bool build() => false;

  Future<bool> authorize() async {
    if (state) return false;
    state = true;
    try {
      return await ref.read(adminAuthorizationRepositoryProvider).authorize();
    } catch (error) {
      if (ref.mounted) {
        ref.read(toastProvider.notifier).showError(message: error.toString());
      }
      return false;
    } finally {
      if (ref.mounted) state = false;
    }
  }
}
