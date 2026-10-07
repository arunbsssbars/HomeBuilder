/// Centralized Route Constants
abstract class RouteNames {
  // Global & Onboarding
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelect = '/role-select';

  // Customer Authentication
  static const String customerLogin = '/login';
  static const String customerOtp = '/verify-otp';

  // Customer Marketplace
  static const String customerHome = '/customer/home';
  static const String categories = '/customer/categories';
  static const String categoryDetail = '/customer/categories/:id';
  static const String search = '/customer/search';
  static const String productDetail = '/customer/products/:id';
  static const String serviceDetail = '/customer/services/:id';
  static const String vendorStorefront = '/customer/vendors/:id';
  static const String cart = '/customer/cart';
  static const String checkout = '/customer/checkout';
  static const String paymentProcessing = '/customer/payment-processing';
  static const String paymentSuccess = '/customer/payment-success';
  static const String customerOrders = '/customer/orders';
  static const String orderDetail = '/customer/orders/:id';
  static const String liveTracking = '/customer/orders/:id/track';
  static const String customerProfile = '/customer/profile';
  static const String siteAddresses = '/customer/addresses';
  static const String customerNotifications = '/customer/notifications';
  static const String boqEstimator = '/customer/boq-estimator';

  // Vendor Portal
  static const String vendorLogin = '/vendor/login';
  static const String vendorRegister = '/vendor/register';
  static const String vendorCompleteProfile = '/vendor/complete-profile';
  static const String vendorHome = '/vendor/home';
  static const String vendorCatalog = '/vendor/catalog';
  static const String vendorProductDetail = '/vendor/products/:id';
  static const String addProduct = '/vendor/products/add';
  static const String editProduct = '/vendor/products/:id/edit';
  static const String addService = '/vendor/services/add';
  static const String editService = '/vendor/services/:id/edit';
  static const String vendorOrders = '/vendor/orders';
  static const String vendorOrderDetail = '/vendor/orders/:id';
  static const String vendorProfile = '/vendor/profile';
  static const String vendorSettings = '/vendor/settings';
  static const String vendorNotifications = '/vendor/notifications';

  // Admin Console
  static const String adminLogin = '/admin/login';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminVendors = '/admin/vendors';
  static const String adminVendorApproval = '/admin/vendors/:id/approval';
  static const String adminProducts = '/admin/products';
  static const String adminServices = '/admin/services';
  static const String adminOrders = '/admin/orders';
  static const String adminPayments = '/admin/payments';
  static const String adminCategories = '/admin/categories';
  static const String adminTurnkey = '/admin/turnkey';

  // Turnkey Construction
  static const String turnkeyLanding = '/turnkey';
  static const String turnkeyPackages = '/turnkey/packages';
  static const String turnkeyPackageDetail = '/turnkey/packages/:id';
  static const String consultationRequest = '/turnkey/consultation';
  static const String quotationViewer = '/turnkey/quotation';
  static const String projectDashboard = '/turnkey/project';
  static const String projectTimeline = '/turnkey/project/timeline';
  static const String milestoneDetail = '/turnkey/project/milestones/:id';
}
