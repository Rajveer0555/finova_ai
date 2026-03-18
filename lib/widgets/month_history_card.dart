import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finova_ai/models/transactions_model.dart';
import 'package:finova_ai/pages/history_detail_screen.dart';
import 'package:finova_ai/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthHistoryCard extends StatefulWidget {
  final String monthKey;
  final List<QueryDocumentSnapshot> transactions;

  const MonthHistoryCard({
    super.key,
    required this.monthKey,
    required this.transactions,
  });

  @override
  State<MonthHistoryCard> createState() => _MonthHistoryCardState();
}

class _MonthHistoryCardState extends State<MonthHistoryCard> {
  bool isExpanded = true;

  double get totalAmount => widget.transactions.fold(
    0,
    (sum, doc) => sum + TransactionModel2.fromFirestore(doc).amount,
  );

  final Map<String, String> categoryIcons = {
    "food": "assets/diet.png",
    "travel": "assets/travel-luggage.png",
    "shopping": "assets/shopping-bag.png",
    "bills": "assets/bill.png",
    "others": "assets/delivery-box.png",
  };

  @override
  Widget build(BuildContext context) {
    
    final parts = widget.monthKey.split('-');
    final date = DateTime(int.parse(parts[0]), int.parse(parts[1]));

    final year = DateFormat('yyyy').format(date);
    final month = DateFormat('MMMM').format(date);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 4), // shadow position
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            InkWell(
              splashColor: Colors.white,
              focusColor: Colors.white,
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          year,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          month,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      formatCurrency(totalAmount),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded) Divider(height: 1),
            if (isExpanded)
              Column(
                children:
                    widget.transactions
                        .map(
                          (doc) => _transactionTile(
                            TransactionModel2.fromFirestore(doc),
                          ),
                        )
                        .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Image getCategoryImage(String category) {
    return Image.asset(
      categoryIcons[category.toLowerCase()] ?? categoryIcons["others"]!,
    );
  }

  Widget _transactionTile(TransactionModel2 t) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExpenseDetailScreen(transaction: t),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            child: Row(
              children: [
                SizedBox(
                  height: 36,
                  width: 36,
                  child: getCategoryImage(t.category),
                ),
                const SizedBox(width: 32),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.category.isNotEmpty
                            ? t.category[0].toUpperCase() +
                                t.category.substring(1)
                            : 'Unknown',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM, hh:mm a').format(t.dateTime),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  "₹ ${formatCurrency(t.amount)}".replaceAll('₹ ₹', '₹'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
