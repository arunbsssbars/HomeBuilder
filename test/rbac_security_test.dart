import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/app/router/route_names.dart';
import 'package:house_builder_app/models/user_model.dart';
import 'package:house_builder_app/services/security_auth_guard_service.dart';

void main() {
  const guard = SecurityAuthGuardService();

  group('Cycle 10: Enterprise RBAC & Security Guard Service Tests', () {
    test('User permissions matrix enforcement', () {
      // Admin permissions
      expect(guard.hasPermission(UserRole.admin, AppPermission.accessExecutiveGmv), isTrue);
      expect(guard.hasPermission(UserRole.admin, AppPermission.approveVendorKyc), isTrue);
      expect(guard.hasPermission(UserRole.admin, AppPermission.disburseEscrow), isTrue);
      expect(guard.hasPermission(UserRole.admin, AppPermission.manageVendorCatalog), isFalse);

      // Vendor permissions
      expect(guard.hasPermission(UserRole.vendor, AppPermission.manageVendorCatalog), isTrue);
      expect(guard.hasPermission(UserRole.vendor, AppPermission.dispatchVehicle), isTrue);
      expect(guard.hasPermission(UserRole.vendor, AppPermission.accessExecutiveGmv), isFalse);

      // Customer permissions
      expect(guard.hasPermission(UserRole.customer, AppPermission.createCustomerOrder), isTrue);
      expect(guard.hasPermission(UserRole.customer, AppPermission.signOffTurnkeyMilestone), isTrue);
      expect(guard.hasPermission(UserRole.customer, AppPermission.approveVendorKyc), isFalse);

      // Null role
      expect(guard.hasPermission(null, AppPermission.createCustomerOrder), isFalse);
    });

    test('Admin console route guard: blocks unauthenticated or non-admin users', () {
      // Unauthenticated
      final redirectUnauth = guard.evaluateRouteAccess(
        path: RouteNames.adminDashboard,
        isAuthenticated: false,
        userRole: null,
      );
      expect(redirectUnauth, RouteNames.adminLogin);

      // Customer attempting to breach admin dashboard
      final redirectCust = guard.evaluateRouteAccess(
        path: RouteNames.adminDashboard,
        isAuthenticated: true,
        userRole: UserRole.customer,
      );
      expect(redirectCust, RouteNames.adminLogin);

      // Vendor attempting to breach admin dashboard
      final redirectVendor = guard.evaluateRouteAccess(
        path: RouteNames.adminDashboard,
        isAuthenticated: true,
        userRole: UserRole.vendor,
      );
      expect(redirectVendor, RouteNames.adminLogin);

      // Legitimate Admin
      final allowAdmin = guard.evaluateRouteAccess(
        path: RouteNames.adminDashboard,
        isAuthenticated: true,
        userRole: UserRole.admin,
      );
      expect(allowAdmin, isNull);

      // Admin login screen itself is accessible without auth
      final allowLogin = guard.evaluateRouteAccess(
        path: RouteNames.adminLogin,
        isAuthenticated: false,
        userRole: null,
      );
      expect(allowLogin, isNull);
    });

    test('Vendor portal route guard: blocks unauthenticated and non-vendor users', () {
      final blocked = guard.evaluateRouteAccess(
        path: '/vendor/products',
        isAuthenticated: true,
        userRole: UserRole.customer,
      );
      expect(blocked, RouteNames.vendorLogin);

      final allowedVendor = guard.evaluateRouteAccess(
        path: '/vendor/products',
        isAuthenticated: true,
        userRole: UserRole.vendor,
      );
      expect(allowedVendor, isNull);

      final allowVendorRegister = guard.evaluateRouteAccess(
        path: RouteNames.vendorRegister,
        isAuthenticated: false,
        userRole: null,
      );
      expect(allowVendorRegister, isNull);
    });

    test('Customer protected screens require authentication', () {
      final blockedCheckout = guard.evaluateRouteAccess(
        path: RouteNames.checkout,
        isAuthenticated: false,
        userRole: null,
      );
      expect(blockedCheckout, RouteNames.customerLogin);

      final allowedCheckout = guard.evaluateRouteAccess(
        path: RouteNames.checkout,
        isAuthenticated: true,
        userRole: UserRole.customer,
      );
      expect(allowedCheckout, isNull);
    });

    test('Deterministic session token creation & verification', () {
      const userId = 'usr_delhi_9810';
      final token = guard.createSessionToken(userId);

      expect(token.startsWith('hb_sec_usr_delhi_9810_'), isTrue);
      expect(guard.verifySessionToken(token, userId), isTrue);
      expect(guard.verifySessionToken(token, 'other_user'), isFalse);
      expect(guard.verifySessionToken('', userId), isFalse);
    });
  });
}
