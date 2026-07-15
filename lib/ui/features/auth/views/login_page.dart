import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:dockge_dashboard/ui/features/auth/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

const double loginFormMaxWidth = 440;

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(authViewModelProvider).loginStatus;
    if (status == LoginStatus.loading) {
      return const FScaffold(
        child: Center(child: FCircularProgress(size: .xl)),
      );
    }
    return const FScaffold(childPad: false, child: LoginForm());
  }
}

/// Keeps the login form comfortably sized on wide screens and scrollable when
/// the onscreen keyboard reduces the available height.
class LoginFormLayout extends StatelessWidget {
  const LoginFormLayout({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 24, vertical: 32);

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - padding.vertical).clamp(
                0,
                double.infinity,
              ),
            ),
            child: Center(
              child: SizedBox(
                key: const Key('login-form-content'),
                width: loginFormMaxWidth,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _key = GlobalKey<FormState>();
  final _endpointController = TextEditingController(text: "https://");
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter valid endpoint url.";
    }

    final uri = Uri.tryParse(value.trim());

    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return 'Invalid url';
    }

    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return 'http and https only.';
    }

    return null;
  }

  @override
  void dispose() {
    _endpointController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(dockgeClientProvider, (prev, next) {
      if (prev?.endpoint == null && next.endpoint != null) {
        _endpointController.text = next.endpoint!;
      }
    });
    return LoginFormLayout(
      child: Form(
        key: _key,
        child: AutofillGroup(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(
                "Login with your Dockge Account",
                style: TextStyle(fontSize: 20, fontWeight: .bold),
              ),
              SizedBox(height: 20),
              FTextFormField(
                autofillHints: const [AutofillHints.url],
                control: FTextFieldControl.managed(
                  controller: _endpointController,
                ),
                label: Text("Dockge Endpoint"),
                hint: "https://dockge.yourdomain.com",
                keyboardType: .url,
                textInputAction: .next,
                inputFormatters: [],
                autovalidateMode: .onUserInteraction,
                validator: validateUrl,
                autocorrect: false,
              ),
              FTextFormField(
                autofillHints: const [AutofillHints.username],
                control: FTextFieldControl.managed(
                  controller: _usernameController,
                ),
                label: Text("Username"),
                textInputAction: .next,
              ),
              FTextFormField.password(
                autofillHints: const [AutofillHints.password],
                control: FTextFieldControl.managed(
                  controller: _passwordController,
                ),
                textInputAction: .done,
              ),
              SizedBox(height: 20),
              FButton(
                onPress: ref.watch(authViewModelProvider).loginStatus == .loading
                    ? null
                    : () async {
                        HapticFeedback.lightImpact();
                        FocusScope.of(context).unfocus();
                        if (!(_key.currentState?.validate() ?? false)) return;
                        final endpoint = _endpointController.text.trim().replaceAll(
                          RegExp(r'/+$'),
                          '',
                        );
                        ref.read(dockgeClientProvider.notifier).connect(endpoint: endpoint);
                        await ref
                            .read(authViewModelProvider.notifier)
                            .login(
                              username: _usernameController.text,
                              password: _passwordController.text,
                            );
                      },
                size: .lg,
                prefix: ref.watch(authViewModelProvider).loginStatus == .loading
                    ? FCircularProgress()
                    : null,
                child: Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@Preview(
  name: 'Login — iPad landscape',
  group: 'Authentication',
  size: Size(1180, 820),
)
Widget loginLandscapePreview() => MaterialApp(
  debugShowCheckedModeBanner: false,
  home: FTheme(
    data: FThemes.neutral.light.touch,
    child: const FScaffold(
      childPad: false,
      child: LoginFormLayout(child: _LoginFormPreviewContent()),
    ),
  ),
);

class _LoginFormPreviewContent extends StatelessWidget {
  const _LoginFormPreviewContent();

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    spacing: 10,
    children: [
      const Text(
        'Login with your Dockge Account',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 20),
      const FTextField(
        label: Text('Dockge Endpoint'),
        hint: 'https://dockge.yourdomain.com',
      ),
      const FTextField(label: Text('Username')),
      FTextField.password(),
      const SizedBox(height: 20),
      FButton(onPress: null, size: .lg, child: const Text('Login')),
    ],
  );
}
