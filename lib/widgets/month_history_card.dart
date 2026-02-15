import 'package:finova_ai/models/transactions_model.dart';
import 'package:finova_ai/pages/history_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthHistoryCard extends StatefulWidget {
  final DateTime monthKey;
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

  Image getCategoryImage(String category) {
    switch (category) {
      case "Food":
        return Image.asset('assets/diet.png');
      case "Travel":
        return Image.asset('assets/travel-luggage.png');
      case "Shopping":
        return Image.asset('assets/shopping-bag.png');
      case "Bills":
        return Image.asset('assets/bill.png');
      default:
        return Image.asset('assets/delivery-box.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    final year = DateFormat('yyyy').format(widget.monthKey);
    final month = DateFormat('MMMM').format(widget.monthKey);
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
                      '₹ ${totalAmount.toStringAsFixed(0)}',
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
                children: widget.transactions.map(_transactionTile).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _transactionTile(TransactionModel2 t) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: InkWell(
          focusColor: Colors.black,
          splashColor: Colors.black,
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            child: Row(
              children: [
                SizedBox(
                  height: 38,
                  width: 38,
                  child: getCategoryImage(t.category),
                ),
                const SizedBox(width: 32),
        
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
      ),
    );
  }
}
