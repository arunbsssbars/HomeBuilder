import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/customer/screens/customer_main_nav_screen.dart';

/// HouseBuilderApp root application widget with responsive onboarding and dashboard flow
class HouseBuilderApp extends StatefulWidget {
  final bool initialShowOnboarding;

  const HouseBuilderApp({
    super.key,
    this.initialShowOnboarding = true,
  });

  @override
  State<HouseBuilderApp> createState() => _HouseBuilderAppState();
}

class _HouseBuilderAppState extends State<HouseBuilderApp> {
  late bool _showOnboarding;

  @override
  void initState() {
    super.initState();
    _showOnboarding = widget.initialShowOnboarding;
  }

  void _completeOnboarding() {
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'One Stop House Builder (Delhi-NCR)',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: _showOnboarding
            ? OnboardingScreen(onComplete: _completeOnboarding)
            : const CustomerMainNavScreen(),
      ),
    );
  }
}
