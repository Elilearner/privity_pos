import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../services/auth_service.dart';
import '../../services/pin_security_service.dart';
import '../../services/service_locator.dart';

class InitialAdminSetupScreen extends StatefulWidget {
  const InitialAdminSetupScreen({
    super.key,
    required this.onAdministratorCreated,
  });

  final Future<void> Function() onAdministratorCreated;

  @override
  State<InitialAdminSetupScreen> createState() =>
      _InitialAdminSetupScreenState();
}

class _InitialAdminSetupScreenState extends State<InitialAdminSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  bool _processing = false;
  bool _hidePin = true;
  bool _hideConfirmPin = true;

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();

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
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 72,
                      color: AppColors.goldLight,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'CONFIGURACIÓN INICIAL',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Crea el primer administrador de PRIVITY DRINK.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Esta cuenta tendrá acceso completo a la '
                      'administración del sistema.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 28),

                    TextFormField(
                      controller: _displayNameController,
                      enabled: !_processing,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa el nombre del administrador.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

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
                        final username = value?.trim() ?? '';

                        if (username.isEmpty) {
                          return 'Ingresa un nombre de usuario.';
                        }

                        if (username.length < 3) {
                          return 'El usuario debe tener al menos 3 caracteres.';
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
                      textInputAction: TextInputAction.next,
                      maxLength: 8,
                      decoration: InputDecoration(
                        labelText: 'PIN',
                        helperText: 'Entre 6 y 8 dígitos',
                        prefixIcon: const Icon(Icons.lock_outline),
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

                        if (!PinSecurityService.instance.isValidPinFormat(
                          pin,
                        )) {
                          return 'El PIN debe contener entre 6 y 8 dígitos.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 6),

                    TextFormField(
                      controller: _confirmPinController,
                      enabled: !_processing,
                      obscureText: _hideConfirmPin,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      maxLength: 8,
                      decoration: InputDecoration(
                        labelText: 'Confirmar PIN',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        suffixIcon: IconButton(
                          onPressed: _processing
                              ? null
                              : () {
                                  setState(() {
                                    _hideConfirmPin = !_hideConfirmPin;
                                  });
                                },
                          icon: Icon(
                            _hideConfirmPin
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        final confirmation = value?.trim() ?? '';

                        if (confirmation != _pinController.text.trim()) {
                          return 'Los PIN no coinciden.';
                        }

                        return null;
                      },
                      onFieldSubmitted: (_) {
                        if (!_processing) {
                          _createAdministrator();
                        }
                      },
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: _processing ? null : _createAdministrator,
                        icon: _processing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.admin_panel_settings),
                        label: Text(
                          _processing ? 'CREANDO...' : 'CREAR ADMINISTRADOR',
                        ),
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

  Future<void> _createAdministrator() async {
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

    final result = await Services.auth.createInitialAdministrator(
      username: _usernameController.text,
      displayName: _displayNameController.text,
      pin: _pinController.text,
    );

    if (!mounted) {
      return;
    }

    if (!result.success) {
      setState(() {
        _processing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_messageForFailure(result.reason))),
      );

      return;
    }

    await widget.onAdministratorCreated();

    if (!mounted) {
      return;
    }

    setState(() {
      _processing = false;
    });
  }

  String _messageForFailure(AuthFailureReason reason) {
    switch (reason) {
      case AuthFailureReason.administratorAlreadyExists:
        return 'Ya existe un administrador.';

      case AuthFailureReason.invalidUserData:
        return 'Verifica los datos ingresados.';

      case AuthFailureReason.storageError:
        return 'No se pudo guardar el administrador.';

      case AuthFailureReason.none:
      case AuthFailureReason.invalidCredentials:
      case AuthFailureReason.inactiveUser:
      case AuthFailureReason.locked:
      case AuthFailureReason.noAdministrator:
        return 'No se pudo crear el administrador.';
    }
  }
}
