import '../models/app_permission.dart';
import '../models/app_user.dart';
import '../models/user_role.dart';
import 'auth_service.dart';

class PermissionService {
  PermissionService._();

  static final PermissionService instance = PermissionService._();

  AppUser? get _currentUser {
    return AuthService.instance.currentUser;
  }

  bool hasPermission(AppPermission permission) {
    final user = _currentUser;

    if (user == null) {
      return false;
    }

    return hasPermissionForUser(user, permission);
  }

  bool hasPermissionForUser(AppUser user, AppPermission permission) {
    if (!user.isActive) {
      return false;
    }

    return _permissionsForRole(user.role).contains(permission);
  }

  bool hasAny(Iterable<AppPermission> permissions) {
    for (final permission in permissions) {
      if (hasPermission(permission)) {
        return true;
      }
    }

    return false;
  }

  bool hasAll(Iterable<AppPermission> permissions) {
    for (final permission in permissions) {
      if (!hasPermission(permission)) {
        return false;
      }
    }

    return true;
  }

  Set<AppPermission> _permissionsForRole(UserRole role) {
    switch (role) {
      case UserRole.administrator:
        return AppPermission.values.toSet();

      case UserRole.cashier:
        return const {
          AppPermission.viewTables,
          AppPermission.manageTableAccounts,

          AppPermission.viewBar,
          AppPermission.manageBarAccounts,

          AppPermission.moveOpenAccounts,

          AppPermission.processSales,

          AppPermission.viewCash,
          AppPermission.openCashSession,
          AppPermission.closeCashSession,

          AppPermission.viewSalesHistory,

          AppPermission.viewProducts,

          AppPermission.viewSettings,
          AppPermission.managePrinter,
        };

      case UserRole.waiter:
        return const {
          AppPermission.viewTables,
          AppPermission.manageTableAccounts,

          AppPermission.viewBar,
          AppPermission.manageBarAccounts,

          AppPermission.moveOpenAccounts,

          AppPermission.processSales,

          AppPermission.viewProducts,
        };
    }
  }

  bool get canManageBusinessModules {
    return hasPermission(AppPermission.manageBusinessModules);
  }

  bool get canManageProducts {
    return hasPermission(AppPermission.manageProducts);
  }

  bool get canManageInventory {
    return hasPermission(AppPermission.manageInventory);
  }

  bool get canManageUsers {
    return hasPermission(AppPermission.manageUsers);
  }

  bool get canViewSettings {
    return hasPermission(AppPermission.viewSettings);
  }

  bool get canViewCash {
    return hasPermission(AppPermission.viewCash);
  }

  bool get canViewSalesHistory {
    return hasPermission(AppPermission.viewSalesHistory);
  }

  bool get canMoveOpenAccounts {
    return hasPermission(AppPermission.moveOpenAccounts);
  }

  bool get canProcessSales {
    return hasPermission(AppPermission.processSales);
  }
}
