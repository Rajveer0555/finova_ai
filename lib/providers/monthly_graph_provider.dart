import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finova_ai/models/monthly_graph.dart';
import 'package:finova_ai/providers/transactions_stream_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lastSixMonthsExpenseProvider = Provider<List<double>>((ref) {
  final transactionsAsync = ref.watch(transactionsStreamProvider);
  final snapshot = transactionsAsync.value;

  if (snapshot == null) {
    return List.filled(6, 0);
  }

  final referenceDate = DateTime.now();
  final monthlyTotals = <String, double>{};

  for (final doc in snapshot.docs) {
    final data = doc.data();
    final amount = _readAmount(data['amount']);
    final date = _readDate(data['date']);
    if (date == null) {
      continue;
    }

    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    monthlyTotals[key] = (monthlyTotals[key] ?? 0) + amount;
  }

  final result = <double>[];
  for (int i = 5; i >= 0; i--) {
    final month = DateTime(referenceDate.year, referenceDate.month - i, 1);
    final key = '${month.year}-${month.month.toString().padLeft(2, '0')}';
    result.add(monthlyTotals[key] ?? 0);
  }

  return result;
});

final lastSixMonthLabelsProvider = Provider<List<String>>((ref) {
  final referenceDate = DateTime.now();

  final labels = <String>[];
  for (int i = 5; i >= 0; i--) {
    final month = DateTime(referenceDate.year, referenceDate.month - i, 1);
    labels.add(_monthName(month.month));
  }

  return labels;
});

final monthlyGraphProvider = Provider<MonthlyGraphData>((ref) {
  final transactionsAsync = ref.watch(transactionsStreamProvider);
  final snapshot = transactionsAsync.value;

  if (snapshot == null) {
    return MonthlyGraphData(
      values: List.filled(6, 0),
      labels: List.filled(6, ''),
      highestValue: 0,
      highestMonth: '',
      lowestValue: 0,
      lowestMonth: '',
    );
  }

  final referenceDate = DateTime.now();
  final monthlyTotals = <String, double>{};

  for (final doc in snapshot.docs) {
    final data = doc.data();
    final amount = _readAmount(data['amount']);
    final date = _readDate(data['date']);
    if (date == null) {
      continue;
    }

    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    monthlyTotals[key] = (monthlyTotals[key] ?? 0) + amount;
  }

  final values = <double>[];
  final labels = <String>[];
  for (int i = 5; i >= 0; i--) {
    final month = DateTime(referenceDate.year, referenceDate.month - i, 1);
    final key = '${month.year}-${month.month.toString().padLeft(2, '0')}';
    values.add(monthlyTotals[key] ?? 0);
    labels.add(_monthName(month.month));
  }

  double highest = 0;
  double lowest = values.isEmpty ? 0 : values.first;
  int highestIndex = 0;
  int lowestIndex = 0;

  for (int i = 0; i < values.length; i++) {
    if (values[i] > highest) {
      highest = values[i];
      highestIndex = i;
    }

    if (values[i] < lowest) {
      lowest = values[i];
      lowestIndex = i;
    }
  }

  return MonthlyGraphData(
    values: values,
    labels: labels,
    highestValue: highest,
    highestMonth: labels[highestIndex],
    lowestValue: lowest,
    lowestMonth: labels[lowestIndex],
  );
});

double _readAmount(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0.0;
}

DateTime? _readDate(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is DateTime) {
    return value;
  }
  return null;
}

String _monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return months[month - 1];
}
