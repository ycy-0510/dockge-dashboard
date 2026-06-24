import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:dockge_dashboard/features/auth/providers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(authControllerProvider).loginStatus;
    if (status == LoginStatus.loading) {
      return const FScaffold(
        child: Center(child: FCircularProgress(size: .xl)),
      );
    }
    return FScaffold(child: LoginForm());
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
    return SafeArea(
      child: Center(
        child: Form(
          key: _key,
          child: AutofillGroup(
            child: Column(
              spacing: 10,
              children: [
                Spacer(),
                Text(
                  "Login with your Dockge Account",
                  style: TextStyle(fontSize: 20, fontWeight: .bold),
                ),
                SizedBox(height: 20),
                FTextFormField(
                  autofillHints: const [AutofillHints.url],
                  control: FTextFieldControl.managed(controller: _endpointController),
                  label: Text("Dockge Endpoint"),
                  hint: "https://dockge.yourdomain.com",
                  keyboardType: .url,
                  textInputAction: .next,
                  inputFormatters: [],
                  autovalidateMode: .onUserInteraction,
                  validator: validateUrl,
                ),
                FTextFormField(
                  autofillHints: const [AutofillHints.username],
                  control: FTextFieldControl.managed(controller: _usernameController),
                  label: Text("Username"),
                  textInputAction: .next,
                ),
                FTextFormField.password(
                  autofillHints: const [AutofillHints.password],
                  control: FTextFieldControl.managed(controller: _passwordController),
                  textInputAction: .done,
                ),
                SizedBox(height: 20),
                FButton(
                  onPress: ref.watch(authControllerProvider).loginStatus == .loading
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
                              .read(authControllerProvider.notifier)
                              .login(
                                username: _usernameController.text,
                                password: _passwordController.text,
                              );
                        },
                  size: .lg,
                  prefix: ref.watch(authControllerProvider).loginStatus == .loading
                      ? FCircularProgress()
                      : null,
                  child: Text("Login"),
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
