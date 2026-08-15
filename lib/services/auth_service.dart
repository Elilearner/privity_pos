import 'package:flutter/foundation.dart';

import '../data/database/app_database.dart' as db;
import '../data/repositories/app_user_repository.dart';
import '../models/app_user.dart';
import '../models/user_role.dart';
import 'pin_security_service.dart';

enum AuthFailureReason {
  none,
  invalidCredentials,
  inactiveUser,
  locked,
  noAdministrator,
  administratorAlreadyExists,
  invalidUserData,
  storageError,
}

class AuthResult {
  const AuthResult._({
    required this.success,
    required this.reason,
    this.user,
    this.lockedUntil,
  });

  final bool success;
  final AuthFailureReason reason;
  final AppUser? user;
  final DateTime? lockedUntil;

  factory AuthResult.success(AppUser user) {
    return AuthResult._(
      success: true,
      reason: AuthFailureReason.none,
      user: user,
    );
  }

  factory AuthResult.failure(
    AuthFailureReason reason, {
    DateTime? lockedUntil,
  }) {
    return AuthResult._(
      success: false,
      reason: reason,
      lockedUntil: lockedUntil,
    );
  }
}

class AuthService extends ChangeNotifier {
  AuthService._();

  static final AuthService instance = AuthService._();

  late final db.AppDatabase _database;
  late final AppUserRepository _repository;

  bool _initialized = false;

  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  bool get isAuthenticated {
    return _currentUser != null;
  }

  bool get isAdministrator {
    return _currentUser?.role == UserRole.administrator;
  }

  bool get isCashier {
    return _currentUser?.role == UserRole.cashier;
  }

  bool get isWaiter {
    return _currentUser?.role == UserRole.waiter;
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _database = db.AppDatabase();

    _repository = AppUserRepository(_database);

    _initialized = true;
  }

  Future<bool> hasAdministrator() async {
    _ensureInitialized();

    return _repository.hasAdministrator();
  }

  Future<AuthResult> createInitialAdministrator({
    required String username,
    required String displayName,
    required String pin,
  }) async {
    _ensureInitialized();

    final cleanUsername = username.trim().toLowerCase();

    final cleanDisplayName = displayName.trim();

    if (cleanUsername.isEmpty ||
        cleanDisplayName.isEmpty ||
        !PinSecurityService.instance.isValidPinFormat(pin)) {
      return AuthResult.failure(AuthFailureReason.invalidUserData);
    }

    try {
      final administratorExists = await _repository.hasAdministrator();

      if (administratorExists) {
        return AuthResult.failure(AuthFailureReason.administratorAlreadyExists);
      }

      final existingUser = await _repository.getUserByUsername(cleanUsername);

      if (existingUser != null) {
        return AuthResult.failure(AuthFailureReason.invalidUserData);
      }

      final pinData = await PinSecurityService.instance.hashPin(pin);

      final userId = await _repository.createUser(
        username: cleanUsername,
        displayName: cleanDisplayName,
        role: UserRole.administrator,
        pinHash: pinData.hash,
        pinSalt: pinData.salt,
        pinHashVersion: pinData.version,
      );

      final createdUser = await _repository.getUserById(userId);

      if (createdUser == null) {
        return AuthResult.failure(AuthFailureReason.storageError);
      }

      _currentUser = createdUser;

      notifyListeners();

      return AuthResult.success(createdUser);
    } catch (_) {
      return AuthResult.failure(AuthFailureReason.storageError);
    }
  }

  Future<AuthResult> login({
    required String username,
    required String pin,
  }) async {
    final result = await verifyCredentials(
      username: username,
      pin: pin,
      updateLastLogin: true,
    );

    if (!result.success || result.user == null) {
      return result;
    }

    _currentUser = result.user;

    notifyListeners();

    return result;
  }

  /// Verifica usuario y PIN sin modificar la sesión actual.
  ///
  /// Este método será utilizado para autorizaciones
  /// administrativas puntuales.
  Future<AuthResult> verifyCredentials({
    required String username,
    required String pin,
    bool updateLastLogin = false,
  }) async {
    _ensureInitialized();

    final cleanUsername = username.trim().toLowerCase();

    if (cleanUsername.isEmpty || pin.trim().isEmpty) {
      return AuthResult.failure(AuthFailureReason.invalidCredentials);
    }

    AppUser? user;

    try {
      user = await _repository.getUserByUsername(cleanUsername);
    } catch (_) {
      return AuthResult.failure(AuthFailureReason.storageError);
    }

    if (user == null) {
      return AuthResult.failure(AuthFailureReason.invalidCredentials);
    }

    if (!user.isActive) {
      return AuthResult.failure(AuthFailureReason.inactiveUser);
    }

    final now = DateTime.now();

    final lockedUntil = user.lockedUntil;

    if (lockedUntil != null && lockedUntil.isAfter(now)) {
      return AuthResult.failure(
        AuthFailureReason.locked,
        lockedUntil: lockedUntil,
      );
    }

    final validPin = await PinSecurityService.instance.verifyPin(
      pin: pin,
      storedHash: user.pinHash,
      storedSalt: user.pinSalt,
      hashVersion: user.pinHashVersion,
    );

    if (!validPin) {
      return _registerFailedLogin(user);
    }

    try {
      await _repository.updateLoginSecurity(
        userId: user.id,
        failedLoginAttempts: 0,
        lockedUntil: null,
        lastLoginAt: updateLastLogin ? now : user.lastLoginAt,
      );

      final refreshedUser = await _repository.getUserById(user.id);

      if (refreshedUser == null) {
        return AuthResult.failure(AuthFailureReason.storageError);
      }

      return AuthResult.success(refreshedUser);
    } catch (_) {
      return AuthResult.failure(AuthFailureReason.storageError);
    }
  }

  void logout() {
    if (_currentUser == null) {
      return;
    }

    _currentUser = null;

    notifyListeners();
  }

  Future<AuthResult> _registerFailedLogin(AppUser user) async {
    final attempts = user.failedLoginAttempts + 1;

    DateTime? lockedUntil;

    if (attempts >= 5) {
      final lockSeconds = _calculateLockSeconds(attempts);

      lockedUntil = DateTime.now().add(Duration(seconds: lockSeconds));
    }

    try {
      await _repository.updateLoginSecurity(
        userId: user.id,
        failedLoginAttempts: attempts,
        lockedUntil: lockedUntil,
      );
    } catch (_) {
      return AuthResult.failure(AuthFailureReason.storageError);
    }

    if (lockedUntil != null) {
      return AuthResult.failure(
        AuthFailureReason.locked,
        lockedUntil: lockedUntil,
      );
    }

    return AuthResult.failure(AuthFailureReason.invalidCredentials);
  }

  int _calculateLockSeconds(int failedAttempts) {
    final escalationLevel = failedAttempts - 5;

    var seconds = 30;

    for (var index = 0; index < escalationLevel; index++) {
      seconds *= 2;

      if (seconds >= 900) {
        return 900;
      }
    }

    return seconds;
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('AuthService debe inicializarse antes de usarse.');
    }
  }
}
