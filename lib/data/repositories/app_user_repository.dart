import 'package:drift/drift.dart' as drift;

import '../../models/app_user.dart' as domain;
import '../../models/user_role.dart';
import '../database/app_database.dart' as db;

class AppUserRepository {
  AppUserRepository(this.database);

  final db.AppDatabase database;

  Future<List<domain.AppUser>> getAllUsers() async {
    final rows = await (database.select(
      database.appUsers,
    )..orderBy([(table) => drift.OrderingTerm.asc(table.displayName)])).get();

    return rows.map(_toDomain).toList();
  }

  Future<domain.AppUser?> getUserById(int userId) async {
    final row = await (database.select(
      database.appUsers,
    )..where((table) => table.id.equals(userId))).getSingleOrNull();

    if (row == null) {
      return null;
    }

    return _toDomain(row);
  }

  Future<domain.AppUser?> getUserByUsername(String username) async {
    final cleanUsername = username.trim().toLowerCase();

    if (cleanUsername.isEmpty) {
      return null;
    }

    final row =
        await (database.select(database.appUsers)
              ..where((table) => table.username.equals(cleanUsername)))
            .getSingleOrNull();

    if (row == null) {
      return null;
    }

    return _toDomain(row);
  }

  Future<int> createUser({
    required String username,
    required String displayName,
    required UserRole role,
    required String pinHash,
    required String pinSalt,
    required int pinHashVersion,
    bool requiresPinChange = false,
  }) async {
    final cleanUsername = username.trim().toLowerCase();

    final cleanDisplayName = displayName.trim();

    if (cleanUsername.isEmpty ||
        cleanDisplayName.isEmpty ||
        pinHash.trim().isEmpty ||
        pinSalt.trim().isEmpty) {
      throw ArgumentError('Los datos del usuario no son válidos.');
    }

    final now = DateTime.now();

    return database
        .into(database.appUsers)
        .insert(
          db.AppUsersCompanion.insert(
            username: cleanUsername,
            displayName: cleanDisplayName,
            role: role.name,
            pinHash: pinHash,
            pinSalt: pinSalt,
            pinHashVersion: drift.Value(pinHashVersion),
            requiresPinChange: drift.Value(requiresPinChange),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> updateUserProfile({
    required int userId,
    required String username,
    required String displayName,
    required UserRole role,
  }) async {
    final cleanUsername = username.trim().toLowerCase();

    final cleanDisplayName = displayName.trim();

    if (cleanUsername.isEmpty || cleanDisplayName.isEmpty) {
      throw ArgumentError('Los datos del usuario no son válidos.');
    }

    await (database.update(
      database.appUsers,
    )..where((table) => table.id.equals(userId))).write(
      db.AppUsersCompanion(
        username: drift.Value(cleanUsername),
        displayName: drift.Value(cleanDisplayName),
        role: drift.Value(role.name),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateLoginSecurity({
    required int userId,
    required int failedLoginAttempts,
    DateTime? lockedUntil,
    DateTime? lastLoginAt,
  }) async {
    await (database.update(
      database.appUsers,
    )..where((table) => table.id.equals(userId))).write(
      db.AppUsersCompanion(
        failedLoginAttempts: drift.Value(failedLoginAttempts),
        lockedUntil: drift.Value(lockedUntil),
        lastLoginAt: drift.Value(lastLoginAt),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  Future<void> updatePin({
    required int userId,
    required String pinHash,
    required String pinSalt,
    required int pinHashVersion,
    bool requiresPinChange = false,
  }) async {
    await (database.update(
      database.appUsers,
    )..where((table) => table.id.equals(userId))).write(
      db.AppUsersCompanion(
        pinHash: drift.Value(pinHash),
        pinSalt: drift.Value(pinSalt),
        pinHashVersion: drift.Value(pinHashVersion),
        requiresPinChange: drift.Value(requiresPinChange),
        failedLoginAttempts: const drift.Value(0),
        lockedUntil: const drift.Value(null),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  Future<void> setUserActive({
    required int userId,
    required bool isActive,
  }) async {
    await (database.update(
      database.appUsers,
    )..where((table) => table.id.equals(userId))).write(
      db.AppUsersCompanion(
        isActive: drift.Value(isActive),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  Future<bool> hasAdministrator() async {
    final row =
        await (database.select(database.appUsers)
              ..where(
                (table) =>
                    table.role.equals(UserRole.administrator.name) &
                    table.isActive.equals(true),
              )
              ..limit(1))
            .getSingleOrNull();

    return row != null;
  }

  Future<int> countActiveAdministrators() async {
    final rows =
        await (database.select(database.appUsers)..where(
              (table) =>
                  table.role.equals(UserRole.administrator.name) &
                  table.isActive.equals(true),
            ))
            .get();

    return rows.length;
  }

  domain.AppUser _toDomain(db.AppUser row) {
    return domain.AppUser(
      id: row.id,
      username: row.username,
      displayName: row.displayName,
      role: _roleFromString(row.role),
      pinHash: row.pinHash,
      pinSalt: row.pinSalt,
      pinHashVersion: row.pinHashVersion,
      isActive: row.isActive,
      requiresPinChange: row.requiresPinChange,
      failedLoginAttempts: row.failedLoginAttempts,
      lockedUntil: row.lockedUntil,
      lastLoginAt: row.lastLoginAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  UserRole _roleFromString(String value) {
    for (final role in UserRole.values) {
      if (role.name == value) {
        return role;
      }
    }

    // Un valor desconocido nunca obtiene
    // privilegios administrativos.
    return UserRole.waiter;
  }
}
