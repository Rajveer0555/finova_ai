class TransactionModel2 {
  final String id;
  final String category;
  final String title;
  final double amount;
  final DateTime dateTime;
  final String paymentTitle;
  final String paymentImage;

  TransactionModel2({
    required this.id,
    required this.category,
    required this.title,
    required this.amount,
    required this.dateTime,
    required this.paymentTitle,
    required this.paymentImage,
  });

  TransactionModel2 copyWith({
    String? id,
    String? category,
    String? title,
    double? amount,
    DateTime? dateTime,
    String? paymentTitle,
    String? paymentImage,
  }) {
    return TransactionModel2(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      dateTime: dateTime ?? this.dateTime,
      paymentTitle: paymentTitle ?? this.paymentTitle,
      paymentImage: paymentImage ?? this.paymentImage,
    );
  }
}
