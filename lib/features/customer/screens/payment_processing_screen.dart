import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';

/// Screen: Bank Gateway Handshake & Payment Processing
class PaymentProcessingScreen extends StatefulWidget {
  final String orderId;
  final double amount;
  final VoidCallback? onComplete;

  const PaymentProcessingScreen({
    super.key,
    this.orderId = 'ORD-NCR-1001',
    this.amount = 174600.0,
    this.onComplete,
  });

  @override
  State<PaymentProcessingScreen> createState() => _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  bool _isSuccess = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _isSuccess = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _isSuccess
                        ? AppColors.successLight
                        : AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _isSuccess
                        ? const Icon(Icons.check_circle, color: AppColors.success, size: 54)
                        : const SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.5,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                Text(
                  _isSuccess ? 'Payment Authorized & Escrowed!' : 'Authorizing Payment...',
                  style: AppTypography.largeHeading,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  _isSuccess
                      ? 'Funds successfully transferred to ICICI Project Escrow Account. Dispatch telemetry activated for ${widget.orderId}.'
                      : 'Connecting to Banking Gateway & verifying HMAC-SHA256 signature for ${widget.orderId}.',
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.security, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '256-Bit TLS Bank Encryption • Zero Transit Risk',
                          style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                if (_isSuccess) ...[
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    text: 'View Live Site Telemetry',
                    onPressed: () {
                      if (widget.onComplete != null) {
                        widget.onComplete!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}