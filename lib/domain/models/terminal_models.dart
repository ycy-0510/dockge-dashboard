enum TerminalChannel {
  combined('combined'),
  compose('compose');

  const TerminalChannel(this.prefix);

  final String prefix;

  String terminalName(String stackName) => '$prefix--$stackName';
}

class TerminalOutput {
  const TerminalOutput({required this.channel, required this.text});

  final TerminalChannel channel;
  final String text;
}
