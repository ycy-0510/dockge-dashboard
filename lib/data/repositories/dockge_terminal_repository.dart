import 'package:dockge_dashboard/data/models/dockge_dtos.dart';
import 'package:dockge_dashboard/data/services/dockge_api_service.dart';
import 'package:dockge_dashboard/domain/models/terminal_models.dart';
import 'package:dockge_dashboard/domain/repositories/terminal_repository.dart';
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
    final result = await _api.joinTerminal(channel.terminalName(stackName));
    if (!result.isSuccessful) {
      throw StateError('Failed to join ${channel.prefix} terminal');
    }
    return result.buffer;
  }

  @override
  void leave(String stackName) => _api.leaveCombinedTerminal(stackName);

  @override
  void resize({
    required String stackName,
    required TerminalChannel channel,
    required int rows,
    required int columns,
  }) => _api.resizeTerminal(
    terminalName: channel.terminalName(stackName),
    rows: rows,
    columns: columns,
  );
}

@riverpod
TerminalRepository terminalRepository(Ref ref) =>
    DockgeTerminalRepository(ref.watch(dockgeApiServiceProvider));
