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
    final maxHeight = MediaQuery.of(context).size.height * 0.65;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                "Category",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SFProText',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                itemCount: methods.length,
                itemBuilder: (context, index) {
                  final method = methods[index];
                  final bool isSelected =
                      selectedMethod.title == method["title"];

                  return GestureDetector(
                    onTap: () {
                      final selected = CategorySelectorModel(
                        title: method["title"],
                        imagePath: method["image"],
                      );
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
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.05),
                            blurRadius: 10,
                            offset: Offset(0, 4),
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
                              color:
                                  isSelected
                                      ? Colors.green
                                      : Colors.transparent,
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
