import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';

/// Interactive Onboarding Experience for One Stop House Builder (Delhi-NCR)
class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onComplete;

  const OnboardingScreen({
    super.key,
    this.onComplete,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<Map<String, dynamic>> _slides = [
    {
      'icon': '🏗️',
      'tag': 'DELHI-NCR MATERIALS MARKETPLACE',
      'title': 'Direct-From-Plant\nConstruction Materials',
      'description':
          'Order certified UltraTech/Ambuja cement, Tata Tiscon Fe550D TMT steel, Grade-A red kiln bricks, and graded aggregates delivered directly to Delhi, Gurugram, Noida, Faridabad & Ghaziabad sites.',
      'highlights': [
        'Weighbridge slip verification on every dispatch',
        'Zero pilferage GPS-tracked dumpers & transit mixers',
        'Transparent wholesale rates with B2B GST invoices',
      ],
      'accentColor': AppColors.primary,
    },
    {
      'icon': '🏛️',
      'tag': 'TURNKEY VILLA CONSTRUCTION',
      'title': 'Architectural Blueprints\nto Key Handover',
      'description':
          'End-to-end residential turnkey contracts executed by certified structural engineers. From soil test & excavation to MEP, smart automation, modular interiors, and occupancy certificate.',
      'highlights': [
        '100% Escrow-protected milestone payments',
        'MCD, DDA, GMDA & DTCP bylaw compliance',
        'Built-in GRAP anti-pollution buffer scheduling',
      ],
      'accentColor': AppColors.terracotta,
    },
    {
      'icon': '📐',
      'tag': 'SMART ENGINEERING SUITE',
      'title': 'Live Site Telemetry &\n80+ Engineering Calculators',
      'description':
          'Instant civil BOQ estimation, CPCB IV+ DG backup sizing, decentralized STP modeling, solar rooftop calculators, and master project handover audits at your fingertips.',
      'highlights': [
        'Real-time GPS transit tracking & delivery ETA',
        'IS 456 & IS 13920 seismic ductility checks',
        'Comprehensive 10-year structural warranty audit',
      ],
      'accentColor': AppColors.gold,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() {
    if (widget.onComplete != null) {
      widget.onComplete!();
    } else {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  void _nextPage() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentIndex == _slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Text('🏠', style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'House Builder NCR',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLastPage)
                    TextButton(
                      onPressed: _finishOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        minimumSize: const Size(48, 44),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 44, width: 48),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  final List<String> highlights = slide['highlights'] as List<String>;
                  final Color accent = slide['accentColor'] as Color;

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight - 32,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Icon & Badge Hero
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: accent.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: accent.withValues(alpha: 0.35),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    slide['icon'] as String,
                                    style: const TextStyle(fontSize: 52),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),

                              // Tag Chip
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: accent.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: accent.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  slide['tag'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: accent,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // Title
                              Text(
                                slide['title'] as String,
                                textAlign: TextAlign.center,
                                style: AppTypography.largeHeading.copyWith(
                                  fontSize: 24,
                                  height: 1.25,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),

                              // Description
                              Text(
                                slide['description'] as String,
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),

                              // Key Highlights Card
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                  boxShadow: AppSpacing.shadowSm,
                                ),
                                child: Column(
                                  children: highlights.map((h) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '✓ ',
                                            style: TextStyle(
                                              color: AppColors.success,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              h,
                                              style: AppTypography.bodySmall.copyWith(
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Bottom Navigation & Controls
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dot Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (index) {
                      final isSelected = index == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isSelected ? 24 : 8,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Action Button
                  AppButton(
                    text: isLastPage
                        ? 'Explore Construction Marketplace'
                        : 'Continue',
                    suffixIcon: isLastPage
                        ? const Icon(Icons.arrow_forward, size: 16, color: Colors.white)
                        : null,
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}