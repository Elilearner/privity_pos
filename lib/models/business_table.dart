import 'open_account.dart';

class BusinessTable {
  BusinessTable({
    required this.id,
    required this.number,
    this.name,
    List<OpenAccount>? accounts,
  }) : accounts = accounts ?? [];

  final int id;
  final int number;

  String? name;

  final List<OpenAccount> accounts;

  bool get isOccupied {
    return accounts.isNotEmpty;
  }

  double get total {
    return accounts.fold(0, (sum, account) => sum + account.subtotal);
  }

  int get totalAccounts {
    return accounts.length;
  }

  int get totalItems {
    return accounts.fold(0, (sum, account) => sum + account.totalItems);
  }

  OpenAccount? get firstAccount {
    if (accounts.isEmpty) {
      return null;
    }

    return accounts.first;
  }

  void addAccount(OpenAccount account) {
    accounts.add(account);
  }

  void removeAccount(int accountId) {
    accounts.removeWhere((account) => account.id == accountId);
  }

  OpenAccount? findAccount(int accountId) {
    for (final account in accounts) {
      if (account.id == accountId) {
        return account;
      }
    }

    return null;
  }
}
