import 'package:dockge_dashboard/app/services/dockge_api_service.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_dtos.dart';
import 'package:dockge_dashboard/features/stacks/models/terminal_models.dart';
import 'package:dockge_dashboard/features/stacks/services/terminal_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dockge_terminal_repository.g.dart';

final class DockgeTerminalRepository implements TerminalRepository {
  const DockgeTerminalRepository(this._api);

  final DockgeApiService _api;

  @override
  Stream<TerminalOutput> watchOutput(String stackName) => _api.agentEvents
      .map(TerminalWriteDto.tryParseAgentEvent)
      .where((event) => event != null)
      .cast<TerminalWriteDto>()
      .map((event) {
        for (final channel in TerminalChannel.values) {
          if (event.terminalName == channel.terminalName(stackName)) {
            return TerminalOutput(channel: channel, text: event.text);
          }
        }
        return null;
      })
      .where((output) => output != null)
      .cast<TerminalOutput>();

  @override
  Future<String> join(String stackName, TerminalChannel channel) async {
    final terminalName = channel.terminalName(stackName);
    final result = TerminalJoinResultDto.fromResponse(
      await _api.requestAgent('terminalJoin', <Object?>[terminalName]),
    );
    if (!result.isSuccessful) {
      throw StateError('Failed to join ${channel.prefix} terminal');
    }
    return result.buffer;
  }

  @override
  void leave(String stackName) => _api.sendAgent('leaveCombinedTerminal', <Object?>[stackName]);

  @override
  void resize({
    required String stackName,
    required TerminalChannel channel,
    required int rows,
    required int columns,
  }) => _api.sendAgent('terminalResize', <Object?>[
    channel.terminalName(stackName),
    rows,
    columns,
  ]);
}

@riverpod
TerminalRepository terminalRepository(Ref ref) =>
    DockgeTerminalRepository(ref.watch(dockgeApiServiceProvider));
