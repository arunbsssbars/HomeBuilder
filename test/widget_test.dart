import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/app/app.dart';

void main() {
  testWidgets('HouseBuilderApp onboarding smoke test and transition to marketplace', (WidgetTester tester) async {
    // Set realistic phone screen size
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Build app with onboarding enabled
    await tester.pumpWidget(const HouseBuilderApp(initialShowOnboarding: true));
    await tester.pumpAndSettle();

    // Verify Onboarding Screen is rendered
    expect(find.text('House Builder NCR'), findsOneWidget);
    expect(find.text('DELHI-NCR MATERIALS MARKETPLACE'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    // Tap Skip to complete onboarding
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    // Verify transition into CustomerMainNavScreen
    expect(find.text('DELHI-NCR JURISDICTION'), findsOneWidget);
    expect(find.text('Direct-From-Plant Materials'), findsOneWidget);
    expect(find.text('Turnkey Villa Packages'), findsOneWidget);
  });
}
