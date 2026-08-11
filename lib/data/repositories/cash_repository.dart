import 'package:drift/drift.dart' as drift;

import '../../models/cash_session.dart' as domain;
import '../database/app_database.dart' as db;

class CashRepository {
  CashRepository(this.database);

  final db.AppDatabase database;

  Future<void> saveSession(domain.CashSession session) async {
    await database
        .into(database.cashSessions)
        .insertOnConflictUpdate(
          db.CashSessionsCompanion.insert(
            id: drift.Value(session.id),
            openedAt: session.openedAt,
            openingAmount: session.openingAmount,
            closedAt: drift.Value(session.closedAt),
            closingAmount: drift.Value(session.closingAmount),
            isOpen: drift.Value(session.isOpen),
          ),
        );
  }

  Future<List<domain.CashSession>> getAllSessions() async {
    final rows = await (database.select(
      database.cashSessions,
    )..orderBy([(table) => drift.OrderingTerm.desc(table.openedAt)])).get();

    return rows.map((row) {
      return domain.CashSession(
        id: row.id,
        openedAt: row.openedAt,
        openingAmount: row.openingAmount,
        closedAt: row.closedAt,
        closingAmount: row.closingAmount,
        isOpen: row.isOpen,
      );
    }).toList();
  }

  Future<domain.CashSession?> getActiveSession() async {
    final query = database.select(database.cashSessions)
      ..where((table) => table.isOpen.equals(true))
      ..orderBy([(table) => drift.OrderingTerm.desc(table.openedAt)])
      ..limit(1);

    final row = await query.getSingleOrNull();

    if (row == null) {
      return null;
    }

    return domain.CashSession(
      id: row.id,
      openedAt: row.openedAt,
      openingAmount: row.openingAmount,
      closedAt: row.closedAt,
      closingAmount: row.closingAmount,
      isOpen: row.isOpen,
    );
  }

  Future<domain.CashSession?> getLastClosedSession() async {
    final query = database.select(database.cashSessions)
      ..where((table) => table.isOpen.equals(false))
      ..orderBy([(table) => drift.OrderingTerm.desc(table.closedAt)])
      ..limit(1);

    final row = await query.getSingleOrNull();

    if (row == null) {
      return null;
    }

    return domain.CashSession(
      id: row.id,
      openedAt: row.openedAt,
      openingAmount: row.openingAmount,
      closedAt: row.closedAt,
      closingAmount: row.closingAmount,
      isOpen: row.isOpen,
    );
  }

  Future<void> deleteSession(int sessionId) async {
    await (database.delete(
      database.cashSessions,
    )..where((table) => table.id.equals(sessionId))).go();
  }
}
