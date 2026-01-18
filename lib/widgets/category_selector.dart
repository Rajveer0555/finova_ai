import 'package:finova_ai/models/category_selector_model.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  final CategorySelectorModel initialMethod;
  const CategorySelector({super.key, required this.initialMethod});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late CategorySelectorModel selectedMethod;
  final List<Map<String, dynamic>> methods = [
    {"title": "Food", "image": "assets/diet.png"},
    {"title": "Travel", "image": "assets/travel-luggage.png"},
    {"title": "Shopping", "image": "assets/shopping-bag.png"},
    {"title": "Bills", "image": "assets/bill.png"},
    {"title": "Other", "image": "assets/delivery-box.png"},
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
              "Category",
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
                  final selected = CategorySelectorModel(
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
