import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory TransactionModel2.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    String method = data['paymentMethod'] ?? 'Cash';

    String image;

    switch (method) {
      case "Cash":
        image = "assets/money.png";
        break;
      case "Debit Card":
      case "Debit-card":
        image = "assets/contactless.png";
        break;
      case "Credit Card":
      case "Credit-card":
        image = "assets/credit-card.png";
        break;
      default:
        image = "assets/ewallet.png";
    }

    return TransactionModel2(
      id: doc.id,
      category: data['category'] ?? '',
      title: data['title'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      dateTime: (data['date'] as Timestamp).toDate(),
      paymentTitle: data['paymentMethod'] ?? '',
      paymentImage: data['paymentImage'] ?? image,
    );
  }
}
