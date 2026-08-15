import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../services/auth_service.dart';
import '../../services/service_locator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _pinController = TextEditingController();

  bool _processing = false;
  bool _hidePin = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _pinController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 72,
                      color: AppColors.goldLight,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'INICIAR SESIÓN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Ingresa tu usuario y PIN para acceder a PRIVITY DRINK.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 28),

                    TextFormField(
                      controller: _usernameController,
                      enabled: !_processing,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
                        prefixIcon: Icon(Icons.account_circle_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa tu usuario.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _pinController,
                      enabled: !_processing,
                      obscureText: _hidePin,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      maxLength: 8,
                      decoration: InputDecoration(
                        labelText: 'PIN',
                        prefixIcon: const Icon(Icons.pin_outlined),
                        suffixIcon: IconButton(
                          onPressed: _processing
                              ? null
                              : () {
                                  setState(() {
                                    _hidePin = !_hidePin;
                                  });
                                },
                          icon: Icon(
                            _hidePin
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        final pin = value?.trim() ?? '';

                        if (pin.isEmpty) {
                          return 'Ingresa tu PIN.';
                        }

                        if (!RegExp(r'^[0-9]{6,8}$').hasMatch(pin)) {
                          return 'El PIN debe tener entre 6 y 8 dígitos.';
                        }

                        return null;
                      },
                      onFieldSubmitted: (_) {
                        if (!_processing) {
                          _login();
                        }
                      },
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: _processing ? null : _login,
                        icon: _processing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.login),
                        label: Text(_processing ? 'VERIFICANDO...' : 'ENTRAR'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Después de varios intentos fallidos, '
                      'la cuenta puede bloquearse temporalmente.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_processing) {
      return;
    }

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _processing = true;
    });

    final result = await Services.auth.login(
      username: _usernameController.text,
      pin: _pinController.text,
    );

    if (!mounted) {
      return;
    }

    if (result.success) {
      setState(() {
        _processing = false;
      });

      return;
    }

    setState(() {
      _processing = false;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_messageForFailure(result))));
  }

  String _messageForFailure(AuthResult result) {
    switch (result.reason) {
      case AuthFailureReason.invalidCredentials:
        return 'Usuario o PIN incorrecto.';

      case AuthFailureReason.inactiveUser:
        return 'Este usuario está desactivado.';

      case AuthFailureReason.locked:
        final until = result.lockedUntil;

        if (until == null) {
          return 'Usuario bloqueado temporalmente.';
        }

        return 'Usuario bloqueado hasta '
            '${_formatTime(until)}.';

      case AuthFailureReason.storageError:
        return 'No se pudo verificar el usuario. '
            'Inténtalo nuevamente.';

      case AuthFailureReason.noAdministrator:
        return 'No existe un administrador configurado.';

      case AuthFailureReason.administratorAlreadyExists:
      case AuthFailureReason.invalidUserData:
      case AuthFailureReason.none:
        return 'No se pudo iniciar sesión.';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;

    final minute = dateTime.minute.toString().padLeft(2, '0');

    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}
