import 'package:finova_ai/services/finova_ai_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinovaAiEngine', () {
    final now = DateTime(2026, 3, 28);

    AiInputTransaction tx({
      required String title,
      required String category,
      required double amount,
      required DateTime date,
    }) {
      return AiInputTransaction(
        title: title,
        categoryKey: category,
        amount: amount,
        date: date,
      );
    }

    test('returns empty result when there are no transactions', () {
      final result = FinovaAiEngine.build(
        transactions: const [],
        budgets: const {},
        monthlyIncome: 5000,
        now: now,
      );

      expect(result.hasTransactions, isFalse);
      expect(result.predictedNextMonthSpend, 0);
      expect(result.forecastCategories, isEmpty);
    });

    test('uses older history when recent windows are empty', () {
      final result = FinovaAiEngine.build(
        transactions: [
          tx(
            title: 'Metro recharge',
            category: 'travel',
            amount: 800,
            date: DateTime(2025, 12, 20),
          ),
          tx(
            title: 'Train ticket',
            category: 'travel',
            amount: 1200,
            date: DateTime(2026, 1, 5),
          ),
        ],
        budgets: const {},
        monthlyIncome: 4000,
        now: now,
      );

      final travelForecast = result.forecastCategories.firstWhere(
        (item) => item.categoryKey == 'travel',
      );

      expect(result.predictedNextMonthSpend, greaterThan(0));
      expect(travelForecast.recentAmount, 0);
      expect(travelForecast.predictedAmount, greaterThan(0));
      expect(travelForecast.changeAmount, greaterThan(0));
    });

    test('predicts positive category movement for rising spend', () {
      final result = FinovaAiEngine.build(
        transactions: [
          tx(
            title: 'Dinner',
            category: 'food',
            amount: 1800,
            date: DateTime(2026, 3, 23),
          ),
          tx(
            title: 'Lunch',
            category: 'food',
            amount: 700,
            date: DateTime(2026, 3, 10),
          ),
          tx(
            title: 'Cafe',
            category: 'food',
            amount: 1200,
            date: DateTime(2026, 2, 16),
          ),
          tx(
            title: 'Snacks',
            category: 'food',
            amount: 400,
            date: DateTime(2026, 2, 9),
          ),
          tx(
            title: 'Groceries',
            category: 'shopping',
            amount: 600,
            date: DateTime(2026, 3, 21),
          ),
          tx(
            title: 'Essentials',
            category: 'shopping',
            amount: 500,
            date: DateTime(2026, 2, 20),
          ),
        ],
        budgets: const {'food': 2200},
        monthlyIncome: 8000,
        now: now,
      );

      final foodForecast = result.forecastCategories.firstWhere(
        (item) => item.categoryKey == 'food',
      );

      expect(
        foodForecast.predictedAmount,
        greaterThan(foodForecast.recentAmount),
      );
      expect(foodForecast.changeAmount, greaterThan(0));
      expect(
        foodForecast.changeAmount,
        closeTo(
          foodForecast.predictedAmount - foodForecast.recentAmount,
          0.001,
        ),
      );
    });

    test('predicts negative category movement for cooling spend', () {
      final result = FinovaAiEngine.build(
        transactions: [
          tx(
            title: 'Restaurant',
            category: 'food',
            amount: 1000,
            date: DateTime(2026, 3, 20),
          ),
          tx(
            title: 'Dining spree',
            category: 'food',
            amount: 2500,
            date: DateTime(2026, 2, 20),
          ),
          tx(
            title: 'Weekend food',
            category: 'food',
            amount: 1500,
            date: DateTime(2026, 2, 10),
          ),
          tx(
            title: 'Cafe stop',
            category: 'food',
            amount: 250,
            date: DateTime(2025, 9, 10),
          ),
          tx(
            title: 'Snack',
            category: 'food',
            amount: 250,
            date: DateTime(2025, 6, 1),
          ),
        ],
        budgets: const {},
        monthlyIncome: 7000,
        now: now,
      );

      final foodForecast = result.forecastCategories.firstWhere(
        (item) => item.categoryKey == 'food',
      );

      expect(foodForecast.recentAmount, 1000);
      expect(foodForecast.predictedAmount, lessThan(foodForecast.recentAmount));
      expect(foodForecast.changeAmount, lessThan(0));
    });

    test('uses real calendar months for insight comparison', () {
      final result = FinovaAiEngine.build(
        transactions: [
          tx(
            title: 'April grocery',
            category: 'shopping',
            amount: 3000,
            date: DateTime(2026, 4, 12),
          ),
          tx(
            title: 'April dinner',
            category: 'food',
            amount: 700,
            date: DateTime(2026, 4, 18),
          ),
          tx(
            title: 'May grocery',
            category: 'shopping',
            amount: 1200,
            date: DateTime(2026, 5, 3),
          ),
          tx(
            title: 'Old dinner',
            category: 'food',
            amount: 5000,
            date: DateTime(2026, 2, 1),
          ),
        ],
        budgets: const {},
        monthlyIncome: 10000,
        now: DateTime(2026, 5, 12),
      );

      expect(result.currentMonthLabel, 'May');
      expect(result.previousMonthLabel, 'Apr');
      expect(result.focusCategoryKey, 'shopping');
      expect(result.currentMonthSpend, 1200);
      expect(result.previousMonthSpend, 3700);
      expect(result.monthlyDelta, -2500);
      expect(result.currentMonthCategorySpend, 1200);
      expect(result.previousMonthCategorySpend, 3000);
      expect(result.monthlyCategoryDelta, -1800);
    });
  });
}
