import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../theme.dart';

final _money = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
String formatMoney(double v) => _money.format(v);

String formatDate(DateTime d) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(d.year, d.month, d.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return DateFormat('MMM dd, yyyy').format(d);
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long_outlined,
                  size: 64, color: AppColors.border),
              SizedBox(height: 12),
              Text('No transactions yet',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.textDark)),
              SizedBox(height: 4),
              Text('Tap + to add your first expense',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            ],
          ),
        ),
      );
}

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final bool showActions;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onTap,
    this.onDelete,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = expense.isExpense ? AppColors.expense : AppColors.income;
    final sign = expense.isExpense ? '-' : '+';
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(expense.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text('${formatDate(expense.date)} • ${expense.category}',
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textGrey)),
                ],
              ),
            ),
            Text('$sign ${formatMoney(expense.amount)}',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w600, fontSize: 13)),
            if (showActions) ...[
              const SizedBox(width: 8),
              _MiniBtn(
                  icon: Icons.edit,
                  bg: const Color(0xFFEDEDED),
                  fg: AppColors.textDark,
                  onTap: onTap),
              _MiniBtn(
                  icon: Icons.delete,
                  bg: AppColors.expense,
                  fg: Colors.white,
                  onTap: onDelete ?? () {}),
            ],
          ],
        ),
      ),
    );
  }
}

class _MiniBtn extends StatelessWidget {
  final IconData icon;
  final Color bg, fg;
  final VoidCallback onTap;
  const _MiniBtn(
      {required this.icon,
      required this.bg,
      required this.fg,
      required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.only(left: 2),
          color: bg,
          child: Icon(icon, size: 14, color: fg),
        ),
      );
}

Future<bool> confirmDelete(BuildContext context, String title) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete transaction?'),
      content: Text('"$title" will be permanently removed.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel')),
        TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(color: AppColors.expense))),
      ],
    ),
  );
  return res ?? false;
}
