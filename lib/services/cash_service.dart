import '../models/cash_session.dart';

class CashService {
  CashService._();

  static final CashService instance = CashService._();

  final List<CashSession> _sessions = [];

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

  CashSession? openCash({required double openingAmount}) {
    if (hasOpenSession || openingAmount < 0) {
      return null;
    }

    final session = CashSession(
      id: _nextSessionId,
      openedAt: DateTime.now(),
      openingAmount: openingAmount,
    );

    _nextSessionId++;

    _sessions.add(session);

    return session;
  }

  bool closeCash({required double closingAmount}) {
    final session = activeSession;

    if (session == null || closingAmount < 0) {
      return false;
    }

    session.close(amount: closingAmount);

    return true;
  }
}
