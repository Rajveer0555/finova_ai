class MonthlyGraphData {
  final List<double> values;
  final List<String> labels;
  final double highestValue;
  final String highestMonth;
  final double lowestValue;
  final String lowestMonth;

  MonthlyGraphData({
    required this.values,
    required this.labels,
    required this.highestValue,
    required this.highestMonth,
    required this.lowestValue,
    required this.lowestMonth,
  });
}