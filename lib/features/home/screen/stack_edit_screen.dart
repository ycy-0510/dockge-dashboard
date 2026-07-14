import 'package:dockge_dashboard/core/providers/toast_notifier.dart';
import 'package:dockge_dashboard/features/home/model/stack_detail_info.dart';
import 'package:dockge_dashboard/features/home/providers/stack_detail.dart';
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
  const StackEditPage({super.key, this.stackName, this.prefillCompose, this.isAdd = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StackEditPageState();
}

class _StackEditPageState extends ConsumerState<StackEditPage> {
  final CodeController _composeYAMLController = CodeController(text: '', language: yaml);
  final CodeController _composeENVController = CodeController(text: '', language: properties);
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isAdd) {
      _composeYAMLController.text = widget.prefillCompose ?? _defaultComposeTemplate;
    } else {
      final stackDetail = ref.read(stackDetailProvider);
      if (stackDetail != null) {
        _composeYAMLController.text = stackDetail.composeYAML;
        _composeENVController.text = stackDetail.composeENV;
      }
    }
  }

  @override
  void dispose() {
    _composeYAMLController.dispose();
    _composeENVController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit({required bool deploy}) {
    final name = widget.isAdd ? _nameController.text.trim() : null;
    if (widget.isAdd && (name == null || name.isEmpty)) {
      ref.read(toastProvider.notifier).showError(message: 'Stack name is required');
      return;
    }
    void callback(bool isOk) {
      if (isOk && mounted) context.pop();
    }

    final notifier = ref.read(stackDetailProvider.notifier);
    if (deploy) {
      notifier.deploy(
        composeYAML: _composeYAMLController.text,
        composeENV: _composeENVController.text,
        isAdd: widget.isAdd,
        stackName: name,
        callback: callback,
      );
    } else {
      notifier.save(
        composeYAML: _composeYAMLController.text,
        composeENV: _composeENVController.text,
        isAdd: widget.isAdd,
        stackName: name,
        callback: callback,
      );
    }
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
          composeYAMLController: _composeYAMLController,
          composeENVController: _composeENVController,
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
    required this.composeYAMLController,
    required this.composeENVController,
    required this.nameController,
    required this.isAdd,
  });
  final CodeController composeYAMLController;
  final CodeController composeENVController;
  final TextEditingController nameController;
  final bool isAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StackDetailInfo? detailInfo = ref.watch(stackDetailProvider);
    if (!isAdd && detailInfo == null) {
      return const Center(child: Text("No details info"));
    }
    final composeFileName = isAdd ? 'compose.yaml' : detailInfo!.composeFileName;

    final tabs = FTabs(
      contentPhysics: const NeverScrollableScrollPhysics(),
      onPress: (value) => HapticFeedback.lightImpact(),
      expands: true,
      children: [
        FTabEntry(
          label: Text(composeFileName, style: context.theme.typography.display.xs),
          child: _RoundedEditor(controller: composeYAMLController),
        ),
        FTabEntry(
          label: const Text('.env'),
          child: _RoundedEditor(controller: composeENVController),
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
                textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                gutterStyle: const GutterStyle(showFoldingHandles: true, showErrors: false),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
