import '../data/database/app_database.dart' as db;
import '../data/repositories/cash_repository.dart';
import '../models/cash_session.dart';

class CashService {
  CashService._();

  static final CashService instance = CashService._();

  final List<CashSession> _sessions = [];

  late final db.AppDatabase _database;
  late final CashRepository _repository;

  bool _initialized = false;

  int _nextSessionId = 1;

  List<CashSession> get sessions {
    return List.unmodifiable(_sessions);
  }

  CashSession? get activeSession {
    for (final session in _sessions.reversed) {
      if (session.isOpen) {
        return session;
      }
    }

    return null;
  }

  CashSession? get lastClosedSession {
    for (final session in _sessions.reversed) {
      if (!session.isOpen) {
        return session;
      }
    }

    return null;
  }

  bool get hasOpenSession {
    return activeSession != null;
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _database = db.AppDatabase();
    _repository = CashRepository(_database);

    final storedSessions = await _repository.getAllSessions();

    _sessions
      ..clear()
      ..addAll(storedSessions.reversed);

    if (_sessions.isNotEmpty) {
      int highestId = 0;

      for (final session in _sessions) {
        if (session.id > highestId) {
          highestId = session.id;
        }
      }

      _nextSessionId = highestId + 1;
    }

    _initialized = true;
  }

  Future<CashSession?> openCash({required double openingAmount}) async {
    if (hasOpenSession || openingAmount < 0) {
      return null;
    }

    final session = CashSession(
      id: _nextSessionId,
      openedAt: DateTime.now(),
      openingAmount: openingAmount,
    );

    try {
      await _repository.saveSession(session);
    } catch (_) {
      return null;
    }

    _nextSessionId++;

    _sessions.add(session);

    return session;
  }

  Future<bool> closeCash({required double closingAmount}) async {
    final session = activeSession;

    if (session == null || closingAmount < 0) {
      return false;
    }

    session.close(amount: closingAmount);

    try {
      await _repository.saveSession(session);
    } catch (_) {
      return false;
    }

    return true;
  }
}
