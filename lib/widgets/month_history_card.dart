import 'package:finova_ai/models/transactions_model.dart';
import 'package:finova_ai/pages/history_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthHistoryCard extends StatefulWidget {
  final String monthKey;
  final List<TransactionModel2> transactions;

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

  double get totalAmount =>
      widget.transactions.fold(0, (sum, t) => sum + t.amount);

  @override
  Widget build(BuildContext context) {
    final parts = widget.monthKey.split(' ');
    final year = parts[0];
    final month = parts[1];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        year,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
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
                    '₹ ${totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) const Divider(height: 1),
          if (isExpanded)
            Column(
              children: widget.transactions.map(_transactionTile).toList(),
            ),
        ],
      ),
    );
  }

  Widget _transactionTile(TransactionModel2 t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExpenseDetailScreen(transactionId: t.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Image.asset(t.paymentImage, height: 38),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.category,
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
                "₹ ${t.amount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
