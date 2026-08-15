import 'package:drift/drift.dart';

class AppUsers extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get username => text().unique()();

  TextColumn get displayName => text()();

  TextColumn get role => text()();

  TextColumn get pinHash => text()();

  TextColumn get pinSalt => text()();

  IntColumn get pinHashVersion => integer().withDefault(const Constant(1))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  BoolColumn get requiresPinChange =>
      boolean().withDefault(const Constant(false))();

  IntColumn get failedLoginAttempts =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get lockedUntil => dateTime().nullable()();

  DateTimeColumn get lastLoginAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();
}
