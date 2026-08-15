import '../models/app_permission.dart';
import '../models/app_user.dart';
import 'auth_service.dart';
import 'permission_service.dart';

enum AuthorizationFailureReason {
  none,
  invalidCredentials,
  inactiveUser,
  locked,
  insufficientPermission,
  storageError,
}

class AuthorizationResult {
  const AuthorizationResult._({
    required this.success,
    required this.reason,
    this.authorizedBy,
    this.lockedUntil,
  });

  final bool success;
  final AuthorizationFailureReason reason;
  final AppUser? authorizedBy;
  final DateTime? lockedUntil;

  factory AuthorizationResult.success(AppUser user) {
    return AuthorizationResult._(
      success: true,
      reason: AuthorizationFailureReason.none,
      authorizedBy: user,
    );
  }

  factory AuthorizationResult.failure(
    AuthorizationFailureReason reason, {
    DateTime? lockedUntil,
  }) {
    return AuthorizationResult._(
      success: false,
      reason: reason,
      lockedUntil: lockedUntil,
    );
  }
}

class AuthorizationService {
  AuthorizationService._();

  static final AuthorizationService instance = AuthorizationService._();

  Future<AuthorizationResult> authorize({
    required String username,
    required String pin,
    required AppPermission requiredPermission,
  }) async {
    final authResult = await AuthService.instance.verifyCredentials(
      username: username,
      pin: pin,
    );

    if (!authResult.success || authResult.user == null) {
      return _mapAuthFailure(authResult);
    }

    final authorizingUser = authResult.user!;

    final hasPermission = _userHasPermission(
      user: authorizingUser,
      permission: requiredPermission,
    );

    if (!hasPermission) {
      return AuthorizationResult.failure(
        AuthorizationFailureReason.insufficientPermission,
      );
    }

    return AuthorizationResult.success(authorizingUser);
  }

  bool _userHasPermission({
    required AppUser user,
    required AppPermission permission,
  }) {
    return PermissionService.instance.hasPermissionForUser(user, permission);
  }

  AuthorizationResult _mapAuthFailure(AuthResult result) {
    switch (result.reason) {
      case AuthFailureReason.invalidCredentials:
        return AuthorizationResult.failure(
          AuthorizationFailureReason.invalidCredentials,
        );

      case AuthFailureReason.inactiveUser:
        return AuthorizationResult.failure(
          AuthorizationFailureReason.inactiveUser,
        );

      case AuthFailureReason.locked:
        return AuthorizationResult.failure(
          AuthorizationFailureReason.locked,
          lockedUntil: result.lockedUntil,
        );

      case AuthFailureReason.storageError:
        return AuthorizationResult.failure(
          AuthorizationFailureReason.storageError,
        );

      case AuthFailureReason.none:
      case AuthFailureReason.noAdministrator:
      case AuthFailureReason.administratorAlreadyExists:
      case AuthFailureReason.invalidUserData:
        return AuthorizationResult.failure(
          AuthorizationFailureReason.invalidCredentials,
        );
    }
  }
}
