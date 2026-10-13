import 'package:flutter/material.dart';
import '../state/expense_store.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'expense_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning,';
    if (h < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    final store = ExpenseStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final recent = store.items.take(5).toList();
        return SafeArea(
          child: store.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(_greeting,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textGrey)),
                    const Text('Sahal Muhammed',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    if (store.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(store.error!,
                            style: const TextStyle(color: AppColors.expense)),
                      ),
                    const SizedBox(height: 14),
                    _BalanceCard(store: store),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(
                          child: _StatBox(
                              label: 'DAILY AVERAGE',
                              value: formatMoney(store.dailyAverage))),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _StatBox(
                              label: 'WEEKLY',
                              value: formatMoney(store.weeklyExpense))),
                    ]),
                    const SizedBox(height: 20),
                    const Text('Transactions History',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    if (recent.isEmpty)
                      const EmptyState()
                    else
                      ...recent.map((e) => ExpenseTile(
                            expense: e,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ExpenseFormScreen(expense: e))),
                          )),
                  ],
                ),
        );
      },
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final ExpenseStore store;
  const _BalanceCard({required this.store});

  Widget _col(String label, double v, IconData icon, CrossAxisAlignment a) =>
      Column(crossAxisAlignment: a, children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ]),
        const SizedBox(height: 4),
        Text(formatMoney(v),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ]);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Total Balance',
                style: TextStyle(color: Colors.white, fontSize: 12)),
            const SizedBox(height: 4),
            FittedBox(
              child: Text(formatMoney(store.balance),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _col('Income', store.totalIncome, Icons.arrow_downward,
                    CrossAxisAlignment.start),
                _col('Expenses', store.totalExpense, Icons.arrow_upward,
                    CrossAxisAlignment.end),
              ],
            ),
          ],
        ),
      );
}

class _StatBox extends StatelessWidget {
  final String label, value;
  const _StatBox({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 9, color: AppColors.textGrey)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      );
}
