import 'package:finova_ai/models/payment_method.dart';
import 'package:flutter/material.dart';

class PaymentMethodSheet extends StatefulWidget {
  final PaymentMethod initialMethod;
  const PaymentMethodSheet({super.key, required this.initialMethod});

  @override
  State<PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<PaymentMethodSheet> {
  late PaymentMethod selectedMethod;
  final List<Map<String, dynamic>> methods = [
    {"title": "Cash", "image": "assets/money.png"},
    {"title": "Debit Card", "image": "assets/contactless.png"},
    {"title": "Credit Card", "image": "assets/credit-card.png"},
    {"title": "Wallet", "image": "assets/ewallet.png"},
  ];

  @override
  void initState() {
    super.initState();
    // 👇 Use passed value instead of defaulting to Cash
    selectedMethod = widget.initialMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment Method",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'SFProText',
              ),
            ),

            const SizedBox(height: 16),

            ...methods.map((method) {
              final bool isSelected = selectedMethod.title == method["title"];

              return GestureDetector(
                onTap: () {
                  final selected = PaymentMethod(
                    title: method["title"],
                    imagePath: method["image"],
                  );

                  setState(() {
                    selectedMethod = selected;
                  });
                  Navigator.pop(context, selected);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        height: 40,
                        width: 40,
                        method["image"],
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          method["title"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        height: 22,
                        width: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.green
                                    : Colors.grey.shade300,
                            width: 2,
                          ),
                          color: isSelected ? Colors.green : Colors.transparent,
                        ),
                        child:
                            isSelected
                                ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
