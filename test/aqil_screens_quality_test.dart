import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/app/theme/app_theme.dart';
import 'package:house_builder_app/features/auth/screens/onboarding_screen.dart';
import 'package:house_builder_app/features/auth/screens/role_select_screen.dart';
import 'package:house_builder_app/features/customer/screens/boq_estimator_screen.dart';
import 'package:house_builder_app/features/customer/screens/checkout_screen.dart';
import 'package:house_builder_app/features/customer/screens/customer_home_screen.dart';
import 'package:house_builder_app/features/customer/screens/customer_main_nav_screen.dart';
import 'package:house_builder_app/features/customer/screens/live_tracking_screen.dart';
import 'package:house_builder_app/features/customer/screens/order_detail_screen.dart';
import 'package:house_builder_app/features/customer/screens/payment_processing_screen.dart';
import 'package:house_builder_app/features/customer/screens/search_screen.dart';
import 'package:house_builder_app/features/turnkey/screens/consultation_request_screen.dart';
import 'package:house_builder_app/features/turnkey/screens/milestone_detail_screen.dart';
import 'package:house_builder_app/features/turnkey/screens/turnkey_landing_screen.dart';

void main() {
  const viewports = <Size>[
    Size(320, 568),  // Compact Mobile (iPhone SE)
    Size(393, 852),  // Standard Mobile (iPhone 15)
    Size(412, 915),  // Large Mobile (Pixel 8 Pro)
    Size(800, 1280), // Tablet Portrait / Kiosk
    Size(1280, 800), // Desktop Landscape
  ];

  const fontScales = <double>[1.0, 1.3, 1.5];

  setUp(() {
    FlutterError.onError = (FlutterErrorDetails details) {
      final buffer = StringBuffer();
      buffer.writeln('DETAILS SUMMARY: ${details.summary}');
      for (final d in details.informationCollector?.call() ?? <DiagnosticsNode>[]) {
        buffer.writeln('INFO: ${d.name}: ${d.toString()}');
      }
      debugPrint(buffer.toString());
    };
  });

  Future<void> runMatrixTest(
    WidgetTester tester, {
    required Widget child,
    required String screenName,
  }) async {
    final recordedErrors = <String>[];
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      recordedErrors.add(details.toString());
      FlutterError.dumpErrorToConsole(details);
    };

    try {
      for (final size in viewports) {
        for (final scale in fontScales) {
          tester.view.physicalSize = Size(size.width * 2, size.height * 2);
          tester.view.devicePixelRatio = 2.0;

          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(
                theme: AppTheme.lightTheme,
                home: MediaQuery(
                  data: MediaQueryData(
                    size: size,
                    textScaler: TextScaler.linear(scale),
                  ),
                  child: child,
                ),
              ),
            ),
          );
          await tester.pump();
        }
      }
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    } finally {
      FlutterError.onError = originalOnError;
    }

    expect(
      recordedErrors,
      isEmpty,
      reason: '$screenName failed with ${recordedErrors.length} layout errors across matrix',
    );
  }

  group('AQIL Quality Matrix — All 13 Screens', () {
    testWidgets('1. OnboardingScreen renders without overflow across viewports', (tester) async {
      await runMatrixTest(
        tester,
        child: const OnboardingScreen(),
        screenName: 'OnboardingScreen',
      );
    });

    testWidgets('2. RoleSelectScreen renders without overflow across viewports', (tester) async {
      await runMatrixTest(
        tester,
        child: const RoleSelectScreen(),
        screenName: 'RoleSelectScreen',
      );
    });

    testWidgets('3. CustomerHomeScreen renders without overflow across viewports', (tester) async {
      await runMatrixTest(
        tester,
        child: const CustomerHomeScreen(),
        screenName: 'CustomerHomeScreen',
      );
    });

    testWidgets('4. CustomerMainNavScreen renders without overflow across viewports', (tester) async {
      await runMatrixTest(
        tester,
        child: const CustomerMainNavScreen(),
        screenName: 'CustomerMainNavScreen',
      );
    });

    testWidgets('5. BOQEstimatorScreen renders without overflow across viewports', (tester) async {
      await runMatrixTest(
        tester,
        child: const BOQEstimatorScreen(),
        screenName: 'BOQEstimatorScreen',
      );
    });

    testWidgets('6. CheckoutScreen renders without overflow across viewports', (tester) async {
      await runMatrixTest(
        tester,
        child: const CheckoutScreen(),
        screenName: 'CheckoutScreen',
      );
    });

    testWidgets('7. LiveTrackingScreen renders without overflow across viewports', (tester) async {
      await runMatrixTest(
        tester,
        child: const LiveTrackingScreen(orderId: 'ORD-NCR-1001'),
        screenName: 'LiveTrackingScreen',
      );
    });

    testWidgets('8. OrderDetailScreen renders without overflow across viewports', (tester) async {
      await runMatrixTest(
        tester,
        child: const OrderDetailScreen(orderId: 'ORD-NCR-1001'),
        screenName: 'OrderDetailScreen',
      );
    });

    testWidgets('9. PaymentProcessingScreen renders without overflow across viewports', (tester) async {
      await runMatrixTest(
        tester,
        child: const PaymentProcessingScreen(),
        screenName: 'PaymentProcessingScreen',
      );
    });

    testWidgets('10. SearchScreen renders without overflow across viewports', (tester) async {
      await runMatrixTest(
        tester,
        child: const SearchScreen(),
        screenName: 'SearchScreen',
      );
    });

    testWidgets('11. TurnkeyLandingScreen renders without overflow across viewports', (tester) async {
      await runMatrixTest(
        tester,
        child: const TurnkeyLandingScreen(),
        screenName: 'TurnkeyLandingScreen',
      );
    });

    testWidgets('12. ConsultationRequestScreen renders without overflow across viewports', (tester) async {
      await runMatrixTest(
        tester,
        child: const ConsultationRequestScreen(),
        screenName: 'ConsultationRequestScreen',
      );
    });

    testWidgets('13. MilestoneDetailScreen renders without overflow across viewports', (tester) async {
      await runMatrixTest(
        tester,
        child: const MilestoneDetailScreen(milestoneId: 'MLST-01'),
        screenName: 'MilestoneDetailScreen',
      );
    });
  });
}
