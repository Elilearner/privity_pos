import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/app_permission.dart';
import '../../models/app_user.dart';
import '../../services/authorization_service.dart';
import '../../services/service_locator.dart';

class AuthorizationDialogResult {
  const AuthorizationDialogResult({
    required this.authorized,
    this.authorizedBy,
  });

  final bool authorized;
  final AppUser? authorizedBy;
}

Future<AuthorizationDialogResult> showAuthorizationDialog({
  required BuildContext context,
  required AppPermission requiredPermission,
  required String actionDescription,
}) async {
  final result = await showDialog<AuthorizationDialogResult>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _AuthorizationDialog(
      requiredPermission: requiredPermission,
      actionDescription: actionDescription,
    ),
  );

  return result ?? const AuthorizationDialogResult(authorized: false);
}

class _AuthorizationDialog extends StatefulWidget {
  const _AuthorizationDialog({
    required this.requiredPermission,
    required this.actionDescription,
  });

  final AppPermission requiredPermission;
  final String actionDescription;

  @override
  State<_AuthorizationDialog> createState() => _AuthorizationDialogState();
}

class _AuthorizationDialogState extends State<_AuthorizationDialog> {
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
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.admin_panel_settings_outlined, color: AppColors.goldLight),
          SizedBox(width: 10),
          Expanded(child: Text('Autorización requerida')),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.actionDescription,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 18),

                TextFormField(
                  controller: _usernameController,
                  enabled: !_processing,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Usuario autorizador',
                    prefixIcon: Icon(Icons.account_circle_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el usuario.';
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

                    if (!RegExp(r'^[0-9]{6,8}$').hasMatch(pin)) {
                      return 'El PIN debe tener entre 6 y 8 dígitos.';
                    }

                    return null;
                  },
                  onFieldSubmitted: (_) {
                    if (!_processing) {
                      _authorize();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _processing
              ? null
              : () {
                  Navigator.pop(
                    context,
                    const AuthorizationDialogResult(authorized: false),
                  );
                },
          child: const Text('CANCELAR'),
        ),
        FilledButton.icon(
          onPressed: _processing ? null : _authorize,
          icon: _processing
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.verified_user_outlined),
          label: Text(_processing ? 'VERIFICANDO...' : 'AUTORIZAR'),
        ),
      ],
    );
  }

  Future<void> _authorize() async {
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

    final result = await Services.authorization.authorize(
      username: _usernameController.text,
      pin: _pinController.text,
      requiredPermission: widget.requiredPermission,
    );

    if (!mounted) {
      return;
    }

    if (result.success && result.authorizedBy != null) {
      Navigator.pop(
        context,
        AuthorizationDialogResult(
          authorized: true,
          authorizedBy: result.authorizedBy,
        ),
      );

      return;
    }

    setState(() {
      _processing = false;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_failureMessage(result))));
  }

  String _failureMessage(AuthorizationResult result) {
    switch (result.reason) {
      case AuthorizationFailureReason.none:
        return 'Autorización completada.';

      case AuthorizationFailureReason.invalidCredentials:
        return 'Usuario o PIN incorrecto.';

      case AuthorizationFailureReason.inactiveUser:
        return 'El usuario autorizador está inactivo.';

      case AuthorizationFailureReason.locked:
        final until = result.lockedUntil;

        if (until == null) {
          return 'El usuario está bloqueado temporalmente.';
        }

        return 'Usuario bloqueado hasta '
            '${_formatTime(until)}.';

      case AuthorizationFailureReason.insufficientPermission:
        return 'Este usuario no tiene permiso '
            'para autorizar esta acción.';

      case AuthorizationFailureReason.storageError:
        return 'No se pudo verificar la autorización.';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;

    final minute = dateTime.minute.toString().padLeft(2, '0');

    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}
