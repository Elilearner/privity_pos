import 'user_role.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
    required this.pinHash,
    required this.pinSalt,
    required this.pinHashVersion,
    required this.isActive,
    required this.requiresPinChange,
    required this.failedLoginAttempts,
    required this.createdAt,
    required this.updatedAt,
    this.lockedUntil,
    this.lastLoginAt,
  });

  final int id;

  final String username;

  final String displayName;

  final UserRole role;

  final String pinHash;

  final String pinSalt;

  final int pinHashVersion;

  final bool isActive;

  final bool requiresPinChange;

  final int failedLoginAttempts;

  final DateTime? lockedUntil;

  final DateTime? lastLoginAt;

  final DateTime createdAt;

  final DateTime updatedAt;

  bool get isAdministrator {
    return role == UserRole.administrator;
  }

  bool get isCashier {
    return role == UserRole.cashier;
  }

  bool get isWaiter {
    return role == UserRole.waiter;
  }

  bool get isLocked {
    final until = lockedUntil;

    if (until == null) {
      return false;
    }

    return until.isAfter(DateTime.now());
  }
}
