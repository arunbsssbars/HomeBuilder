import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';
import '../../models/service_model.dart';
import '../../models/turnkey_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

// Auth Screens
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/customer_login_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/auth/screens/vendor_login_screen.dart';
import '../../features/auth/screens/vendor_register_screen.dart';
import '../../features/auth/screens/admin_login_screen.dart';
import '../../features/auth/screens/role_select_screen.dart';

// Customer Screens
import '../../features/customer/screens/customer_main_nav_screen.dart';
import '../../features/customer/screens/category_detail_screen.dart';
import '../../features/customer/screens/search_screen.dart';
import '../../features/customer/screens/product_detail_screen.dart';
import '../../features/customer/screens/service_detail_screen.dart';
import '../../features/customer/screens/vendor_storefront_screen.dart';
import '../../features/customer/screens/checkout_screen.dart';
import '../../features/customer/screens/payment_processing_screen.dart';
import '../../features/customer/screens/payment_success_screen.dart';
import '../../features/customer/screens/order_detail_screen.dart';
import '../../features/customer/screens/live_tracking_screen.dart';
import '../../features/customer/screens/site_addresses_screen.dart';
import '../../features/customer/screens/notifications_screen.dart';
import '../../features/customer/screens/boq_estimator_screen.dart';

// Vendor Screens
import '../../features/vendor/screens/vendor_main_nav_screen.dart';
import '../../features/vendor/screens/vendor_complete_profile_screen.dart';
import '../../features/vendor/screens/add_edit_product_screen.dart';
import '../../features/vendor/screens/add_edit_service_screen.dart';
import '../../features/vendor/screens/vendor_order_detail_screen.dart';
import '../../features/vendor/screens/vendor_settings_screen.dart';
import '../../features/vendor/screens/vendor_notifications_screen.dart';

// Admin Screens
import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/admin/screens/admin_vendors_screen.dart';
import '../../features/admin/screens/vendor_kyc_approval_screen.dart';
import '../../features/admin/screens/admin_products_screen.dart';
import '../../features/admin/screens/admin_services_screen.dart';
import '../../features/admin/screens/admin_orders_screen.dart';
import '../../features/admin/screens/admin_payments_screen.dart';
import '../../features/admin/screens/admin_categories_screen.dart';
import '../../features/admin/screens/admin_turnkey_packages_screen.dart';

// Turnkey Screens
import '../../features/turnkey/screens/turnkey_landing_screen.dart';
import '../../features/turnkey/screens/turnkey_packages_screen.dart';
import '../../features/turnkey/screens/turnkey_package_detail_screen.dart';
import '../../features/turnkey/screens/consultation_request_screen.dart';
import '../../features/turnkey/screens/quotation_viewer_screen.dart';
import '../../features/turnkey/screens/customer_project_dashboard_screen.dart';
import '../../features/turnkey/screens/project_timeline_screen.dart';
import '../../features/turnkey/screens/milestone_detail_screen.dart';
import '../../services/security_auth_guard_service.dart';

/// Centralized Declarative Router for One Stop House Builder with Role Guards
class AppRouter {
  static const SecurityAuthGuardService _authGuard = SecurityAuthGuardService();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      final path = state.uri.path;
      try {
        final auth = ProviderScope.containerOf(context, listen: false).read(authProvider);
        return _authGuard.evaluateRouteAccess(
          path: path,
          isAuthenticated: auth.isAuthenticated,
          userRole: auth.user?.role,
        );
      } catch (_) {
        return _authGuard.evaluateRouteAccess(
          path: path,
          isAuthenticated: false,
          userRole: null,
        );
      }
    },
    routes: [
      // Global & Auth
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.roleSelect,
        builder: (context, state) => const RoleSelectScreen(),
      ),

























































































        builder: (context, state) => const CustomerMainNavScreen(initialIndex: 3),
      ),
      GoRoute(
        path: '/customer/orders/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final order = state.extra as OrderModel?;
          return OrderDetailScreen(orderId: id, initialOrder: order);
        },
      ),
      GoRoute(
        path: '/customer/orders/:id/track',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final order = state.extra as OrderModel?;
          return LiveTrackingScreen(orderId: id, order: order);
        },
      ),
      GoRoute(
        path: RouteNames.customerProfile,
        builder: (context, state) => const CustomerMainNavScreen(initialIndex: 4),
      ),
      GoRoute(
        path: RouteNames.siteAddresses,
        builder: (context, state) => const SiteAddressesScreen(),
      ),
      GoRoute(
        path: RouteNames.customerNotifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: RouteNames.boqEstimator,
        builder: (context, state) => const BOQEstimatorScreen(),
      ),

      // Vendor Flow
      GoRoute(
        path: RouteNames.vendorHome,
        builder: (context, state) => const VendorMainNavScreen(initialIndex: 0),
      ),
      GoRoute(
        path: RouteNames.vendorCompleteProfile,
        builder: (context, state) => const VendorCompleteProfileScreen(),
      ),
      GoRoute(