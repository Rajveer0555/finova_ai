import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';

final categoriesProvider =
    NotifierProvider<CategoriesNotifier, List<CategoryModel>>(
      CategoriesNotifier.new,
    );

class CategoriesNotifier extends Notifier<List<CategoryModel>> {
  @override
  List<CategoryModel> build() {
    return [
      CategoryModel(
        id: "food",
        title: "Food",
        subTitle: "42 Transactions",
        money: "₹5,000",
        perc: "+12%",
        imagePath: 'assets/diet.png',
        colorValue: 0xFFFF2E54,
      ),
      CategoryModel(
        id: "travel",
        title: "Travel",
        subTitle: "12 Transactions",
        money: "₹2,500",
        perc: "-8%",
        imagePath: "assets/travel-luggage.png",
        colorValue: 0xFF00B894,
      ),
      CategoryModel(
        id: "shopping",
        title: "Shopping",
        subTitle: "8 Transactions",
        money: "₹5,000",
        perc: "-8%",
        imagePath: "assets/shopping-bag.png",
        colorValue: 0xFF00B894,
      ),
      CategoryModel(
        id: "bills",
        title: "Bills",
        subTitle: "8 Transactions",
        money: "₹3,200",
        perc: "+5%",
        imagePath: "assets/bill.png",
        colorValue: 0xFFFF2E54,
      ),
    ];
  }

  void addCategory(CategoryModel category) {
    state = [...state, category]; // 🔥 updates UI instantly
  }

  void removeCategory(String id) {
    state = state.where((c) => c.id != id).toList();
  }
}
