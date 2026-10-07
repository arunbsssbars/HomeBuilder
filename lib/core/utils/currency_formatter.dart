import 'package:intl/intl.dart';

/// Formatter for Indian Rupee Currency and Quantities
abstract class CurrencyFormatter {
  static final NumberFormat _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _inrDecimalFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  /// Format an amount into standard Indian currency: e.g. ₹1,25,000
  static String format(num amount) {
    return _inrFormatter.format(amount);
  }

  /// Format with exact two decimal places: e.g. ₹1,25,000.50
  static String formatWithDecimals(num amount) {
    return _inrDecimalFormatter.format(amount);
  }

  /// Format large sums in Lacs / Crores for construction dashboards
  static String formatCompactInr(num amount) {
    if (amount >= 10000000) {
      final cr = amount / 10000000;
      return '₹${cr.toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      final lac = amount / 100000;
      return '₹${lac.toStringAsFixed(2)} L';
    } else if (amount >= 1000) {
      final k = amount / 1000;
      return '₹${k.toStringAsFixed(1)} K';
    }
    return format(amount);
  }
}
