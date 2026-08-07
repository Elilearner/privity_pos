import 'table_account.dart';

class BusinessTable {
  BusinessTable({
    required this.id,
    required this.number,
    this.name,
    List<TableAccount>? accounts,
  }) : accounts = accounts ?? [];

  final int id;
  final int number;
  String? name;
  final List<TableAccount> accounts;

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

  TableAccount? get firstAccount {
    if (accounts.isEmpty) {
      return null;
    }

    return accounts.first;
  }

  void addAccount(TableAccount account) {
    accounts.add(account);
  }

  void removeAccount(int accountId) {
    accounts.removeWhere((account) => account.id == accountId);
  }

  TableAccount? findAccount(int accountId) {
    for (final account in accounts) {
      if (account.id == accountId) {
        return account;
      }
    }

    return null;
  }
}
