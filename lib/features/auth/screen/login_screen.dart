import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:dockge_dashboard/features/auth/providers/auth_controller.dart';
import 'package:dockge_dashboard/features/auth/providers/local_auth.dart';
import 'package:dockge_dashboard/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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
    ref.listen(authControllerProvider, (prev, next) {
      if (prev?.error != next.error && next.error != null) {
        showFToast(
          context: context,
          icon: Icon(FLucideIcons.circleAlert),
          title: Text("Auth Error"),
          description: Text(next.error!),
        );
      }
    });
    ref.listen(dockgeClientProvider, (prev, next) {
      if (prev?.error != next.error && next.error != null) {
        showFToast(
          context: context,
          icon: Icon(FLucideIcons.circleAlert),
          title: Text("Connection Error"),
          description: Text(next.error!),
        );
      }
    });
    ref.listen(dockgeClientProvider, (prev, next) {
      if (prev?.endpoint == null && next.endpoint != null) {
        _endpointController.text = next.endpoint!;
      }
    });
    ref.listen(readyForBiometricProvider, (prev, next) async {
      if (prev != next && next) {
        await ref.read(authControllerProvider.notifier).loginWithToken();
        if (ref.read(authControllerProvider).loginStatus == .authenticated && context.mounted) {
          context.replaceNamed(AppRouteName.home);
        }
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
                          FocusScope.of(context).unfocus();
                          if (!(_key.currentState?.validate() ?? false)) return;
                          ref
                              .read(dockgeClientProvider.notifier)
                              .connect(endpoint: _endpointController.text.trim());
                          await ref
                              .read(authControllerProvider.notifier)
                              .login(
                                username: _usernameController.text,
                                password: _passwordController.text,
                              );
                          if (ref.read(authControllerProvider).loginStatus == .authenticated &&
                              context.mounted) {
                            context.replaceNamed(AppRouteName.home);
                          }
                        },
                  size: .lg,
                  child: ref.watch(authControllerProvider).loginStatus == .loading
                      ? FCircularProgress()
                      : Text("Login"),
                ),
                SizedBox(height: 20),
                if (ref.watch(readyForBiometricProvider))
                  FButton(
                    mainAxisSize: .min,
                    onPress: () async {
                      FocusScope.of(context).unfocus();
                      await ref.read(authControllerProvider.notifier).loginWithToken();
                      if (ref.read(authControllerProvider).loginStatus == .authenticated &&
                          context.mounted) {
                        context.replaceNamed(AppRouteName.home);
                      }
                    },
                    variant: FButtonVariant.ghost,
                    child: Builder(
                      builder: (context) {
                        final biometricsTypes = ref.watch(availableBiometricsProvider).value;
                        if (biometricsTypes?.contains(BiometricType.face) ?? false) {
                          return Icon(FLucideIcons.scanFace, color: Colors.blue, size: 60);
                        } else if (biometricsTypes?.contains(BiometricType.fingerprint) ?? false) {
                          return Icon(FLucideIcons.fingerprint, color: Colors.blue, size: 60);
                        } else if (biometricsTypes?.contains(BiometricType.iris) ?? false) {
                          return Icon(FLucideIcons.scanEye, color: Colors.blue, size: 60);
                        }
                        return Icon(FLucideIcons.circleAlert, color: Colors.blue, size: 30);
                      },
                    ),
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
