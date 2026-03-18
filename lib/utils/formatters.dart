import 'package:intl/intl.dart';

/// Formats numbers using Indian numbering system (thousands, lakhs, crores).
///
/// Examples:
/// - 1000 -> "1,000"
/// - 100000 -> "1,00,000"
/// - 12345678 -> "1,23,45,678"
String formatNumber(double value) {
  final formatter = NumberFormat.decimalPattern('en_IN');
  return formatter.format(value);
}

/// Formats a value as currency in Indian format (₹) without decimals.
String formatCurrency(double value) {
  final formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );
  return formatter.format(value);
}

/// Formats a percentage value with one decimal place.
///
/// Example: 2.345 -> "2.3%"
String formatPercentage(double value, {int decimalDigits = 1}) {
  return "${value.toStringAsFixed(decimalDigits)}%";
}
