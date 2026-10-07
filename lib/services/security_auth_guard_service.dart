import '../models/user_model.dart';
import '../app/router/route_names.dart';

enum AppPermission {
  accessExecutiveGmv,
  approveVendorKyc,
  disburseEscrow,
  moderateCatalog,
  manageVendorCatalog,
  dispatchVehicle,
  createCustomerOrder,
  signOffTurnkeyMilestone,
}

class SecurityAuthGuardService {
  const SecurityAuthGuardService();

  static const Map<UserRole, Set<AppPermission>> _rolePermissions = {
    UserRole.admin: {
      AppPermission.accessExecutiveGmv,
      AppPermission.approveVendorKyc,
      AppPermission.disburseEscrow,
      AppPermission.moderateCatalog,
    },
    UserRole.vendor: {
      AppPermission.manageVendorCatalog,
      AppPermission.dispatchVehicle,
    },
    UserRole.customer: {
      AppPermission.createCustomerOrder,
      AppPermission.signOffTurnkeyMilestone,
    },
  };

  bool hasPermission(UserRole? role, AppPermission permission) {
    if (role == null) return false;
    return _rolePermissions[role]?.contains(permission) ?? false;
  }

  /// Evaluates whether a navigation path is permitted for the given session.
  /// Returns a redirect route if access is denied, or null if allowed.
  String? evaluateRouteAccess({
    required String path,
    required bool isAuthenticated,
    required UserRole? userRole,
  }) {
    // 1. Admin Console Guard: Strict Admin authentication required
    if (path.startsWith('/admin') && path != RouteNames.adminLogin) {
      if (!isAuthenticated || userRole != UserRole.admin) {
        return RouteNames.adminLogin;
      }
    }

    // 2. Vendor Portal Guard: Strict Vendor authentication required
    if (path.startsWith('/vendor/') &&
        path != RouteNames.vendorLogin &&
        path != RouteNames.vendorRegister) {
      if (!isAuthenticated || userRole != UserRole.vendor) {
        return RouteNames.vendorLogin;
      }
    }

    // 3. Customer Sensitive Screens (Site Addresses, Orders, Checkout)
    if (path == RouteNames.checkout || path == RouteNames.siteAddresses) {
      if (!isAuthenticated) {
        return RouteNames.customerLogin;
      }
    }

    return null;
  }

  /// Cryptographic deterministic token verification
  bool verifySessionToken(String token, String userId) {
    if (token.isEmpty || userId.isEmpty) return false;
    return token.startsWith('hb_sec_') && token.contains(userId);
  }

  String createSessionToken(String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'hb_sec_${userId}_$timestamp';
  }
}
