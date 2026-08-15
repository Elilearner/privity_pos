import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/app_user.dart';
import '../../models/user_role.dart';
import '../../services/app_user_service.dart';
import '../../services/service_locator.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final bool _loading = false;

  @override
  void initState() {
    super.initState();

    Services.users.addListener(_handleUsersChanged);
  }

  @override
  void dispose() {
    Services.users.removeListener(_handleUsersChanged);

    super.dispose();
  }

  void _handleUsersChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!Services.permissions.canManageUsers) {
      return const Scaffold(body: _AccessDeniedView());
    }

    final users = Services.users.users;

    return Scaffold(
      appBar: AppBar(title: const Text('Administrar usuarios')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading ? null : _showCreateUserDialog,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('NUEVO USUARIO'),
      ),
      body: RefreshIndicator(
        onRefresh: _reloadUsers,
        child: users.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [SizedBox(height: 160), _EmptyUsersView()],
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 90),
                itemCount: users.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final user = users[index];

                  return _UserCard(
                    user: user,
                    isCurrentUser: Services.auth.currentUser?.id == user.id,
                    onEdit: () {
                      _showEditUserDialog(user);
                    },
                    onToggleActive: () {
                      _toggleUserActive(user);
                    },
                    onResetPin: () {
                      _showResetPinDialog(user);
                    },
                  );
                },
              ),
      ),
    );
  }

  Future<void> _reloadUsers() async {
    try {
      await Services.users.reload();
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showMessage('No se pudieron actualizar los usuarios.');
    }
  }

  Future<void> _showCreateUserDialog() async {
    final formKey = GlobalKey<FormState>();

    final displayNameController = TextEditingController();

    final usernameController = TextEditingController();

    final pinController = TextEditingController();

    final confirmPinController = TextEditingController();

    var selectedRole = UserRole.waiter;

    var hidePin = true;
    var hideConfirmPin = true;

    final result = await showDialog<UserManagementResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        var processing = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            Future<void> submit() async {
              if (processing) {
                return;
              }

              if (!formKey.currentState!.validate()) {
                return;
              }

              setDialogState(() {
                processing = true;
              });

              final result = await Services.users.createUser(
                username: usernameController.text,
                displayName: displayNameController.text,
                role: selectedRole,
                pin: pinController.text,
                requiresPinChange: true,
              );

              if (!dialogContext.mounted) {
                return;
              }

              if (result.success) {
                Navigator.pop(dialogContext, result);

                return;
              }

              setDialogState(() {
                processing = false;
              });

              ScaffoldMessenger.of(dialogContext).showSnackBar(
                SnackBar(content: Text(_userManagementMessage(result.failure))),
              );
            }

            return AlertDialog(
              title: const Text('Nuevo usuario'),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: displayNameController,
                          enabled: !processing,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa el nombre.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        TextFormField(
                          controller: usernameController,
                          enabled: !processing,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          decoration: const InputDecoration(
                            labelText: 'Usuario',
                            prefixIcon: Icon(Icons.account_circle_outlined),
                          ),
                          validator: (value) {
                            final username = value?.trim() ?? '';

                            if (username.length < 3) {
                              return 'El usuario debe tener al menos 3 caracteres.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        DropdownButtonFormField<UserRole>(
                          initialValue: selectedRole,
                          decoration: const InputDecoration(
                            labelText: 'Rol',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                          items: UserRole.values
                              .map(
                                (role) => DropdownMenuItem<UserRole>(
                                  value: role,
                                  child: Text(_roleName(role)),
                                ),
                              )
                              .toList(),
                          onChanged: processing
                              ? null
                              : (value) {
                                  if (value == null) {
                                    return;
                                  }

                                  setDialogState(() {
                                    selectedRole = value;
                                  });
                                },
                        ),

                        const SizedBox(height: 14),

                        TextFormField(
                          controller: pinController,
                          enabled: !processing,
                          obscureText: hidePin,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          decoration: InputDecoration(
                            labelText: 'PIN',
                            helperText: 'Entre 6 y 8 dígitos',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: processing
                                  ? null
                                  : () {
                                      setDialogState(() {
                                        hidePin = !hidePin;
                                      });
                                    },
                              icon: Icon(
                                hidePin
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
                        ),

                        const SizedBox(height: 6),

                        TextFormField(
                          controller: confirmPinController,
                          enabled: !processing,
                          obscureText: hideConfirmPin,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          decoration: InputDecoration(
                            labelText: 'Confirmar PIN',
                            prefixIcon: const Icon(Icons.lock_reset_outlined),
                            suffixIcon: IconButton(
                              onPressed: processing
                                  ? null
                                  : () {
                                      setDialogState(() {
                                        hideConfirmPin = !hideConfirmPin;
                                      });
                                    },
                              icon: Icon(
                                hideConfirmPin
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value?.trim() != pinController.text.trim()) {
                              return 'Los PIN no coinciden.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'El usuario deberá cambiar este PIN más adelante.',
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
              actions: [
                TextButton(
                  onPressed: processing
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
                        },
                  child: const Text('CANCELAR'),
                ),
                FilledButton(
                  onPressed: processing ? null : submit,
                  child: Text(processing ? 'CREANDO...' : 'CREAR'),
                ),
              ],
            );
          },
        );
      },
    );

    displayNameController.dispose();
    usernameController.dispose();
    pinController.dispose();
    confirmPinController.dispose();

    if (!mounted || result == null || !result.success) {
      return;
    }

    _showMessage('Usuario creado correctamente.');
  }

  Future<void> _showEditUserDialog(AppUser user) async {
    final formKey = GlobalKey<FormState>();

    final displayNameController = TextEditingController(text: user.displayName);

    final usernameController = TextEditingController(text: user.username);

    var selectedRole = user.role;

    final result = await showDialog<UserManagementResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        var processing = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            Future<void> submit() async {
              if (processing) {
                return;
              }

              if (!formKey.currentState!.validate()) {
                return;
              }

              setDialogState(() {
                processing = true;
              });

              final result = await Services.users.updateUser(
                userId: user.id,
                username: usernameController.text,
                displayName: displayNameController.text,
                role: selectedRole,
              );

              if (!dialogContext.mounted) {
                return;
              }

              if (result.success) {
                Navigator.pop(dialogContext, result);

                return;
              }

              setDialogState(() {
                processing = false;
              });

              ScaffoldMessenger.of(dialogContext).showSnackBar(
                SnackBar(content: Text(_userManagementMessage(result.failure))),
              );
            }

            return AlertDialog(
              title: const Text('Editar usuario'),
              content: SizedBox(
                width: 420,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: displayNameController,
                        enabled: !processing,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa el nombre.';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: usernameController,
                        enabled: !processing,
                        decoration: const InputDecoration(
                          labelText: 'Usuario',
                          prefixIcon: Icon(Icons.account_circle_outlined),
                        ),
                        validator: (value) {
                          if ((value?.trim().length ?? 0) < 3) {
                            return 'El usuario debe tener al menos 3 caracteres.';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      DropdownButtonFormField<UserRole>(
                        initialValue: selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Rol',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        items: UserRole.values
                            .map(
                              (role) => DropdownMenuItem<UserRole>(
                                value: role,
                                child: Text(_roleName(role)),
                              ),
                            )
                            .toList(),
                        onChanged: processing
                            ? null
                            : (value) {
                                if (value == null) {
                                  return;
                                }

                                setDialogState(() {
                                  selectedRole = value;
                                });
                              },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: processing
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
                        },
                  child: const Text('CANCELAR'),
                ),
                FilledButton(
                  onPressed: processing ? null : submit,
                  child: Text(processing ? 'GUARDANDO...' : 'GUARDAR'),
                ),
              ],
            );
          },
        );
      },
    );

    displayNameController.dispose();
    usernameController.dispose();

    if (!mounted || result == null || !result.success) {
      return;
    }

    _showMessage('Usuario actualizado.');
  }

  Future<void> _toggleUserActive(AppUser user) async {
    final newValue = !user.isActive;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(newValue ? 'Activar usuario' : 'Desactivar usuario'),
          content: Text(
            newValue
                ? '¿Deseas activar a ${user.displayName}?'
                : '¿Deseas desactivar a ${user.displayName}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('CANCELAR'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(newValue ? 'ACTIVAR' : 'DESACTIVAR'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final result = await Services.users.setUserActive(
      userId: user.id,
      isActive: newValue,
    );

    if (!mounted) {
      return;
    }

    _showMessage(
      result.success
          ? newValue
                ? 'Usuario activado.'
                : 'Usuario desactivado.'
          : _userManagementMessage(result.failure),
    );
  }

  Future<void> _showResetPinDialog(AppUser user) async {
    final formKey = GlobalKey<FormState>();

    final pinController = TextEditingController();

    final confirmController = TextEditingController();

    var hidePin = true;

    final result = await showDialog<UserManagementResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        var processing = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            Future<void> submit() async {
              if (processing) {
                return;
              }

              if (!formKey.currentState!.validate()) {
                return;
              }

              setDialogState(() {
                processing = true;
              });

              final result = await Services.users.resetPin(
                userId: user.id,
                newPin: pinController.text,
                requiresPinChange: true,
              );

              if (!dialogContext.mounted) {
                return;
              }

              if (result.success) {
                Navigator.pop(dialogContext, result);

                return;
              }

              setDialogState(() {
                processing = false;
              });

              ScaffoldMessenger.of(dialogContext).showSnackBar(
                SnackBar(content: Text(_userManagementMessage(result.failure))),
              );
            }

            return AlertDialog(
              title: Text(
                'Restablecer PIN - '
                '${user.displayName}',
              ),
              content: SizedBox(
                width: 420,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: pinController,
                        enabled: !processing,
                        obscureText: hidePin,
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        decoration: InputDecoration(
                          labelText: 'Nuevo PIN',
                          helperText: 'Entre 6 y 8 dígitos',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: processing
                                ? null
                                : () {
                                    setDialogState(() {
                                      hidePin = !hidePin;
                                    });
                                  },
                            icon: Icon(
                              hidePin
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
                      ),

                      const SizedBox(height: 6),

                      TextFormField(
                        controller: confirmController,
                        enabled: !processing,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        decoration: const InputDecoration(
                          labelText: 'Confirmar PIN',
                          prefixIcon: Icon(Icons.lock_reset_outlined),
                        ),
                        validator: (value) {
                          if (value?.trim() != pinController.text.trim()) {
                            return 'Los PIN no coinciden.';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: processing
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
                        },
                  child: const Text('CANCELAR'),
                ),
                FilledButton(
                  onPressed: processing ? null : submit,
                  child: Text(processing ? 'GUARDANDO...' : 'RESTABLECER'),
                ),
              ],
            );
          },
        );
      },
    );

    pinController.dispose();
    confirmController.dispose();

    if (!mounted || result == null || !result.success) {
      return;
    }

    _showMessage('PIN restablecido correctamente.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static String _userManagementMessage(UserManagementFailure failure) {
    switch (failure) {
      case UserManagementFailure.none:
        return 'Operación completada.';

      case UserManagementFailure.notAuthorized:
        return 'No tienes permiso para realizar esta acción.';

      case UserManagementFailure.invalidData:
        return 'Verifica los datos ingresados.';

      case UserManagementFailure.usernameAlreadyExists:
        return 'Ese nombre de usuario ya existe.';

      case UserManagementFailure.userNotFound:
        return 'El usuario no existe.';

      case UserManagementFailure.cannotModifyOwnAccess:
        return 'No puedes modificar tu propio acceso de esta manera.';

      case UserManagementFailure.lastAdministrator:
        return 'Debe permanecer al menos un administrador activo.';

      case UserManagementFailure.storageError:
        return 'No se pudo guardar el cambio.';
    }
  }

  static String _roleName(UserRole role) {
    switch (role) {
      case UserRole.administrator:
        return 'Administrador';

      case UserRole.cashier:
        return 'Cajero';

      case UserRole.waiter:
        return 'Mesero';
    }
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.user,
    required this.isCurrentUser,
    required this.onEdit,
    required this.onToggleActive,
    required this.onResetPin,
  });

  final AppUser user;
  final bool isCurrentUser;

  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onResetPin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.goldLight.withValues(alpha: 0.12),
                child: Icon(_roleIcon(user.role), color: AppColors.goldLight),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.displayName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        if (isCurrentUser) ...[
                          const SizedBox(width: 8),
                          const Text(
                            'TÚ',
                            style: TextStyle(
                              color: AppColors.goldLight,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '@${user.username}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _roleName(user.role),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              _StatusBadge(active: user.isActive),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('EDITAR'),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onResetPin,
                  icon: const Icon(Icons.lock_reset),
                  label: const Text('PIN'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: onToggleActive,
              icon: Icon(
                user.isActive
                    ? Icons.person_off_outlined
                    : Icons.person_add_alt,
              ),
              label: Text(user.isActive ? 'DESACTIVAR' : 'ACTIVAR'),
            ),
          ),
        ],
      ),
    );
  }

  static IconData _roleIcon(UserRole role) {
    switch (role) {
      case UserRole.administrator:
        return Icons.admin_panel_settings_outlined;

      case UserRole.cashier:
        return Icons.point_of_sale_outlined;

      case UserRole.waiter:
        return Icons.room_service_outlined;
    }
  }

  static String _roleName(UserRole role) {
    switch (role) {
      case UserRole.administrator:
        return 'Administrador';

      case UserRole.cashier:
        return 'Cajero';

      case UserRole.waiter:
        return 'Mesero';
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? AppColors.goldLight : AppColors.border,
        ),
      ),
      child: Text(
        active ? 'ACTIVO' : 'INACTIVO',
        style: TextStyle(
          color: active ? AppColors.goldLight : AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _AccessDeniedView extends StatelessWidget {
  const _AccessDeniedView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 58, color: AppColors.textSecondary),
            SizedBox(height: 14),
            Text(
              'ACCESO RESTRINGIDO',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'No tienes permiso para administrar usuarios.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyUsersView extends StatelessWidget {
  const _EmptyUsersView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 58,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 14),
            Text(
              'No hay usuarios.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
