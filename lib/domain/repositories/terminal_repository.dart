import 'package:dockge_dashboard/domain/models/terminal_models.dart';

abstract interface class TerminalRepository {
  Stream<TerminalOutput> watchOutput(String stackName);

  Future<String> join(String stackName, TerminalChannel channel);

  void leave(String stackName);

  void resize({
    required String stackName,
    required TerminalChannel channel,
    required int rows,
    required int columns,
  });
}
