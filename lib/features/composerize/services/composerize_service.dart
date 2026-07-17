import 'package:dockge_dashboard/app/services/dockge_api_service.dart';
import 'package:dockge_dashboard/features/composerize/models/composerize_result_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'composerize_service.g.dart';

/// Owns the Docker command to Compose conversion for the composerize slice.
final class ComposerizeService {
  const ComposerizeService(this._api);

  final DockgeApiService _api;

  Future<String> convert(String command) async {
    final result = ComposerizeResultDto.fromResponse(
      await _api.request('composerize', command),
    );
    if (!result.isSuccessful) {
      throw StateError(result.message ?? 'Failed to convert command');
    }
    final template = result.composeTemplate;
    if (template == null || template.trim().isEmpty) {
      throw StateError('Server returned an empty compose template');
    }
    return template;
  }
}

@riverpod
ComposerizeService composerizeService(Ref ref) =>
    ComposerizeService(ref.watch(dockgeApiServiceProvider));
