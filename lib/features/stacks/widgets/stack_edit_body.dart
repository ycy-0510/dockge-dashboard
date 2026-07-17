part of '../views/stack_edit_page.dart';

class StackEditBody extends ConsumerWidget {
  const StackEditBody({
    super.key,
    required this.composeYamlController,
    required this.composeEnvController,
    required this.nameController,
    required this.isAdd,
  });
  final CodeController composeYamlController;
  final CodeController composeEnvController;
  final TextEditingController nameController;
  final bool isAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StackDetails? details = ref.watch(stackDetailsViewModelProvider).details;
    if (!isAdd && details == null) {
      return const Center(child: Text("No details info"));
    }
    final composeFileName = isAdd ? 'compose.yaml' : details!.composeFileName;

    final tabs = FTabs(
      contentPhysics: const NeverScrollableScrollPhysics(),
      onPress: (value) => HapticFeedback.lightImpact(),
      expands: true,
      children: [
        FTabEntry(
          label: Text(
            composeFileName,
            style: context.theme.typography.display.xs,
          ),
          child: _RoundedEditor(controller: composeYamlController),
        ),
        FTabEntry(
          label: const Text('.env'),
          child: _RoundedEditor(controller: composeEnvController),
        ),
      ],
    );

    if (!isAdd) return tabs;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: FTextField(
            control: .managed(controller: nameController),
            label: const Text('Stack Name'),
            hint: 'my-stack',
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: .next,
          ),
        ),
        Expanded(child: tabs),
      ],
    );
  }
}

class _RoundedEditor extends StatelessWidget {
  final CodeController controller;
  const _RoundedEditor({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: ClipRRect(
          borderRadius: .circular(20),
          child: Material(
            color: Colors.transparent,
            child: CodeTheme(
              data: CodeThemeData(
                styles: MediaQuery.of(context).platformBrightness == .dark
                    ? monokaiSublimeTheme
                    : githubTheme,
              ),
              child: CodeField(
                controller: controller,
                expands: true,
                smartQuotesType: .enabled,
                textStyle: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
                gutterStyle: const GutterStyle(
                  showFoldingHandles: true,
                  showErrors: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
