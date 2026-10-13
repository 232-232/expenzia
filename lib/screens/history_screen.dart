import 'package:flutter/material.dart';
import '../state/expense_store.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'expense_form_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = ExpenseStore.instance;
    return Column(
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Transaction History',
              style: TextStyle(fontSize: 16)),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListenableBuilder(
              listenable: store,
              builder: (context, _) {
                if (store.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total expense',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(formatMoney(store.totalExpense),
                              style: const TextStyle(
                                  color: AppColors.expense,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (store.items.isEmpty)
                      const EmptyState()
                    else
                      ...store.items.map((e) => ExpenseTile(
                            expense: e,
                            showActions: true,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ExpenseFormScreen(expense: e))),
                            onDelete: () async {
                              final ok = await confirmDelete(context, e.title);
                              if (ok && e.id != null) {
                                final done = await store.delete(e.id!);
                                if (!done && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              store.error ?? 'Delete failed')));
                                }
                              }
                            },
                          )),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
