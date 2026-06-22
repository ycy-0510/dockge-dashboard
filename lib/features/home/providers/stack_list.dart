import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:dockge_dashboard/features/home/model/stack_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stack_list.g.dart';

@riverpod
class StackList extends _$StackList {
  @override
  StackInfo? build() {
    ref.listen(dockgeClientProvider, (prev, next) {
      if (prev?.socket != next.socket && next.socket != null) {
        next.socket!.on('agent', update);
      }
    });
    ref.read(dockgeClientProvider).socket?.on('agent', update);
    return null;
  }

  void update(dynamic data) {
    try {
      if (data is! List) return;
      final list = data;
      final json = list.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
      if (json.isNotEmpty) {
        state = StackInfo.fromJson(json.first);
      }
    } catch (_) {}
  }
}
