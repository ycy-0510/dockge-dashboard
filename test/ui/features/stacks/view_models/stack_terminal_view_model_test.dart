import 'package:dockge_dashboard/data/repositories/dockge_terminal_repository.dart';
import 'package:dockge_dashboard/domain/models/terminal_models.dart';
import 'package:dockge_dashboard/domain/repositories/terminal_repository.dart';
import 'package:dockge_dashboard/ui/features/stacks/view_models/stack_terminal_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('leaves the joined terminal when the provider is disposed', () async {
    final repository = _FakeTerminalRepository();
    final container = ProviderContainer(
      overrides: [
        terminalRepositoryProvider.overrideWithValue(repository),
      ],
    );
    final subscription = container.listen(
      stackTerminalViewModelProvider,
      (_, _) {},
      fireImmediately: true,
    );

    await container.read(stackTerminalViewModelProvider.notifier).join('example-stack');

    subscription.close();
    container.dispose();

    expect(repository.leftStacks, ['example-stack']);
  });
}

class _FakeTerminalRepository implements TerminalRepository {
  final List<String> leftStacks = [];

  @override
  Future<String> join(String stackName, TerminalChannel channel) async => '';

  @override
  void leave(String stackName) => leftStacks.add(stackName);

  @override
  void resize({
    required String stackName,
    required TerminalChannel channel,
    required int rows,
    required int columns,
  }) {}

  @override
  Stream<TerminalOutput> watchOutput(String stackName) => const Stream.empty();
}
