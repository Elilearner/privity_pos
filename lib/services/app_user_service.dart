import 'package:flutter/foundation.dart';

import '../data/database/app_database.dart' as db;
import '../data/repositories/app_user_repository.dart';
import '../models/app_user.dart';
import '../models/user_role.dart';
import 'auth_service.dart';
import 'permission_service.dart';
import 'pin_security_service.dart';

enum UserManagementFailure {
  none,
  notAuthorized,
  invalidData,
  usernameAlreadyExists,
  userNotFound,
  cannotModifyOwnAccess,
  lastAdministrator,
  storageError,
}

class UserManagementResult {
  const UserManagementResult._({
    required this.success,
    required this.failure,
    this.user,
  });

  final bool success;
  final UserManagementFailure failure;
  final AppUser? user;

  factory UserManagementResult.success({AppUser? user}) {
    return UserManagementResult._(
      success: true,
      failure: UserManagementFailure.none,
      user: user,
    );
  }

  factory UserManagementResult.failure(UserManagementFailure failure) {
    return UserManagementResult._(success: false, failure: failure);
  }
}

class AppUserService extends ChangeNotifier {
  AppUserService._();

  static final AppUserService instance = AppUserService._();

  late final db.AppDatabase _database;
  late final AppUserRepository _repository;

  final List<AppUser> _users = [];

  bool _initialized = false;

  List<AppUser> get users {
    return List.unmodifiable(_users);
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _database = db.AppDatabase();

    _repository = AppUserRepository(_database);

    await reload();

    _initialized = true;
  }

  Future<void> reload() async {
    final users = await _repository.getAllUsers();

    _users
      ..clear()
      ..addAll(users);

    notifyListeners();
  }

  AppUser? getUser(int userId) {
    for (final user in _users) {
      if (user.id == userId) {
        return user;
      }
    }

    return null;
  }

  Future<UserManagementResult> createUser({
    required String username,
    required String displayName,
    required UserRole role,
    required String pin,
    bool requiresPinChange = true,
  }) async {
    if (!_canManageUsers) {
      return UserManagementResult.failure(UserManagementFailure.notAuthorized);
    }

    final cleanUsername = username.trim().toLowerCase();

    final cleanDisplayName = displayName.trim();

    if (cleanUsername.length < 3 ||
        cleanDisplayName.isEmpty ||
        !PinSecurityService.instance.isValidPinFormat(pin)) {
      return UserManagementResult.failure(UserManagementFailure.invalidData);
    }

    try {
      final existing = await _repository.getUserByUsername(cleanUsername);

      if (existing != null) {
        return UserManagementResult.failure(
          UserManagementFailure.usernameAlreadyExists,
        );
      }

      final pinData = await PinSecurityService.instance.hashPin(pin);

      final userId = await _repository.createUser(
        username: cleanUsername,
        displayName: cleanDisplayName,
        role: role,
        pinHash: pinData.hash,
        pinSalt: pinData.salt,
        pinHashVersion: pinData.version,
        requiresPinChange: requiresPinChange,
      );

      await reload();

      return UserManagementResult.success(user: getUser(userId));
    } catch (_) {
      return UserManagementResult.failure(UserManagementFailure.storageError);
    }
  }

  Future<UserManagementResult> updateUser({
    required int userId,
    required String username,
    required String displayName,
    required UserRole role,
  }) async {
    if (!_canManageUsers) {
      return UserManagementResult.failure(UserManagementFailure.notAuthorized);
    }

    final current = await _repository.getUserById(userId);

    if (current == null) {
      return UserManagementResult.failure(UserManagementFailure.userNotFound);
    }

    final cleanUsername = username.trim().toLowerCase();

    final cleanDisplayName = displayName.trim();

    if (cleanUsername.length < 3 || cleanDisplayName.isEmpty) {
      return UserManagementResult.failure(UserManagementFailure.invalidData);
    }

    final sessionUser = AuthService.instance.currentUser;

    if (sessionUser?.id == userId && role != current.role) {
      return UserManagementResult.failure(
        UserManagementFailure.cannotModifyOwnAccess,
      );
    }

    if (current.role == UserRole.administrator &&
        role != UserRole.administrator &&
        current.isActive) {
      final adminCount = await _repository.countActiveAdministrators();

      if (adminCount <= 1) {
        return UserManagementResult.failure(
          UserManagementFailure.lastAdministrator,
        );
      }
    }

    try {
      final existing = await _repository.getUserByUsername(cleanUsername);

      if (existing != null && existing.id != userId) {
        return UserManagementResult.failure(
          UserManagementFailure.usernameAlreadyExists,
        );
      }

      await _repository.updateUserProfile(
        userId: userId,
        username: cleanUsername,
        displayName: cleanDisplayName,
        role: role,
      );

      await reload();

      return UserManagementResult.success(user: getUser(userId));
    } catch (_) {
      return UserManagementResult.failure(UserManagementFailure.storageError);
    }
  }

  Future<UserManagementResult> setUserActive({
    required int userId,
    required bool isActive,
  }) async {
    if (!_canManageUsers) {
      return UserManagementResult.failure(UserManagementFailure.notAuthorized);
    }

    final user = await _repository.getUserById(userId);

    if (user == null) {
      return UserManagementResult.failure(UserManagementFailure.userNotFound);
    }

    final sessionUser = AuthService.instance.currentUser;

    if (sessionUser?.id == userId && !isActive) {
      return UserManagementResult.failure(
        UserManagementFailure.cannotModifyOwnAccess,
      );
    }

    if (user.role == UserRole.administrator && user.isActive && !isActive) {
      final adminCount = await _repository.countActiveAdministrators();

      if (adminCount <= 1) {
        return UserManagementResult.failure(
          UserManagementFailure.lastAdministrator,
        );
      }
    }

    try {
      await _repository.setUserActive(userId: userId, isActive: isActive);

      await reload();

      return UserManagementResult.success(user: getUser(userId));
    } catch (_) {
      return UserManagementResult.failure(UserManagementFailure.storageError);
    }
  }

  Future<UserManagementResult> resetPin({
    required int userId,
    required String newPin,
    bool requiresPinChange = true,
  }) async {
    if (!_canManageUsers) {
      return UserManagementResult.failure(UserManagementFailure.notAuthorized);
    }

    if (!PinSecurityService.instance.isValidPinFormat(newPin)) {
      return UserManagementResult.failure(UserManagementFailure.invalidData);
    }

    final user = await _repository.getUserById(userId);

    if (user == null) {
      return UserManagementResult.failure(UserManagementFailure.userNotFound);
    }

    try {
      final pinData = await PinSecurityService.instance.hashPin(newPin);

      await _repository.updatePin(
        userId: userId,
        pinHash: pinData.hash,
        pinSalt: pinData.salt,
        pinHashVersion: pinData.version,
        requiresPinChange: requiresPinChange,
      );

      await reload();

      return UserManagementResult.success(user: getUser(userId));
    } catch (_) {
      return UserManagementResult.failure(UserManagementFailure.storageError);
    }
  }

  bool get _canManageUsers {
    return PermissionService.instance.canManageUsers;
  }
}
