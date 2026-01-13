class TransactionModel {
  final String id;
  final String imagePath;
  final String title;
  final String subtitle;
  final String time;
  final String amount;
  final bool isExpense;

  TransactionModel({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.amount,
    this.isExpense = true,
  });
}
