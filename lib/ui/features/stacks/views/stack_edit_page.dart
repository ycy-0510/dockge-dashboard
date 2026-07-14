import 'package:dockge_dashboard/ui/core/view_models/toast_notifier.dart';
import 'package:dockge_dashboard/domain/models/stack_details.dart';
import 'package:dockge_dashboard/ui/features/stacks/view_models/stack_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:highlight/languages/properties.dart';
import 'package:highlight/languages/yaml.dart';

const _defaultComposeTemplate = '''services:
  app:
    image: nginx:latest
    restart: unless-stopped
    ports:
      - 8080:80
''';

class StackEditPage extends ConsumerStatefulWidget {
  final String? stackName;
  final bool isAdd;
  final String? prefillCompose;
  const StackEditPage({
    super.key,
    this.stackName,
    this.prefillCompose,
    this.isAdd = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StackEditPageState();
}

class _StackEditPageState extends ConsumerState<StackEditPage> {
  final CodeController _composeYamlController = CodeController(
    text: '',
    language: yaml,
  );
  final CodeController _composeEnvController = CodeController(
    text: '',
    language: properties,
  );
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isAdd) {
      _composeYamlController.text = widget.prefillCompose ?? _defaultComposeTemplate;
    } else {
      final stackDetails = ref.read(stackDetailsViewModelProvider).details;
      if (stackDetails != null) {
        _composeYamlController.text = stackDetails.composeYaml;
        _composeEnvController.text = stackDetails.composeEnv;
      }
    }
  }

  @override
  void dispose() {
    _composeYamlController.dispose();
    _composeEnvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit({required bool deploy}) async {
    final name = widget.isAdd ? _nameController.text.trim() : null;
    if (widget.isAdd && (name == null || name.isEmpty)) {
      ref.read(toastProvider.notifier).showError(message: 'Stack name is required');
      return;
    }
    final succeeded = await ref
        .read(stackDetailsViewModelProvider.notifier)
        .save(
          composeYaml: _composeYamlController.text,
          composeEnv: _composeEnvController.text,
          isNew: widget.isAdd,
          deploy: deploy,
          stackName: name,
        );
    if (succeeded && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        showFDialog<bool>(
          context: context,
          builder: (context, style, animation) => FDialog.adaptive(
            title: const Text('Are you sure you want to leave?'),
            body: const Text('This will discard all changes.'),
            actions: [
              FButton(
                variant: .destructive,
                onPress: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Leave'),
              ),
              FButton(
                variant: .outline,
                onPress: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ).then((confirmed) {
          if (confirmed == true && context.mounted) {
            Navigator.of(context).pop();
          }
        });
      },
      child: FScaffold(
        header: FHeader.nested(
          prefixes: [
            FHeaderAction.x(
              onPress: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).maybePop();
              },
            ),
          ],
          title: Text(widget.isAdd ? 'New Stack' : 'Edit: ${widget.stackName}'),
          suffixes: [
            FHeaderAction(
              icon: Icon(FLucideIcons.check),
              onPress: () {
                HapticFeedback.lightImpact();
                _submit(deploy: false);
              },
            ),
            FHeaderAction(
              icon: Icon(FLucideIcons.rocket),
              onPress: () {
                HapticFeedback.lightImpact();
                _submit(deploy: true);
              },
            ),
          ],
        ),
        child: StackEditBody(
          composeYamlController: _composeYamlController,
          composeEnvController: _composeEnvController,
          nameController: _nameController,
          isAdd: widget.isAdd,
        ),
      ),
    );
  }
}

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
